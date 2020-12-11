library ieee;
use ieee.std_logic_1164.all; 

entity flipflop is 
port(D, clk, Rst: in std_logic;
	  q: out std_logic);
end flipflop;

architecture behavior of flipflop is 
begin 
	process(clk)
	begin
			if (clk' event and clk='1') then
				if(Rst='1') then -- synchronous clear
				q<='0';
				else 
				q<= D;
				end if;
			end if;
	end process;
end behavior;