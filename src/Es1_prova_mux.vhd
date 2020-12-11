library ieee;
use ieee.std_logic_1164.all; 

entity Es1_prova_mux is
port (IDLE,START,STOP,DATA: in std_logic;
		sel: in std_logic_vector (1 downto 0);
		Tx: out std_logic);
end Es1_prova_mux;

architecture behavior of Es1_prova_mux is
	begin
	Tx<= IDLE when sel="00" else --1
		 START when sel="01" else --0
		 DATA when sel="10" else --DATA
		 STOP; --1
end behavior;