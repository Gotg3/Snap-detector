library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;       


entity cnt_asinc_mic is 
	generic(parallelism: integer:=10);
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			count: out std_logic_vector(parallelism-1 downto 0)
			);
end cnt_asinc_mic;

architecture behavioural of cnt_asinc_mic is

signal count_sig: std_logic_vector(parallelism-1 downto 0); 

begin
	counter_process: process(clk,rst)
	begin
			if(rst='1') then
			count_sig<=(others=>'0');
		else
			if(clk' event and clk= '1') then
				
					
	
				
				if(en = '1') then 
						
						count_sig <= std_logic_vector(unsigned(count_sig)+ 1);			
								
					end if;
								
				end if;
			end if;
		
	end process counter_process;
	count <= count_sig;
end behavioural;