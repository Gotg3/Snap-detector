library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
--use work.my_package.all;

entity decisore_mic is
generic( parallelism: integer:= 32);
port( E_left: in signed(parallelism-1 downto 0);
		E_right: in signed (parallelism-1 downto 0);
		dcn: out std_logic_vector(1 downto 0); --dcn=11 DESTRA
		                                      --dcn=00 SINISTRA
	rst: in std_logic; -- reset shift register								  --dcn=10 or 01 NULL													  
	 clk: in std_logic;
	 en6: in std_logic -- enable dei due contatori
	 	
);
end decisore_mic;

architecture structural of decisore_mic is
constant thr: signed(parallelism-1 downto 0):="00000000011001111000110000000000";
signal dcn_dx: std_logic; -- incrementa ramo dx
signal dcn_sx: std_logic; -- incrementa ramo sx
signal shift_dx: std_logic;
signal shift_sx: std_logic;
signal sdx: std_logic_vector(3 downto 0):=(others=>'0'); -- segnale temp shift register 
signal ssx: std_logic_vector(3 downto 0):=(others=>'0');
signal cnt_s: std_logic_vector(3 downto 0):=(others=>'0');
signal cnt_d: std_logic_vector(3 downto 0):=(others=>'0');
 

begin


		

		decision: process (E_left,E_right)
			begin
				
				
				
				if (E_right>E_left) then -- valutazione energia destra
					if(E_right>thr) then
						dcn_dx<='1';--DESTRA
						dcn_sx<='0';
					else 
						dcn_dx<='0';--NULL
						dcn_sx<='0';
					end if;
				elsif (E_left>E_right) then --valutazione energia sx
					if(E_left>thr) then
						dcn_sx<='1';--SINISTRA
						dcn_dx<='0';
					else
						dcn_sx<='0';--NULL
						dcn_dx<='0';
					end if;
                                else
                            dcn_dx<='0';--NULL
									 dcn_sx<='0';--NULL
				end if;
		

		end process decision;
	
	
		shift_reg: process (clk)
			begin
		if(clk' event and clk='1') then
			if(rst='1') then 
				sdx<=(others=>'0');
				ssx<=(others=>'0');
			else
			
				if(en6='1') then 
				for i in 0 to 2 loop  
					
					ssx(i+1) <= ssx(i);
					sdx(i+1) <= sdx(i);
					
				end loop;
					
					sdx(0)<=dcn_dx;
					ssx(0)<=dcn_sx;
				end if;
			end if;
		end if;

		cnt_d<=sdx;		
		cnt_s<=ssx;
		
		end process shift_reg;
		
		
		
		dcn(0)<=((not(cnt_d(0))) and cnt_d(1) and cnt_d(2) and cnt_d(3)) or (cnt_d(0) and (not(cnt_d(1))) and cnt_d(2) and cnt_d(3)) or (cnt_d(0) and cnt_d(1) and (not(cnt_d(2))) and cnt_d(3)) or (cnt_d(0) and cnt_d(1) and cnt_d(2) and (not(cnt_d(3)))) or (cnt_d(0) and cnt_d(1) and cnt_d(2) and cnt_d(3));
		dcn(1)<=((not(cnt_s(0))) and cnt_s(1) and cnt_s(2) and cnt_s(3)) or (cnt_s(0) and (not(cnt_s(1))) and cnt_s(2) and cnt_s(3)) or (cnt_s(0) and cnt_s(1) and (not(cnt_s(2))) and cnt_s(3)) or (cnt_s(0) and cnt_s(1) and cnt_s(2) and (not(cnt_s(3)))) or (cnt_s(0) and cnt_s(1) and cnt_s(2) and cnt_s(3));


		
		end structural;

