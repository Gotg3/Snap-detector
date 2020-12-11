library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_conv_mic is
generic(parallelism: integer:=16);
port(
pdm_in: in std_logic;
sign_out: out signed(parallelism-1 downto 0)
);
end sign_conv_mic;

architecture behavioural of sign_conv_mic is
begin 

	sign_proc: process(pdm_in) is   
		begin 
				
				case pdm_in is
					when '1' =>
					
						sign_out<="0000000000000001"; 
						
					when others =>
					
						sign_out<="1111111111111111"; -- é -1 scritto in fractional point
				end case;
			end process sign_proc;
		end behavioural;