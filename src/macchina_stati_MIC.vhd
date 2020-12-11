library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity macchina_stati_MIC is
port(rst,clk_25, co1, co2, co3,Tx_rdy: in std_logic;--clock a 25 MHz
     DCN: in std_logic_vector(1 downto 0);
	  SEL: out std_logic_vector(1 downto 0);
     R_dp,R_reg5,R_count3,CE1,CE2,CE3, En_1, En_2, En_3, En_4, En_5,En_6,D_valid:  out std_logic);-- R_dp è il segnale di reset che resetta tutto il dp, mentre R_count3 resetta il terzo contatore e R_reg5 resetta il registro 5
end macchina_stati_MIC;

architecture Behavior of macchina_stati_MIC is

type State_type is (reset, start, stato_1, stato_1_bis, stato_2, stato_3, stato_4, stato_5, stato_6, stato_7, stato_8, stato_9, stato_10, stato_11, stato_12, stato_13, stato_14);
signal stato: State_type:= reset;
begin

R: process (clk_25) 
begin 
     if(clk_25'event and clk_25='1') then  
	  case stato is 
		when reset=>
	      stato<=start;
	 
		when start=>
			if rst='1' then
				stato<=reset;
			elsif co1='0' then
				stato<=start;
		   else
			   stato<=stato_1;
			end if;
			
		when stato_1=>
			if rst='1' then
				stato<=reset;
			 else 
			 	stato<=stato_1_bis;
			end if;
			
		when stato_1_bis=>
			if rst='1' then
				stato<=reset;
			 elsif (co2='1' and co3='0') then
				stato<=stato_2;

			 elsif (co2='1' and co3='1')then 
			 	stato<=stato_5;
			 else 
				stato<=start;
			end if;
			
			
		when stato_2=>
			if rst='1' then
				stato<=reset;
			else
				stato<=stato_3;
			end if;
		
      when stato_3=>
			if rst='1' then
				stato<=reset;
			else
				stato<=stato_4;
		   end if;
         		
		when stato_4=>
			if rst='1' then
				stato<=reset;
			else
				stato<=start;
			end if;
			
		when stato_5=>
			if rst='1' then
				stato<=reset;
			else 
				stato<=stato_6;
			end if;	
			
		when stato_6=>
			if rst='1' then
				stato<=reset;
			else 
				stato<=stato_7;
			end if;
			
		when stato_7=>
			if rst='1' then
				stato<=reset;
			else 
				stato<=stato_8;
			end if;
			
		when stato_8=>
			if rst='1' then
				stato<=reset;
			elsif DCN="01" then 
				stato<=stato_11;
			elsif DCN="10" then 
				stato<=stato_10;
			else
				stato<=stato_9;
			end if;
		
		when stato_9=>
			if rst='1' then
				stato<=reset;
			elsif Tx_rdy='1' then 
				stato<=stato_12;
			else
				stato<=start;
			end if;
		
		when stato_10=>
			if rst='1' then
				stato<=reset;
			elsif Tx_rdy='1' then 
				stato<=stato_13;
			else
				stato<=start;
			end if;
			
		when stato_11=>
			if rst='1' then
				stato<=reset;
			elsif Tx_rdy='1' then 
				stato<=stato_14;
			else
				stato<=start;
			end if;
		
		when stato_12=>
			if rst='1' then
			else
				stato<=start;
			end if;
		
		when stato_13=>
			if rst='1' then
			else
				stato<=start;
			end if;
			
		when stato_14=>
			if rst='1' then
			else
				stato<=start;
			end if;
		
					
		when others =>
	         stato<=reset;
			end case;
	  end if;		  
end process R;

L: process (stato)
begin 
   case stato is 
	     when reset=>
				R_dp<='1';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='0';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="00";
				
		  when start=>				
			   R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="00";
				
		  when stato_1=>
	      	R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='1';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='1';
				CE2<='1';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="00";
				
			when stato_1_bis=>
	      	R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="00";
				
		  when stato_2=>
         	R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='1';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='1';
				En_6<='0';
				D_valid<='0';
				SEL<="00";
				
		  when stato_3=>
		      R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='1';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="00";
				
		  when stato_4=>
				R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='1';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="00";
				
			when stato_5=>
				R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='1';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="00";
				
			when stato_6=>
				R_dp<='0';
				R_count3<='1';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='1';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="00";
				
			when stato_7=>
				R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='1';
				En_4<='0';
				En_5<='1';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="00";
				
			when stato_8=>
				R_dp<='0';
				R_count3<='0';
				R_reg5<='1';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='1';
				D_valid<='0';
				SEL<="00";
				
			when stato_9=>
				R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="00";
				
			when stato_10=>
				R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="10";
				
			when stato_11=>
				R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="01";
			
			when stato_12=>
				R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='1';
				SEL<="00";
				
		   when stato_13=>
				R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='1';
				SEL<="10";
				
			when stato_14=>
				R_dp<='0';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='1';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='1';
				SEL<="01";
				
			when others => 
			   R_dp<='1';
				R_count3<='0';
				R_reg5<='0';
				En_1<='0';
				En_2<='0';
				En_3<='0';
				En_4<='0';
				En_5<='0';
				CE1<='0';
				CE2<='0';
				CE3<='0';
				En_6<='0';
				D_valid<='0';
				SEL<="00";
				
			end case;
end process;

end Behavior;

