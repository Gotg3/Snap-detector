library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath_mic is
generic(
   S: std_logic_vector := "01010011"; --codice ASCII per la S
	D: std_logic_vector := "01000100";-- codice ASCII per la D
	N: std_logic_vector := "01001110"; --codice ASCII per la N
   parallelism_out: integer:=8;
	parallelism_doble: integer:=32;
	parallelism_op: integer:=16;
	n_cnt1:integer:=11; -- contatore 1 (conta 12 ) 
	n_cnt2: integer:=624; -- contatore 2 (conta 625 per andare a 40Khz) 
	n_cnt3: integer:=8; -- contatore 3 (conta 15 per fare tutte e 15 le somme) -- prova 08/05/20 riduciamo a 10 i campioni da valutare
	parallelism_cnt1: integer:= 4; -- parallelismo contatore 1 (conta 12 ) 
	parallelism_cnt2: integer:= 10; -- parallelismo contatore 2 (conta 625 ) 
	parallelism_cnt3: integer:= 4 -- parallelismo contatore 3 (conta 15) 
		 );
port(
		clk: in std_logic;
		rst: in std_logic;
		en1: in std_logic; -- enable registro pdm-pcm
		en2: in std_logic; -- en decimatore (reg2)
		en3: in std_logic; -- en reg 3 (reg energia)
		en4: in std_logic; -- en reg4 (x16)
		en5: in std_logic; -- en reg5 (reg ricorsione somma )
		en6: in std_logic;
		ce1: in std_logic; -- counter enable decimatore ( contatore 1)
		ce2: in std_logic; -- counter enable conta 24 (contatore 2)
		ce3: in std_logic; -- counter enable conta 15 (contatore 3)
		rst_cnt3: in std_logic; --reset contatore 3 (conta 15)
		rst_reg5: in std_logic; --reset registro accomulatore
		co_1: out std_logic; -- tc del decimatore 
		co_2: out std_logic; -- tc del contatore 2
		co_3: out std_logic;  -- tc del contatore 3
		pdm: in std_logic; -- ingresso pdm 
		--pdm_in_dx: in std_logic; -- ingresso pdm canale dx
		output: out std_logic_vector(7 downto 0); --uscita mux sx,null,dx
		SEL: in std_logic_vector(1 downto 0);--SEL mux
		DCN: out std_logic_vector(1 downto 0)
	 );
end datapath_mic;	 
	 
