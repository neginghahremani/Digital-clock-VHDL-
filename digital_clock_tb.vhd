library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity digital_clock_tb is
end digital_clock_tb;

architecture Behavioral of digital_clock_tb is

component digital_clock is
generic(
    clk_frq: integer:= 5000
);
port(
    clk, reset, alarm_enable: in std_logic;
    set_alarm_h: in std_logic_vector(4 downto 0);
    set_alarm_m: in std_logic_vector(5 downto 0);
    alarm_out: out std_logic;
    seg7: out std_logic_vector(6 downto 0);
    digit_select: out std_logic_vector(5 downto 0)
);
end component;

signal clk_tb: std_logic:= '0';
signal reset_tb: std_logic:= '0';
signal alarm_enable_tb: std_logic:= '0';
signal set_alarm_h_tb: std_logic_vector(4 downto 0):= "00000";
signal set_alarm_m_tb: std_logic_vector(5 downto 0):= "000000";
signal alarm_out_tb : std_logic;
signal seg7_tb: std_logic_vector(6 downto 0);
signal digit_select_tb: std_logic_vector(5 downto 0);

begin
uut: digital_clock
generic map(
    clk_frq=>5000)
	 
port map(
    clk=> clk_tb,
    reset=> reset_tb,
    alarm_enable=> alarm_enable_tb,
    set_alarm_h=> set_alarm_h_tb,
    set_alarm_m=> set_alarm_m_tb,
    alarm_out=> alarm_out_tb,
    seg7=> seg7_tb,
    digit_select=> digit_select_tb );

clk_tb<= not clk_tb after 100000 ns;

stim_process: process
begin
    reset_tb<= '1';
    alarm_enable_tb<= '0';

    set_alarm_h_tb<= "00000";
    set_alarm_m_tb<= "000001";
    wait for 1 ms;

    reset_tb<= '0';
    alarm_enable_tb<= '1';
    wait for 60 sec;

    wait for 49 sec;
    wait for 2 sec;

    alarm_enable_tb<= '0';
    wait for 2 sec;

    reset_tb<= '1';
    wait for 1 sec;

    reset_tb<= '0';
    wait for 2 sec;

    wait;
end process;

end Behavioral;