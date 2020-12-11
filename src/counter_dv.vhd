library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;       -- for the signed, unsigned types and arithmetic ops

entity counter_dv is  --contatore a 3 bit
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			ttr: out std_logic
			);
end counter_dv;

architecture behavioural2 of counter_dv is

constant one: std_logic_vector(26 downto 0):= "000000000000000000000000001"; 
signal count_sig: std_logic_vector(26 downto 0); --
signal end_cnt: std_logic;


begin
	counter_process: process(clk)
	begin
			if(clk' event and clk= '1') then
				if(rst ='1') then
					count_sig <= "000000000000000000000000000";
					end_cnt <='0';
				else 
						if(en = '1') then -- se enable è attivo allora conta
							 
							if(end_cnt='1') then
								end_cnt <='0';
								count_sig <="000000000000000000000000000"; --azzeramento del contatore

						
							else 
								
								count_sig <= std_logic_vector(unsigned(count_sig)+ unsigned(one));
								
								if ( count_sig = "111011100110101100100111110") then
								end_cnt<='1';
								end if;
							
																
							end if;
						else
							count_sig<=count_sig;
						
						end if;
				
				end if;
			end if;
	end process counter_process;
		ttr<=end_cnt;
		
end behavioural2;