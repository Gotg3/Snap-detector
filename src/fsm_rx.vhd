library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_rx is
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
	oe2: out std_logic;
	rx_rdy: out std_logic;
	r8x,r2,r_cnt8x,r_cnt1,r_cnt4, r_cnt2,ce8x,ce4,ce1,ce2: out std_logic --reset dei componenti del datapath
	); 
end fsm_rx;

architecture behavioural of fsm_rx is

type State_type is ( rst, idle_a, idle_b, start_a, start_b, start_c,dato_a,dato_b,dato_c,dato_c_bis,dato_d,dato_e,dato_f,output, output_end);
signal stato: State_type:= rst;
signal tc8x_sig, tc4_sig, tc_sig, ttr_sig, str_sig,ack_sig:std_logic;

begin

R: process(clk_25)
begin

	if(clk_25' event and clk_25='1') then
	
		case stato is
			
			when rst=>
				stato<=idle_a;
			
			when idle_a=>
				if reset ='1' then
					stato<=rst;
				elsif (tc8x_sig='1') then
					stato<=idle_b;
				elsif (str_sig='1' ) then 
					stato<=start_a;
				else
					stato<=idle_a;
				end if;
			
			when idle_b=>
				if reset='1' then
					stato<=rst;
				else
					stato<=idle_a;
				end if;
			
			when start_a=>
				if reset='1' then
					stato<=rst;
				elsif(tc4_sig='0' and tc8x_sig='1') then
					stato<=start_b;
				elsif(tc8x_sig='1' and tc4_sig='1') then
					stato<=start_c;
				else 
					stato<=start_a;
				end if;
			
			when start_b=>
				if reset='1' then
					stato<=rst;
				else
					stato<=start_a;
				end if;
			
			when start_c=>
				if reset='1' then
					stato<=rst;
				else
					stato<=dato_a;
				end if;
			
			when dato_a=>
				if reset='1' then
					stato<=rst;
				elsif(tc_sig='0' and tc8x_sig='1') then
					stato<=dato_b;
				elsif(tc_sig='1' and tc8x_sig='1') then
					stato<=dato_c;
				else
					stato<=dato_a;
				end if;
			
			when dato_b=>
				if reset='1' then
					stato<=rst;
				else
					stato<=dato_a;
				end if;
			
			when dato_c=>
				if reset='1' then
					stato<=rst;
				else
					stato<=dato_d;
				end if;
			
			when dato_d=>
				if reset='1' then
					stato<=rst;
				elsif((tc8x_sig='1' and tc_sig='0') and ttr_sig='0') then 
					stato<=dato_c_bis;
				elsif((tc8x_sig='1' and tc_sig='1') and ttr_sig='0') then 
					stato<=dato_e;
				elsif((tc8x_sig='1' and tc_sig='1') and ttr_sig='1') then 
					stato<=dato_f;
				else
					stato<=dato_d;
				end if;
			when dato_c_bis=>
				if reset='1' then
					stato<=rst;
				else
					stato<=dato_d;
				end if;
			when dato_e=>
				if reset='1' then
					stato<=rst;
				else
					stato<=dato_d;
				end if;
			
			when dato_f=>
				if reset='1' then
					stato<=rst;
				else
					stato<=output;
				end if;
			when output=>
				if reset='1' then
					stato<=rst;
				elsif ack_sig='1' then
					stato<=output_end;
				else 
					stato<=output;
				end if;
			
			when output_end=>
				if reset='1' then
					stato<=rst;
				else
					stato<=idle_a;
				end if;
			when others=>
				stato<=rst;
		end case;
	end if;
end process R;

L:process(stato)
begin
	case stato is
		when rst=>
			r8x<='1';
			r2<='1';
			r_cnt8x<='1';
			r_cnt1<='1';
			r_cnt4<='1';
			r_cnt2<='1';
			oe2<='0';
			se2<='0';
			se8x<='0';
			ce8x<='0';
			ce4<='0';
			ce1<='0';
			ce2<='0';
			rx_rdy<='0';
		
		when idle_a=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='0';
			se8x<='0';
			ce8x<='1';
			ce4<='0';
			ce1<='0';
			ce2<='0';
			rx_rdy<='0';

	
		when idle_b=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='0';
			se8x<='1';
			ce8x<='1';
			ce4<='0';
			ce1<='0';
			ce2<='0';
			rx_rdy<='0';
			
		when start_a=>
			r8x<='0';
			r2<='1';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='0';
			se8x<='0';
			ce8x<='1';
			ce4<='1';
			ce1<='0';
			ce2<='0';
			rx_rdy<='0';
			
		when start_b=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='0';
			se8x<='1';
			ce8x<='1';
			ce4<='1';
			ce1<='0';
			ce2<='0';
			rx_rdy<='0';
			
		when start_c=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='0';
			se8x<='1';
			ce8x<='1';
			ce4<='0';
			ce1<='1';
			ce2<='0';
			rx_rdy<='0';
			
		when dato_a=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='0';
			se8x<='0';
			ce8x<='1';
			ce4<='0';
			ce1<='1';
			ce2<='0';
			rx_rdy<='0';
			
		when dato_b=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='0';
			se8x<='1';
			ce8x<='1';
			ce4<='0';
			ce1<='1';
			ce2<='0';
			rx_rdy<='0';
			
		when dato_c=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='1';
			se8x<='1';
			ce8x<='1';
			ce4<='0';
			ce1<='1';
			ce2<='1';
			rx_rdy<='0';

		when dato_c_bis=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='0';
			se8x<='1';
			ce8x<='1';
			ce4<='0';
			ce1<='1';
			ce2<='1';
			rx_rdy<='0';
			
		when dato_d=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='0';
			se8x<='0';
			ce8x<='1';
			ce4<='0';
			ce1<='1';
			ce2<='1';
			rx_rdy<='0';
			
		when dato_e=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='1';
			se8x<='1';
			ce8x<='1';
			ce4<='0';
			ce1<='1';
			ce2<='1';
			rx_rdy<='0';
			
		when dato_f=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='1';
			se8x<='1';
			ce8x<='1';
			ce4<='0';
			ce1<='0';
			ce2<='0';
			rx_rdy<='1';
			
		when output=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='1';
			se2<='0';
			se8x<='0';
			ce8x<='1';
			ce4<='0';
			ce1<='0';
			ce2<='0';
			rx_rdy<='1';			
			
		when output_end=>
			r8x<='0';
			r2<='0';
			r_cnt8x<='0';
			r_cnt1<='0';
			r_cnt4<='0';
			r_cnt2<='0';
			oe2<='0';
			se2<='0';
			se8x<='0';
			ce8x<='1';
			ce4<='0';
			ce1<='0';
			ce2<='0';
			rx_rdy<='0';
	end case;
end process L;

tc8x_sig<=tc8x;
tc4_sig<=tc4;
tc_sig<=tc;
ttr_sig<=ttr;
str_sig<=str;
ack_sig<=ack;

end behavioural;
			
			
		