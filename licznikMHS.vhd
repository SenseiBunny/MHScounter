library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_bit.all;

entity licznikMHS is
port (
	clk:in bit;
	clear: in bit;
	ot1 : out std_logic_vector(6 downto 0);
	ot2 : out std_logic_vector(6 downto 0);
	ot3 : out std_logic_vector(6 downto 0);
	ot4 : out std_logic_vector(6 downto 0);
	ot5 : out std_logic_vector(6 downto 0);
	ot6 : out std_logic_vector(6 downto 0)
);
end licznikMHS;


architecture behaviour of licznikMHS is
signal sek_cnt: integer range 0 to 50000000;
signal count1:  integer range 0 to 3600;

signal num1: integer range 0 to 3600;
signal num2: bit_vector(3 downto 0);
signal num3: bit_vector(3 downto 0);

signal num4: integer range 0 to 3600;
signal num5: bit_vector(3 downto 0);
signal num6: bit_vector(3 downto 0);


signal num8: bit_vector(3 downto 0);
signal num9: bit_vector(3 downto 0);


signal hrs: integer range 0 to 24;

component displayHEX3 is
port (
i1 : in bit_vector(3 downto 0);
o1 : out std_logic_vector(6 downto 0);
i2 : in bit_vector(3 downto 0);
o2 : out std_logic_vector(6 downto 0)
);
end component;

begin 

	process(clk,clear)
		begin
		if(clear='1') THEN
			count1<=0;
			sek_cnt<=0;
			hrs<=0;
		elsif(clk'event and clk='1') THEN
			sek_cnt<=sek_cnt+1;
			if(sek_cnt>=50000000) THEN
				sek_cnt<=0;
				if(count1>=3600) THEN
					count1<=0;
					if(hrs>=24) THEN
						hrs<=0;
					else
						hrs<=hrs+1;
					end if;
				else
					count1<=count1+1;
				end if;
			end if;
		end if;
	end process;
	
	num1<=count1 mod 60;
	num2<=bit_vector(to_unsigned(num1 mod 10, 4));--sek jednosci
	num3<=bit_vector(to_unsigned(num1 / 10, 4));--sek dziesietne
	
	num4<=count1 / 60;
	num5<=bit_vector(to_unsigned(num4 mod 10, 4)); --min jednosci
	num6<=bit_vector(to_unsigned(num4 / 10, 4));--min dziesietne
	
	num8<=bit_vector(to_unsigned(hrs mod 10, 4)); --godziny jednosci
	num9<=bit_vector(to_unsigned(hrs / 10, 4)); --godziny dziesietne

	
	gate1:displayHEX3 port map(num2,ot1,num3,ot2);
	gate2:displayHEX3 port map(num5,ot3,num6,ot4);
	gate3:displayHEX3 port map(num8,ot5,num9,ot6);
	
end behaviour;
	