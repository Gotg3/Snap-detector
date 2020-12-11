library ieee;
use  ieee.std_logic_1164.all;

entity timer_mic is
generic(
			n_cnt1:integer:=20; 
			n_cnt2: integer:=23; 
			n_cnt3: integer:=15; 
			parallelism_cnt1: integer:= 10;
			parallelism_cnt2: integer:= 10;
			parallelism_cnt3: integer:= 10 
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
	
end timer_mic;

architecture structural of timer_mic is
signal rst_sig_3: std_logic;

	component counter_asinc_mic
	generic(parallelism:integer:=10;
		  fnumber:integer :=28);
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			output: out std_logic_vector(parallelism-1 downto 0);
			tc: out std_logic
		 );
	end component;


	component counter_mic 
	generic(parallelism:integer:=10;
		  fnumber:integer :=28);
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			output: out std_logic_vector(parallelism-1 downto 0);
			tc: out std_logic
			);
   end component;
	
	begin
	
	counter_1: component counter_mic
		generic map(
			parallelism=> parallelism_cnt1,
			fnumber=>n_cnt1
						)
		port map(
			clk => clk,
			rst=>rst,
			en=> ce1,
			tc=>co_1
					);
	
	counter_2: component counter_mic
		generic map(
			parallelism=> parallelism_cnt2,
			fnumber=>n_cnt2
						)
		port map(
			clk => clk,
			rst=>rst,
			en=> ce2,
			tc=>co_2
					);
	
	counter_3: component counter_asinc_mic
		generic map(
			parallelism=> parallelism_cnt3,
			fnumber=>n_cnt3
						)
		port map(
			clk => clk,
			rst=>rst_sig_3,
			en=> ce3,
			tc=>co_3
					);
					
					
	rst_sig_3<=rst OR rst_cnt3; -- altro reset per resettarlo dalla cu				
					
	end architecture;
	
	
	
	