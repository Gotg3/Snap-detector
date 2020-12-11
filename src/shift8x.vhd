library ieee;
use ieee.std_logic_1164.all;

entity shift8x is --parallel in serial out
generic (parallelism: integer :=8);
port(
	se: in std_logic;
	oe: in std_logic;
	clk: in std_logic;
	d: in std_logic; 
	q: out std_logic_vector(parallelism-1 downto 0);
	rst: in std_logic
	);
end shift8x;

architecture behavioural of shift8x is

signal tmp_sig: std_logic_vector(parallelism-1 downto 0):="00000000";

begin 

process(clk)

	begin
	
		if (clk' event and clk='1') then
		
			if (rst = '1') then
			
				tmp_sig<= (others => '0');
			
			
			elsif (se = '1') then
				
				
				for i in 0 to parallelism-2 loop  
					
					tmp_sig(i+1) <= tmp_sig(i);	
					
				end loop;
					
					tmp_sig(0)<=d; 
			
			end if;

				if (	oe='0') then
																	
							tmp_sig<=(others=>'0');
						end if;
				
		end if;
		
end process;

	q<=tmp_sig;
	
	
end behavioural;
				
					
			
			
			
			
			
			
			
			
			
			