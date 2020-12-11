library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_mic_uart is
	generic ( parallelism: integer := 8 );
port(
	S: in std_logic_vector(parallelism-1 downto 0) := "01010011"; --codice ASCII per la S
	D: in std_logic_vector(parallelism-1 downto 0) := "01000100";-- codice ASCII per la D
	N: in std_logic_vector(parallelism-1 downto 0) := "01001110"; --codice ASCII per la N
	q: out std_logic_vector(parallelism-1 downto 0);
	sel: in std_logic_vector(1 downto 0)
	);
end mux_mic_uart;

architecture behavioural of mux_mic_uart is
		begin
			mux_proc:process(S,D,N,sel)
			begin
				case sel is
					when "01" =>
						q<= D; 
					when "10" =>
					   q<= S;
					when others =>
						q<= N;
				end case;
			end process mux_proc;
	end behavioural;
			