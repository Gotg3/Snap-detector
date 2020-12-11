library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


entity counter4_rx is  
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			count: out std_logic_vector(10 downto 0);
			tc: out std_logic
			);
end counter4_rx;

architecture behavioural1 of counter4_rx is

constant one: std_logic_vector(10 downto 0):= "00000000001"; 
signal count_sig: std_logic_vector(10 downto 0); --

begin
	counter_process: process(clk)
	begin
			if(clk' event and clk= '1') then
				if(rst ='1') then
					count_sig <= "00000000000";
					tc<='0';
				else 
						if(en = '1') then 
						
							if( count_sig = "10100001101") then  
							
								count_sig <="00000000000"; 
								
								tc <= '0';

							else 
								count_sig <= std_logic_vector(unsigned(count_sig)+ unsigned(one));
								tc <= '0';
								if( count_sig = "10100001100") then  
									tc <= '1';
								end if;
								
							end if;
						
						
						end if;
				
				end if;
			end if;
	end process counter_process;
	count <= count_sig;
		
end behavioural1;