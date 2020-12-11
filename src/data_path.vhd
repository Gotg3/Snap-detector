library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity data_path is 
	port(
		R_cnt1, R_cnt2, R_reg, ck,le,ce1,ce2,se: in std_logic;
		d_out_in: in std_logic_vector(7 downto 0);
		d_valid: in std_logic;
		tc,ttr: out std_logic;
		sel: in std_logic_vector(1 downto 0);
		tx: out std_logic
		);
end data_path;

architecture structural of data_path is 
signal d_out_sig: std_logic_vector (7 downto 0); 
signal q_sig: std_logic;

constant one: std_logic:= '1'; --costante 1
constant zero: std_logic:= '0'; --costane 0



component counter1 
		port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			tc: out std_logic
			);
end component;

component counter2 
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			ttr: out std_logic
			);
			
end component;

component Es1_prova_mux

	port (IDLE,START,STOP,DATA: in std_logic;
		sel: in std_logic_vector (1 downto 0);
		Tx: out std_logic
	);
end component;


component flipflop
	port(D, clk, Rst: in std_logic;
			q: out std_logic);
end component;			
			
component shift_reg
	port(
	  D_out: in std_logic_vector(7 downto 0);
	  clk: in std_logic;
	  SE: in std_logic;
	  LE: in std_logic;
	  Rst: in std_logic;
	  Q: out std_logic);
	  
end component;
			
component reg8bit 
		port( 
		
			
			r: in std_logic_vector(7 downto 0);
			clock, resetn, en: in std_logic;
			q: out std_logic_vector(7 downto 0)
			 );	
end component;
	

begin
	
	CNT1: counter1
		port map(
			clk => ck,
			rst => R_cnt1,
			en => ce1,
			tc => tc
		);
	
	CNT2: counter2
		port map(
			clk => ck,
			rst => R_cnt2,
			en =>ce2,
			ttr =>ttr
		);
		
	REG8: reg8bit
		port map(
			r=>d_out_in,
			q => d_out_sig,
			Resetn => R_reg,
			en => d_valid,
			clock => ck
	   );
		
	SF: shift_reg
		port map(
			D_out => d_out_sig,
			clk => ck,
			se => se,
			le => le,
			rst => R_reg,
			q => q_sig
		);
				

	MUX4_1: Es1_prova_mux
		port map(
			stop => one,
			start => zero,
			idle => one,
			sel=> sel,
			data => q_sig,
			tx => tx
		);
				
		
	end structural;
			