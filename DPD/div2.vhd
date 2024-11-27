

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



library UNISIM;
use UNISIM.VComponents.all;

entity div2 is
    Port ( v : in  STD_LOGIC_VECTOR (3 downto 0);
           ci: in std_logic;			
           d : out  STD_LOGIC_VECTOR (3 downto 0);
           co : out  std_logic);
end div2;

architecture Behavioral of div2 is

begin

	d <= ('0'&v(3 downto 1))+('0'&ci&'0'&ci);
	co <= v(0);

end Behavioral;

