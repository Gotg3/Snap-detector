library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity snap_dec_mic is --top level preliminare per test
port(
pdm: in std_logic; -- ingresso pdm 
clk: in std_logic;
rst: in std_logic;
ack: in std_logic; --ack che arriva alla uart
TX: out std_logic -- uscita seriale della UART
);
end snap_dec_mic;

	architecture structural of snap_dec_mic is
	signal en1_sig: std_logic; -- questi sono tutti i comandi di appoggio verso il datapath
	signal en2_sig: std_logic;
	signal en3_sig: std_logic;
	signal en4_sig: std_logic;
	signal en5_sig: std_logic;
	signal en6_sig: std_logic;
	signal ce1_sig: std_logic;
	signal ce2_sig: std_logic;
	signal ce3_sig: std_logic;
	signal rst_cnt3_sig: std_logic;
	signal co_1_sig: std_logic;
	signal co_2_sig: std_logic;
	signal co_3_sig: std_logic;
	signal R_dp_sig: std_logic;
	signal R_reg5_sig: std_logic;
	signal d_out_sig: std_logic_vector(7 downto 0); -- segnale che collega il mux all'ingresso del tx uart
	signal data_valid_sig: std_logic; -- dataa valid arriva dala CU
	signal d_in_sig: std_logic_vector(7 downto 0); 
	signal RX_sig: std_logic;
	signal Rx_rdy_sig: std_logic;
	signal Tx_rdy: std_logic; -- deve andare alla CU 
	signal SEL: std_logic_vector(1 downto 0);--deve andare al mux
	signal DCN: std_logic_vector(1 downto 0);--segnale d'appoggio dal decisore alla cu
	signal Tx_sig: std_logic; 
	
	component datapath_mic
	generic(                parallelism_out: integer:= 8;
				parallelism_doble: integer:=32;
				parallelism_op: integer:=16;
				n_cnt1:integer:=11; -- contatore 1 (conta 12 ) 
				n_cnt2: integer:=49; -- contatore 2 (conta 50 per andare a 40Khz)  
				n_cnt3: integer:=8; -- contatore 3 (conta 15 per fare tutte e 15 le somme) 
				parallelism_cnt1: integer:= 4; -- parallelismo contatore 1 (conta 12 ) 
				parallelism_cnt2: integer:= 6; -- parallelismo contatore 2 (conta 625 ) 
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
				output: out std_logic_vector(7 downto 0); --uscita decisore
				SEL: in std_logic_vector(1 downto 0);--SEL mux
		      DCN: out std_logic_vector(1 downto 0)
			 );
	end component;
	
	
	component UART
	port(d_out: in std_logic_vector(7 downto 0);--D_out (ingresso word)
    	  d_in: out std_logic_vector(7 downto 0); -- uscita word
	  CLOCK_25: in std_logic;
	  rst:in std_logic;
	  data_valid:in std_logic;
	  ack:in std_logic;
	  TX: out std_logic;
	  RX: in std_logic; 
	  Tx_rdy: out std_logic;
	  Rx_rdy: out std_logic
	  );
	end component;

	
	
	component macchina_stati_MIC
	port(rst,clk_25, co1, co2, co3,Tx_rdy: in std_logic;--clock a 25 MHz
     DCN: in std_logic_vector(1 downto 0);
	  SEL: out std_logic_vector(1 downto 0):="00";
     R_dp,R_reg5,R_count3,CE1,CE2,CE3, En_1, En_2, En_3, En_4, En_5,En_6,D_valid:  out std_logic);
	end component;
	
	begin
	
	dp: component datapath_mic
	port map(
	clk=>clk,
	rst=>R_dp_sig,
	en1=>en1_sig,
	en2=>en2_sig,
	en3=>en3_sig,
	en4=>en4_sig,
	en5=>en5_sig,
	en6=>en6_sig,
	ce1=>ce1_sig,
	ce2=>ce2_sig,
	ce3=>ce3_sig,
	rst_cnt3=>rst_cnt3_sig,
	rst_reg5=>R_reg5_sig, -- resetta contatore 5 accumulatore
	co_1=>co_1_sig,
	co_2=>co_2_sig,
	co_3=>co_3_sig,
	pdm=>pdm,
	output=>d_out_sig, -- collegato alla uart
	SEL=>SEL,--SEL mux
   	DCN=>DCN
	);
	
	cu: component macchina_stati_mic
	port map(
	rst=>rst,
	clk_25=>clk,
	co1=>co_1_sig,
	co2=>co_2_sig,
	co3=>co_3_sig,
	CE1=>ce1_sig,
	CE2=>ce2_sig,
	cE3=>ce3_sig,
	En_1=>en1_sig,
	En_2=>en2_sig,
	En_3=>en3_sig,
	En_4=>en4_sig,
	En_5=>en5_sig,
	En_6=>en6_sig,
	R_dp=>R_dp_sig,
	R_count3=>rst_cnt3_sig,
	R_reg5=>R_reg5_sig,
	D_valid=>data_valid_sig,
	Tx_rdy=>Tx_rdy,
	SEL=>SEL,
	DCN=>DCN
	);
	
	
	TR_UART: component UART
	port map(
	d_out=>d_out_sig,
  	 d_in=>d_in_sig, 
	CLOCK_25=>clk,
	rst=>rst,
	data_valid=>data_valid_sig,
	ack=>ack,
	TX=>TX,
	RX=>Rx_sig,
	Tx_rdy=>Tx_rdy,
	Rx_rdy=>Rx_rdy_sig
	  );
	  
	
	
	end architecture;
	