Library IEEE;  
USE IEEE.Std_logic_1164.all;   
use ieee.numeric_std.all;  

 entity filter_mic is  
 generic (  
           input_width          : integer     :=16               ;-- grandezza input 
           output_width     : integer     :=32              ;-- grandezza output 
           coef_width          : integer     :=16               ;-- grandezza coeff 
           tap                    : integer     :=24               ;-- ordine filtro 
           guard               : integer     :=0)               ;-- eventuali bit per overflow, non utilizzato
 port(  
		en : in std_logic;
      Din          : in      signed(input_width-1 downto 0)     ;-- input data  
      Clk          : in      std_logic                                             ;-- input clk  
      reset     : in      std_logic                                             ;-- input reset  
      Dout     : out      signed(output_width-1 downto 0))     ;-- output data  
 end filter_mic;  
 architecture behaivioral of filter_mic is  
 
 
 -- N bit Registro  
 
 
 component N_bit_Reg   
 generic (  
           input_width          : integer     :=16  
           );  
   port(  
    en: in std_logic;
    Q : out signed(input_width-1 downto 0);     
    Clk :in std_logic;    
    reset :in std_logic;   
    D :in signed(input_width-1 downto 0)    
   );  
 end component;
  
 type Coeficient_type is array (1 to tap) of signed(coef_width-1 downto 0);  
 -----------------------------------Coefficienti filtro ----------------------------------------------------------------  
 constant coeficient: coeficient_type :=                                                   (    "0000000000000111",
"0000000000001110",
"0000000000011011",
"0000000000101101",
"0000000001000110",
"0000000001100100",
"0000000010000101",
"0000000010101000",
"0000000011001001",
"0000000011100110",
"0000000011111011",
"0000000100000110",
"0000000100000110",
"0000000011111011",
"0000000011100110",
"0000000011001001",
"0000000010101000",
"0000000010000101",
"0000000001100100",
"0000000001000110",
"0000000000101101",
"0000000000011011",
"0000000000001110",
"0000000000000111"
                                    );                                         
 ----------------------------------------------------------------------------------------------                                     
 type shift_reg_type is array (0 to tap-1) of signed(input_width-1 downto 0);  
 signal shift_reg : shift_reg_type;  
 type mult_type is array (0 to tap-1) of signed(input_width+coef_width-1 downto 0);  
 signal mult : mult_type;  
 type ADD_type is array (0 to tap-1) of signed(input_width+coef_width-1 downto 0);  
 signal ADD: ADD_type;  
 signal dout_sig: signed(output_width-1 downto 0) ;
 
 
 begin  
 
			shift_reg(0)     <= Din;  
           mult(0)<= Din*coeficient(1);  
           ADD(0)<= Din*coeficient(1);  
           GEN_FIR:  
           for i in 0 to tap-2 generate  
           begin  
                  
                 N_bit_Reg_unit : N_bit_Reg generic map (input_width =>input_width)   
                 port map ( Clk => Clk,
									 en=> en,
                                    reset => reset,  
                                    D => shift_reg(i),  
                                    Q => shift_reg(i+1)  
                                    );       
               
                mult(i+1)<= shift_reg(i+1)*coeficient(i+2);  
               
                ADD(i+1)<=ADD(i)+mult(i+1);  
           end generate GEN_FIR; 
			  

			 
			 Dout<=ADD(23); --tap-1

			 
			 
			  
			  
 end Architecture;  

 Library IEEE;  
 USE IEEE.Std_logic_1164.all;  
 use ieee.numeric_std.all;  
 

 
 entity N_bit_Reg is   
 generic (  
           input_width          : integer     :=16  
           );  
   port(  
	 en: in std_logic;
    Q : out signed(input_width-1 downto 0);    
    Clk :in std_logic;    
    reset :in std_logic;  
    D :in signed(input_width-1 downto 0)    
   );  
 end N_bit_Reg;  


 architecture Behavioral of N_bit_Reg is   
 signal q_sig: signed(input_width-1 downto 0);
 begin   
      process(Clk,reset)  
      begin   
           if (reset = '1') then  
				
					
                q_sig <= (others => '0');  
        elsif ( en='1' ) then 
				 
				 if(rising_edge(Clk)) then
		 
                q_sig <= D; 
				 end if;
				 else
					q_sig<=q_sig; --mantiene uscita
       end if;      
      end process; 

			q<=q_sig;
 end Behavioral;