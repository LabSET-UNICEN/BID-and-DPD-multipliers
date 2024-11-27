-- este módulo se obtiene de Neto
-- sirve para convertir un dígito BCD/excess-6 a BCD
-- dbcd indica si la entrada es bcd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BCDe6_to_BCD is
    Port ( din : in STD_LOGIC_VECTOR (3 downto 0);
           dbcd : in STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (3 downto 0));
end BCDe6_to_BCD;

architecture Behavioral of BCDe6_to_BCD is

begin

    dout(0) <= din(0);
    dout(1) <= din(1) xor (not (dbcd));
    dout(2) <= ((din(2) xor din(1)) and (not (dbcd))) or (din(2) and dbcd);
    dout(3) <= (din(3)and din(2) and din(1) and (not (dbcd))) or (din(3) and dbcd);
    
end Behavioral;
