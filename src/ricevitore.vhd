library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity ricevitore is
port( clk_25: in std_logic;
		reset: in std_logic;
	   rx_r: in std_logic;
		ack: in std_logic;
		rx_rdy: out std_logic;
	   d_in: out std_logic_vector(7 downto 0)
		);
end  ricevitore;

architecture structural of ricevitore is

signal str, tc, ttr, tc4, tc8x, ce8x, ce4, ce1, ce2, se8x, se2, le8x, oe2, r_cnt1, r_cnt2, r_cnt8x, r_cnt4, r_s8x, r_s2: std_logic;

component datapath_rx is --dichiaro tutti IN e OUT della entity che racchiude tutti i componenti
	port(
	--INPUT
	rx: in std_logic;
	clk: in std_logic;
	ce8x:	in std_logic;
	ce4: in std_logic;
	ce1: in std_logic;
	ce2: in std_logic;
	se8x: in std_logic;
	se2: in std_logic;
	oe2: in std_logic;
	reset: in std_logic;
	--RESET
	r_cnt1: in std_logic;
	r_cnt2: in std_logic;
	r_cnt8x: in std_logic;
	r_cnt4: in std_logic;
	r_s8x: in std_logic;
	r_s2: in std_logic;
	--OUTPUT
	d_in: out std_logic_vector(7 downto 0);
	tc8x: out std_logic;
	tc4: out std_logic;
	tc1: out std_logic;
	ttr: out std_logic;
	start: out std_logic
	);
end component;

component fsm_rx is
port(
	clk_25: in std_logic;   
	reset: in std_logic; --reset
	tc8x: in std_logic;
	tc4: in std_logic;
	tc: in std_logic;
	ttr: in std_logic;
	str: in std_logic;
	ack: in std_logic;
	se8x: out std_logic;
	se2: out std_logic;
	--le8x: out std_logic;
	oe2: out std_logic;
	rx_rdy: out std_logic;
	r8x: out std_logic;
	r2: out std_logic;--reset componente del datapath
	r_cnt8x: out std_logic;--reset componente del datapath
	r_cnt1: out std_logic;--reset componente del datapath
	r_cnt4: out std_logic;--reset componente del datapath
	r_cnt2: out std_logic;--reset componente del datapath
	ce8x: out std_logic;
	ce4: out std_logic;
	ce1: out std_logic;
	ce2: out std_logic 
	); 
end component;
 
begin
 
datapath: datapath_rx port map(rx_r, clk_25, ce8x, ce4, ce1, ce2, se8x, se2, oe2, reset, r_cnt1, r_cnt2, r_cnt8x, r_cnt4, r_s8x, r_s2, d_in, tc8x, tc4, tc, ttr, str);
fsm:	fsm_rx port map(clk_25, reset, tc8x, tc4, tc, ttr, str, ack, se8x, se2, oe2, rx_rdy, r_s8x, r_s2, r_cnt8x, r_cnt1, r_cnt4, r_cnt2, ce8x, ce4, ce1, ce2);
end structural; 
	 
	 