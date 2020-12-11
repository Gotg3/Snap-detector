library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity counter2_rx is 
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			count: out std_logic_vector(14 downto 0);
			ttr: out std_logic
			);
end counter2_rx;

architecture behavioural of counter2_rx is

constant one: std_logic_vector(14 downto 0):= "000000000000001"; 
signal count_sig: std_logic_vector(14 downto 0); --

begin
	counter_process: process(clk)
	begin
			if(clk' event and clk= '1') then
				if(rst ='1') then
					count_sig <= "000000000000000";
					ttr <= '0';
				else 
						if(en = '1') then
						
							if( count_sig = "100011011011111") then  
							
								count_sig<="000000000000000";						
								ttr <= '0';
--
							
							else 
								count_sig <= std_logic_vector(unsigned(count_sig)+ unsigned(one));
								ttr <= '0';
								
								if(count_sig = "100011011011110") then
								ttr<='1';
								end if;
							end if;
												
						end if;
					
				end if;
			end if;
	end process counter_process;

	count <= count_sig;
		
end behavioural;