library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   

entity counter2 is 
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			ttr: out std_logic
			);
end counter2;

architecture behavioural2 of counter2 is

constant one: std_logic_vector(2 downto 0):= "001"; 
signal count_sig: std_logic_vector(2 downto 0); --
signal end_cnt: std_logic;


begin
	counter_process: process(clk)
	begin
			if(clk' event and clk= '1') then
				if(rst ='1') then
					count_sig <= "000";
					end_cnt <='0';
				else 
						if(en = '1') then 
							if(end_cnt='1') then
								end_cnt <='0';
								count_sig <="000"; 
							else 
								
								count_sig <= std_logic_vector(unsigned(count_sig)+ unsigned(one));
								
								
								end_cnt<=(count_sig(2) and count_sig(1) and (not count_sig(0))); 
							end if;
						else
							count_sig<=count_sig;
						
						
						end if;
					
				end if;
			end if;
	end process counter_process;
		ttr<=end_cnt;
		
end behavioural2;