library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity digital_clock is
generic(clk_frq: integer:=5000);
port(
clk, reset, alarm_enable: in std_logic;
set_alarm_h: in std_logic_vector(4 downto 0);
set_alarm_m: in std_logic_vector(5 downto 0);
alarm_out: out std_logic;
seg7: out std_logic_vector(6 downto 0);
digit_select: out std_logic_vector(5 downto 0)
);

end digital_clock;

architecture Behavioral of digital_clock is
signal counter: integer range 0 to clk_frq :=0;
signal pulse: std_logic :='0';
signal hour_tens: integer range 0 to 2 :=0;
signal hour_ones:integer range 0 to 9 :=0;
signal min_tens: integer range 0 to 5 :=0;
signal min_ones: integer range 0 to 9 :=0;
signal sec_tens: integer range 0 to 5 :=0;
signal sec_ones: integer range 0 to 9 :=0;
signal current_hour: integer range 0 to 23 :=0;
signal current_min: integer range 0 to 59 :=0;
signal current_sec: integer range 0 to 59 :=0;
signal refresh_counter: unsigned(15 downto 0) := (others =>'0');
signal mux_select: std_logic_vector(2 downto 0) :="000";
signal digit: integer range 0 to 9 := 0;

begin

process(clk,reset)
begin
	if reset='1' then
		counter<=0;
		pulse<='0';
		refresh_counter<= (others=>'0');
	elsif rising_edge(clk) then
		refresh_counter<= refresh_counter+1;
			if counter=clk_frq-1 then
				counter<=0;
				pulse<='1';
			else 
				counter<=counter+1;
				pulse<='0';
				
				end if;
				end if;
		end process;
		
		
	process(clk,reset)
begin
		if reset='1' then
			hour_tens<=0;
			hour_ones<=0;
			min_tens<=0;
			min_ones<=0;
			sec_tens<=0;
			sec_ones<=0;
		elsif rising_edge(clk) then
			if pulse='1' then
				if sec_ones=9 then
					sec_ones<=0;
				if sec_tens=5 then
					sec_tens<=0;
				
				if min_ones=9 then
					min_ones<=0;
				if min_tens=5 then
					min_tens<=0;
				
				if hour_tens=2 and hour_ones=3 then
					hour_ones<=0;
					hour_tens<=0;
				else
				if hour_ones=9 then
					hour_ones<=0;
					hour_tens<= hour_tens +1;
				else 
					hour_ones<= hour_ones +1;
				end if;
				end if;
				
				else 
					min_tens<= min_tens +1;
					end if;
				else 
					min_ones<= min_ones +1;
					end if;
				else 
					 sec_tens<= sec_tens +1;
					 end if;
				else 
					 sec_ones<= sec_ones +1;
					 end if;
					 
				end if;
				end if;
			   end process;
			
	 current_hour<=(hour_tens * 10)+ hour_ones;
    current_min<=(min_tens * 10)+ min_ones;
    current_sec<=(sec_tens * 10)+ sec_ones;
	 
process(clk,reset)
begin
	if reset='1' then
		alarm_out<='0';
	elsif rising_edge(clk) then
		if alarm_enable='1' and
			current_hour= to_integer(unsigned(set_alarm_h)) and current_min= to_integer(unsigned(set_alarm_m)) and 
			current_sec<50 then
			alarm_out<='1';
			else 
				alarm_out<='0';
		end if;
		end if;
	   end process;
	 
	 
	 mux_select<= std_logic_vector(refresh_counter(15 downto 13));
	 
process(mux_select, hour_ones, hour_tens, min_tens, min_ones, sec_tens, sec_ones)
begin
	case mux_select is
		when "000"=> digit_select<="111110"; digit<=sec_ones;
		when "001"=> digit_select<="111101"; digit<=sec_tens;
		when "010"=> digit_select<="111011"; digit<=min_ones;
		when "011"=> digit_select<="110111"; digit<=min_tens;
		when "100"=> digit_select<="101111"; digit<=hour_ones;
		when "101"=> digit_select<="011111"; digit<=hour_tens;
		when others=> digit_select<="111111"; digit<=0;
		end case;
		end process;

process(digit)
begin
	case digit is
		when 0=> seg7<="0111111";
		when 1=> seg7<="0000110";
		when 2=> seg7<="1011011";
		when 3=> seg7<="1001111";
		when 4=> seg7<="1100110";
		when 5=> seg7<="1101101";
		when 6=> seg7<="1111101";
		when 7=> seg7<="0000111";
		when 8=> seg7<="1111111";
		when 9=> seg7<="1101111";
		when others=> seg7<="0000000";
		end case;
		end process;

end Behavioral;

