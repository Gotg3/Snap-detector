library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity trasmettitore is
port(D_out: in std_logic_vector(7 downto 0);
	  clk, reset: in std_logic;
	  Data_valid: in std_logic;
	  Tx_t, Tx_rdy: out std_logic);
end  trasmettitore;

architecture structural of trasmettitore is

signal TC, TTR, Cnt_E1, Cnt_E2, S_en, L_en, R_1, R_2, R_r: std_logic;
signal mux_sel : std_logic_vector(1 downto 0);

component data_path is --dichiaro tutti IN e OUT della entity che racchiude tutti i componenti
	port(
		R_cnt1, R_cnt2, R_reg,ck,le,ce1,ce2,se: in std_logic;
		d_out_in: in std_logic_vector(7 downto 0);
		d_valid: in std_logic;
		tc,ttr: out std_logic;
		sel: in std_logic_vector(1 downto 0);
		tx: out std_logic
		);
end component;

component macchina_stati is
port(reset,clk_25, TC_cnt,TTR_cnt,d_val: in std_logic;--clock a 25 MHz
     R_cnt1, R_cnt2, R_reg, CE1, LE, SE, TxRDY:  out std_logic; 
	  CE2: out std_logic;
	  Sel: out std_logic_vector (1 downto 0));
end component;
 
begin
 
datapath: data_path port map(R_1, R_2, R_r, clk, L_en, Cnt_E1, Cnt_E2, S_en, D_out,Data_valid, TC, TTR, mux_sel, Tx_t);
fsm:	macchina_stati port map(reset, clk, TC, TTR, Data_valid, R_1, R_2, R_r, Cnt_E1,  L_en, S_en, Tx_rdy,Cnt_E2, mux_sel);
end structural; 
	 