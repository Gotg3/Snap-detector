library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;      


entity counter1 is 
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			count: out std_logic_vector(11 downto 0);
			tc: out std_logic
			);
end counter1;

architecture behavioural1 of counter1 is

constant one: std_logic_vector(11 downto 0):= "000000000001"; 
signal count_sig: std_logic_vector(11 downto 0);
signal tc_sig:std_logic;

begin
	counter_process: process(clk)
	begin
			if(clk' event and clk= '1') then
				if(rst ='1') then
					count_sig <= "000000000000";
					tc_sig<='0';
				else 
						if(en = '1') then 
						
							if(tc_sig='1') then  
								
								count_sig <="000000000000";
								tc_sig<='0';
								else
								count_sig <= std_logic_vector(unsigned(count_sig)+ unsigned(one));
									if( count_sig = "101000101001") then
									tc_sig <= '1';
									end if;
							end if;
						end if;
				end if;
			end if;
	end process counter_process;
	count <= count_sig;
	tc<=tc_sig;	
end behavioural1;