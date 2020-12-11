library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity UART is
port(d_out: in std_logic_vector(7 downto 0);
     d_in: out std_logic_vector(7 downto 0);
	  CLOCK_25: in std_logic;
	  rst:in std_logic;
	  data_valid:in std_logic;
	  ack:in std_logic;
	  TX: out std_logic;
	  RX: in std_logic; 
	  Tx_rdy: out std_logic;
	  Rx_rdy: out std_logic
	  );
	  
end  UART;

architecture structural of UART is
signal tx_rx_sgn: std_logic;


component trasmettitore is
port(D_out: in std_logic_vector(7 downto 0);
	  clk, reset: in std_logic;
	  Data_valid: in std_logic;
	  Tx_t, Tx_rdy: out std_logic);
end component;

component ricevitore is
port( clk_25: in std_logic;
		reset: in std_logic;
	   rx_r: in std_logic;
		ack: in std_logic;
		rx_rdy: out std_logic;
	   d_in: out std_logic_vector(7 downto 0)
		);
end  component;
 
begin


Transmitter: trasmettitore 
port map(
	clk=>CLOCK_25,
	reset=>rst,
	D_out=>d_out,
	Data_valid=>data_valid,
	Tx_t=>TX,
	Tx_rdy=>Tx_rdy

	);
	
	
Receiver: ricevitore 
port map(
	clk_25=>CLOCK_25,
	reset=>rst,
	rx_r=>RX,
	ack=>ack,
	rx_rdy=>Rx_rdy,
	d_in=>d_in
	
	);
end structural; 

