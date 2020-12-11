library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;      

entity counter_asinc_mic is
generic(parallelism:integer:=10;
		  fnumber:integer :=28);
port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			output: out std_logic_vector(parallelism-1 downto 0);
			tc: out std_logic
);
end counter_asinc_mic;

	architecture structural of counter_asinc_mic is
	signal tc_s: std_logic:='0';
	signal output_sig: std_logic_vector(parallelism-1 downto 0);
	signal final_c: std_logic_vector(parallelism-1 downto 0):=(std_logic_vector(to_unsigned(fnumber, parallelism))); --setta il numero finale
	
	component cnt_asinc_mic
		generic(parallelism: integer:=10);
		port(
				en: in std_logic;
				clk: in std_logic;
				rst: in std_logic;
				count: out std_logic_vector(parallelism-1 downto 0)
				);
	end component;
	
	begin
	
	contatore: component cnt_asinc_mic 
	generic map(parallelism => parallelism)
	port map(
		en=>en,
		clk=>clk,
		rst=>rst,
		count=>output_sig
	);
		
	
	tc_dec: process (output_sig)
	begin
		if(output_sig = final_c) then  --quando il numero � uguale alza tc
		tc_s<='1';
		else 
		tc_s<='0';
	end if;
	
	end process;
	
	tc<=tc_s;
	output<=output_sig;
	
 end structural;