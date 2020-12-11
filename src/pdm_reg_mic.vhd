library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pdm_reg_mic is 
port( clk, Rst: in std_logic;
		D:  in std_logic;
		q:  out std_logic;
		en: in std_logic 
		);
end pdm_reg_mic;

architecture behavior of pdm_reg_mic is 
signal q_sig: std_logic;
begin 
	process(clk)
	begin
			if (clk' event and clk='1') then
				if(Rst='1') then -- synchronous clear
				q_sig<='0';
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