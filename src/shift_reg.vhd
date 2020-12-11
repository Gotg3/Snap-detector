library ieee;
use ieee.std_logic_1164.all;

entity shift_reg is --parallel in serial out
generic (parallelism: integer :=8);
port(
	se: in std_logic;
	le: in std_logic;
	clk: in std_logic;
	D_out: in std_logic_vector (parallelism-1 downto 0); 
	q: out std_logic;
	rst: in std_logic
	);
end shift_reg;

architecture behavioural of shift_reg is

signal tmp_sig: std_logic_vector(parallelism-1 downto 0);

begin 

process(clk)

	begin
	
		if (clk' event and clk='1') then
		
			if (rst = '1') then
			
				tmp_sig<= (others => '0');
			
			
			elsif (le = '1') then
				
				tmp_sig <= D_out;
					
			elsif (se ='1') then 
				
				for i in 0 to parallelism-2 loop  
					
					tmp_sig(i+1) <= tmp_sig(i);
					
				end loop;
					
					tmp_sig(0)<='0'; --nel nostro caso non arrivano segnali con continuità
											-- dopo il load il dato viene levato dal D_OUT
			end if;
				
		end if;
		
end process;
	
	q<=tmp_sig(parallelism-1); 
	
end behavioural;
				
					
			
			
			
			
			
			
			
			
			
			