library ieee;
use ieee.std_logic_1164.all;

entity M_voter is
port(
	d0,d1,d2: in std_logic; --d0=A, d1=B, d2=C
			
			y: out std_logic	
	 );
end M_voter;

architecture structural of M_voter is
	signal y1,y2,y3: std_logic;
	begin
	y1<=(d0 AND d2);
	y2<=(d1 AND d2);
	y3<=(d0 AND d2);
	y<=((y1 OR y2) OR y3);
	
end structural;

