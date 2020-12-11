library ieee;
use ieee.std_logic_1164.all;

entity shift_s_p is --parallel in serial out
generic (parallelism: integer :=8);
port(
	se: in std_logic;
	oe: in std_logic;
	clk: in std_logic;
	d: in std_logic; 
	q: out std_logic_vector(parallelism-1 downto 0);
	rst: in std_logic
	);
end shift_s_p;

architecture behavioural of shift_s_p is

signal tmp_sig, temp: std_logic_vector(parallelism-1 downto 0):="00000000";

begin 

process(clk)

	begin
	
		if (clk' event and clk='1') then
		
			if (rst = '1') then
			
				temp<= (others => '0');
			
			
			elsif (se = '1') then

				
				for i in 0 to parallelism-2 loop  
					
					temp(i+1) <= temp(i);	
					
				end loop;
					
					temp(0)<=d; 
			
			end if;

				if (	oe='1') then
							tmp_sig<=temp;
							

						else 
							tmp_sig<=(others =>'0');
						end if;
				
		end if;
		
end process;

q<=tmp_sig;
	
end behavioural;
				
					
			
			
			
			
			
			
			
			
			
			