architecture structural of datapath_mic is

   signal energy_sx: signed(parallelism_doble-1 downto 0); --segnale di appoggio tra registro energia sinistra e decisore
	signal energy_dx: signed(parallelism_doble-1 downto 0); --segnale di appoggio tra registro energia destra e decisore
   signal neg_edgeDX_pdm: std_logic; -- uscita del registro a fronte negativo, si risincronizza poi nel branch dx 
	
	 component decisore_mic
	generic( parallelism: integer:= 32);
	port( E_left: in signed(parallelism-1 downto 0);
			E_right: in signed (parallelism-1 downto 0);
			dcn: out std_logic_vector(1 downto 0); --dcn=11 DESTRA
															  --dcn=00 SINISTRA
			rst: in std_logic; -- reset shift register								  --dcn=10 or 01 NULL													  
			clk: in std_logic;
			en6: in std_logic -- enable dei due contatori
	 	
);
	  end component;
	  
	  component mux_mic_uart
	    generic ( 
		 parallelism: integer := 8 
		         );
		 port(
			S: in std_logic_vector(parallelism-1 downto 0) := "01010011"; --codice ASCII per la S
			D: in std_logic_vector(parallelism-1 downto 0) := "01000100";-- codice ASCII per la D
			N: in std_logic_vector(parallelism-1 downto 0) := "01001110"; --codice ASCII per la N
			q: out std_logic_vector(parallelism-1 downto 0);
			sel: in std_logic_vector(1 downto 0)
			);
	  end component;
	  
	  
	  
	  component pdm_reg_neg_mic
	  port( clk, Rst: in std_logic;
		D:  in std_logic;
		q:  out std_logic;
		en: in std_logic 
		);
		end component;
	  
	  
	  
	

	component timer_mic
		generic(
			n_cnt1:integer:=11; --mettere valore giusto
			n_cnt2: integer:=624; --mettere valore giusto
			n_cnt3: integer:=14; --mettere valore giusto
			parallelism_cnt1: integer:= 10; --mettere valore giusto
			parallelism_cnt2: integer:= 10; --mettere valore giusto
			parallelism_cnt3: integer:= 10 --mettere valore giusto
				);
		port( 
			clk: in std_logic;
			rst: in std_logic;
			ce1: in std_logic;
			ce2: in std_logic;
			ce3: in std_logic;
			co_1: out std_logic;
			co_2: out std_logic;
			co_3: out std_logic;
			rst_cnt3: in std_logic
			);
		end component;


		component branch_mic
			generic (
						parallelism_doble: integer:=32; -- parallelismo dopo la moltiplicazione
						parallelism_op: integer:=16 --parallelismo dopo filtro
					  );
						
			port (
				pdm_in: in std_logic;
				clk: in std_logic;
				rst: in std_logic;
				rst_reg5: in std_logic; -- reset reg5 accomulatore
				en1: in std_logic; -- enable registro pdm-pcm e filtro
				en2: in std_logic; -- en decimatore
				en3: in std_logic; -- en reg 3 (reg energia)
				en4: in std_logic; -- en reg4 (reg x16)
				en5: in std_logic; -- en reg5 ricorsione somma
				
				out_energy: out signed(parallelism_doble-1 downto 0)
				
				 );
			
			end component;
			
			begin
			
			neg_edge_DC: component pdm_reg_neg_mic
			port map(
			en=>en1,
			clk=>clk,
			rst=>rst,
			D=>pdm,
			q=>neg_edgeDX_pdm
			);
			
			
			timer: component timer_mic
				generic map(
				n_cnt1=>n_cnt1,
				n_cnt2=>n_cnt2,
				n_cnt3=>n_cnt3,
				parallelism_cnt1=>parallelism_cnt1,
				parallelism_cnt2=>parallelism_cnt2,
				parallelism_cnt3=>parallelism_cnt3
				)
				port map(
				clk=>clk,
				rst=>rst,
				ce1=>ce1,
				ce2=>ce2,
				ce3=>ce3,
				co_1=>co_1,
				co_2=>co_2,
				co_3=>co_3,
				rst_cnt3=>rst_cnt3
				);
			
			-----------
			
			mux: component mux_mic_uart
			generic map( 
			parallelism=>parallelism_out
			)
			port map(
		   S=>S,
			D=>D,
			N=>N,
			q=>output,
			sel=>SEL
			);
			
			
			branch_dx: component branch_mic
			generic map(
			parallelism_op=>parallelism_op,
			parallelism_doble=>parallelism_doble
			)
			port map(
			clk=>clk,
			rst=>rst,
			rst_reg5=>rst_reg5,
			pdm_in=>neg_edgeDX_pdm, -- risincronizzato col registro negedge
			en1=>en1,
			en2=>en2,
			en3=>en3,
			en4=>en4,
			en5=>en5,		
			out_energy=>energy_dx
			
			);
			
			-----------
			
			branch_sx: component branch_mic
			generic map(
			parallelism_op=>parallelism_op,
			parallelism_doble=>parallelism_doble
			)
			port map(
			clk=>clk,
			rst=>rst,
			rst_reg5=>rst_reg5,
			pdm_in=>pdm,
			en1=>en1,
			en2=>en2,
			en3=>en3,
			en4=>en4,
			en5=>en5,
			out_energy=>energy_sx
			);
			
			-----------
			
			
			
			decisore: component decisore_mic  
		   generic map( 
		   parallelism=>parallelism_doble
			     )
		   port map( 
			  E_left=> energy_sx,
			  E_right=> energy_dx,
			  dcn=> DCN,
			  rst=>rst,
			  en6=>en6,
			  clk=>clk
				);
				
				
			------------
			

			end architecture;