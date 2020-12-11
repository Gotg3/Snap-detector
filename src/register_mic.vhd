library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_mic is 
generic ( parallelism: integer := 16 );
port( clk, Rst: in std_logic;
		D: in signed(parallelism-1 downto 0);
		q: out signed(parallelism-1 downto 0);
		en: in std_logic 
		);
end register_mic;

architecture behavior of register_mic is 
signal q_sig: signed(parallelism-1 downto 0):=(others=>'0');
begin 
	process(clk)
	begin
			if (clk' event and clk='1') then
				if(Rst='1') then -- synchronous clear
				q_sig<=(others =>'0');
				else 
					if(en='1') then
						q_sig<= D;
				else
						q_sig<=q_sig;
					end if;
				end if;
			end if;
	end process;
q<=q_sig;
end behavior;