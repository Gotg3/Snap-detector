library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sommatore_mic is
generic ( parallelism: integer := 16 );
port(
	s1: in signed(parallelism -1 downto 0);
	s2: in signed(parallelism -1 downto 0);
	sum: out signed(parallelism-1 downto 0) 
	);
end sommatore_mic;
	architecture behavioural of sommatore_mic is
	
begin 
		sommatore_process: process(s1,s2)
			begin
			   sum<=(signed(s1)+ signed(s2));
				
			end process sommatore_process;
	end behavioural;
	