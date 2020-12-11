library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_mic is
	generic (
		parallelism_doble: integer:=32; -- parallelismo dopo la moltiplicazione
		
		parallelism_op: integer:=16 --parallelismo dopo filtro
			  );
				
	port (
		pdm_in: in std_logic;
		clk: in std_logic;
		rst: in std_logic;
		en1: in std_logic; -- enable registro pdm-pcm e filtro
		en2: in std_logic; -- en decimatore
		en3: in std_logic; -- en reg 3 (reg energia)
		en4: in std_logic; -- en reg4 (reg x16)
		en5: in std_logic; -- en reg5 ricorsione somma
		rst_reg5: in std_logic; -- reset registro 5 accumulatore
		out_energy: out signed(parallelism_doble-1 downto 0)
		
		 );
	end branch_mic;
		
	architecture structural of branch_mic is
	
	signal pdm_sig: std_logic; --segnale pdm in ingresso
	signal filter_in_sig: signed(parallelism_op-1 downto 0); -- segnale di appoggio in ingresso al filtro
	signal filtered_sig: signed(parallelism_doble-1 downto 0); -- segnale di appoggio in uscita dal filtro
	signal filtered_shift_sig: signed(parallelism_doble-1 downto 0); --segnale di appoggio per shiftare di 15 bit
	signal filt16_sig: signed(parallelism_op-1 downto 0); -- segnale in uscita dal filtro riportato su 16 bit
	signal filt_dec_sig: signed(parallelism_op-1 downto 0); -- segnaledi appoggio dopo il decimatore

	signal out_mult_sig:  signed(parallelism_doble-1 downto 0); -- segnale di appoggio per uscire dalla moltiplicazione (parallelismo doppio perch� � una moltiplicazione
	signal out_reg2_sig:  signed(parallelism_doble-1 downto 0); -- segnale di appoggio in uscita dal reg2
	signal recorsive_sum2_sig: signed(parallelism_doble-1 downto 0); -- segnale di appoggio per la ricorsione della somma 2
	signal out_sum2_sig: signed(parallelism_doble-1 downto 0); -- segnale di appoggio per uscire dal sommatore 2 (33 bit per evitare overflow)
	signal out_energy_sig: signed(parallelism_doble-1 downto 0); -- segnale di appoggio per l'uscita 
	
	---------------
		
	
		
		---------------
	
		component register_mic
			generic ( 
				parallelism: integer := 16 
						);
			port( 
				clk: in std_logic; 
				Rst: in std_logic;
				D: in signed(parallelism-1 downto 0);
				q: out signed(parallelism-1 downto 0);
				en: in std_logic 
				);	
		end component;	
		
	  ---------------
		
			
			component sommatore_mic
			
				generic ( 
						parallelism: integer := 16 
							);
				port(
					s1: in signed(parallelism -1 downto 0);
					s2: in signed(parallelism -1 downto 0);
					sum: out signed(parallelism-1 downto 0) 
					);
				end component;
				
		  ---------------
				
				component moltiplicatore_mic
					generic ( 
						parallelism: integer :=16 
							  );
					port(
						input: in signed( parallelism-1  downto 0);
						A_x2: out signed(parallelism*2-1 downto 0) 	
						 );
				end component;
				
			---------------
			
				component pdm_reg_mic
						
					port( clk, Rst: in std_logic;
							D:  in std_logic;
							q: out std_logic;
							en: in std_logic 
						 );
				end component;
				
		   --------------
			   
				component filter_mic
				
				generic (  
					  input_width          : integer     :=16;
					  output_width     : integer     :=32;
					  coef_width          : integer     :=16;
					  tap                    : integer     :=24;
					  guard               : integer     :=0);
				 port(  
						en : in std_logic;
						Din          : in      signed(input_width-1 downto 0);
						Clk          : in      std_logic; 
						reset     : in      std_logic;  
						Dout     : out      signed(output_width-1 downto 0));
				   
	
				end component;
				
				
				component sign_conv_mic
					generic(parallelism: integer:=16);
					port(
						pdm_in: in std_logic;
						sign_out: out signed(parallelism-1 downto 0)
					);
				end component;
				
		begin
		
		---------------
		
		
		---------------
		
		pdm_reg: component pdm_reg_mic --Reg1 (e' a un bit, arriva o 0 o 1)
		
		port map(
		clk=>clk,
		Rst=>rst,
		D=>pdm_in,
		q=>pdm_sig,
		en=>en1
		);
		
		--------------
		
		sign_conv: component sign_conv_mic  
		generic map(parallelism=> parallelism_op)
		port map(
		pdm_in=>pdm_sig,
		sign_out=> filter_in_sig
		);
					
		--------------
		
		filter: component filter_mic
		port map(
		en=> en1, --pilotato insieme ai regisri a 2 MHz
		Din=>filter_in_sig,
		Reset=>rst,
		clk=>clk,
		Dout=>filtered_sig
		);
		--------------
		--Ritrasformo in 16 bit
		
		filtered_shift_sig<=shift_left(filtered_sig,16); --spostiamo di 16 posizioni, taglio anche il segno
		filt16_sig<=filtered_shift_sig(31 downto 16); --mi sono riportato su 16 bit
				
		--------------
		
		decimator: component register_mic --registro decimatore
		generic map(
			parallelism=>parallelism_op
					  )
		port map(
			clk=>clk,
			Rst=>rst,
			D=>filt16_sig,
			q=>filt_dec_sig,
			en=>en2
		);
		
		--------------
		
		mult: component moltiplicatore_mic
		generic map(
			parallelism=>parallelism_op
					  )
		port map(
			input=>filt_dec_sig,
			A_x2=>out_mult_sig
				  );
				  
		--------------
		
		reg_x10: component register_mic --reg_4
		generic map(
			parallelism=>parallelism_doble
					  )
		port map(
			clk=>clk,
			Rst=>rst,
			D=>out_mult_sig, 
			q=>out_reg2_sig, -- parallelismo 32
			en=>en4
		);
		
		--------------
				
		sum2: component sommatore_mic --sommatore 
		generic map(
			parallelism=>parallelism_doble
						)
		port map(
			s1=>out_reg2_sig,
			s2=>recorsive_sum2_sig, --parallelismo 32
			sum=>out_sum2_sig
		);
		
		--------------
		
		reg_sum: component register_mic --registro riscorsione somma , reg_5
		generic map(
			parallelism=>parallelism_doble
					  )
		port map(
			clk=>clk,
			Rst=>rst_reg5, -- viene resettato dalla cu
			D=>out_sum2_sig,
			q=>recorsive_sum2_sig,
			en=>en5
		);
		
		--------------
		
		reg_energy: component register_mic --registro energia, reg_3
		generic map(
			parallelism=>parallelism_doble
					  )
		port map(
			clk=>clk,
			Rst=>rst,
			D=>out_sum2_sig,
			q=>out_energy,
			en=>en3
		);
		
	--in_sum_33<=shift_left(resize(out_reg2_sig,33),1); -- resize su 33 bit

	end architecture;
