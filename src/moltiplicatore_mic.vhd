library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity moltiplicatore_mic is
generic ( parallelism: integer :=16  );
port(
	input: in signed( parallelism-1  downto 0);
	A_x2: out signed(parallelism*2-1 downto 0) --la moltiplicazione rende in uscita 2*n bit	
	);
end moltiplicatore_mic;

architecture behavioural of moltiplicatore_mic is
signal m: signed( parallelism-1  downto 0);
begin
	multiplier_process: process(m) --ATTENZIONE va fatto resize per m2
	begin
		
			
				
			A_x2<=shift_left(m*m,1); -- moltiplicazione su parallelism*2 bit, shift left per riprendere il segno
				 
	end process;	
	m<=input;
end behavioural;