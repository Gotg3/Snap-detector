library ieee;
use ieee.std_logic_1164.all;

entity str is
port(
and_in: in std_logic_vector(7 downto 0);
and_out: out std_logic
);

end str;

architecture structural of str is
begin

and_out<=((not and_in(0)) and (not and_in(1)) and (not and_in(2)) and (not and_in(3)) 
		and and_in(4) and and_in(5) and and_in(6)and and_in(7) );

end structural;




