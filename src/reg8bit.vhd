LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY reg8bit IS
GENERIC ( N : integer:=8);
PORT (R : IN std_logic_vector(N-1 DOWNTO 0);
	Clock, Resetn, EN : IN STD_LOGIC;
	Q : OUT std_logic_vector(N-1 DOWNTO 0));
END reg8bit;

ARCHITECTURE Behavior OF reg8bit IS
BEGIN
	PROCESS (Clock, Resetn, EN)
		BEGIN
			IF (Resetn = '1') THEN
				Q <= (OTHERS => '0');
			ELSIF (Clock'EVENT AND Clock = '1') AND EN='1' THEN
				Q <= R;
			END IF;
	END PROCESS;
END Behavior;