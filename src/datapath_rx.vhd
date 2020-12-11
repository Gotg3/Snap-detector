library ieee;
use ieee.std_logic_1164.all;

entity datapath_rx is
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
end datapath_rx;

architecture structural of datapath_rx is

signal q_s8x_sig: std_logic_vector(7 downto 0);
signal d0_sig,d1_sig,d2_sig: std_logic;
signal voter_sig: std_logic;
	
	constant one: std_logic:= '1'; --costante 1
	constant zero: std_logic:= '0'; --costane 0
	
	component counter1_rx --DA IMPOSTARE N
		port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			tc: out std_logic
			);
end component;

component counter2_rx --DA IMPOSTARE N
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			ttr: out std_logic
			);
			
end component;

component counter4_rx --DA IMPOSTARE N
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			count: out std_logic_vector(10 downto 0);
			tc: out std_logic
			);
end component;
			
component counter8x_rx --DA IMPOSTARE N
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			count: out std_logic_vector(8 downto 0);
			tc: out std_logic
			);
end component;
			
component m_voter 
	port(
	d0,d1,d2: in std_logic; --d0=A, d1=B, d2=C
			
			y: out std_logic	
	 );
end component;
	 
component shift_s_p
	generic (parallelism: integer :=8);
	port(
		se: in std_logic;
		--le: in std_logic;
		oe: in std_logic;
		clk: in std_logic;
		d: in std_logic; 
		q: out std_logic_vector(parallelism-1 downto 0);
		rst: in std_logic
	);
end component;

component shift8x 
	generic (parallelism: integer :=8);
	port(
		se: in std_logic;
		--le: in std_logic;
		oe: in std_logic;
		clk: in std_logic;
		d: in std_logic; 
		q: out std_logic_vector(parallelism-1 downto 0);
		rst: in std_logic
		);
end component;

component str
	port(
		and_in: in std_logic_vector(7 downto 0);
		and_out: out std_logic
	);
end component;	
	
	begin

cnt1: counter1_rx
port map(
clk=>clk,
rst=>r_cnt1,
en=>ce1,
tc=>tc1
);

cnt2: counter2_rx

port map(
clk=>clk,
rst=>r_cnt2,
en=>ce2,
ttr=>ttr
);

cnt8x: counter8x_rx
port map(
clk=>clk,
rst=>r_cnt8x,
en=>ce8x,
tc=>tc8x
);

cnt4: counter4_rx
port map(
clk=>clk,
rst=>r_cnt4,
en=>ce4,
tc=>tc4
);

sr8x: shift8x
port map(
clk=>clk,
oe=>one, --deve sempre essere abilitato per campionare
se=>se8x,
d=>rx,
q=>q_s8x_sig,
rst=>r_s8x
);

sr2: shift_s_p
port map(
clk=>clk,
oe=>oe2, --deve sempre essere abilitato per campionare
se=>se2,
d=>voter_sig,
q=>d_in,
rst=>r_s8x
);

voter: m_voter
port map(
d0=>q_s8x_sig(4),
d1=>q_s8x_sig(3),
d2=>q_s8x_sig(2),
y=>voter_sig
);

and_start: str	
port map(
and_in=>q_s8x_sig,
and_out=>start
);

end structural;
