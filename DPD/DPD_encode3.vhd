--
--Este módulo realiza el la codificación según Densely Packed Decimal
-- Efectúa la codificación de 3 dígitos BCD


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


library UNISIM;
use UNISIM.VComponents.all;

entity DPD_encode3 is
    Port ( di : in  STD_LOGIC_VECTOR (11 downto 0);
           do : out  STD_LOGIC_VECTOR (9 downto 0));
end DPD_encode3;

architecture Behavioral of DPD_encode3 is

signal tmp, tmp2, tmp3, tmp4: std_logic;
-- estas son señales auxiliares intermedias

begin

	tmp <= di(11) and (not di(3));
	tmp2 <= di(11) and (not di(7)) and di(3);

	do(9) <= (di(10) and (not di(11))) or (di(2) and tmp) or (di(6) and tmp2); 
	do(8) <= (di(9) and (not di(11))) or (di(1) and tmp) or (di(5) and tmp2);
	do(7) <= di(8);
	
	tmp3 <= (not di(7)) and not(di(11) and di(3));
	tmp4 <= (not di(11)) and di(7) and not(di(3));
	
	do(6) <= (di(6) and tmp3) or (di(2) and tmp4) or (di(7) and di(3)) ;
 	do(5) <= (di(5) and tmp3) or (di(1) and tmp4) or (di(11) and di(3)) ;
	do(4) <= di(4);
	
	do(3) <= di(11) or di(7) or di(3); 
	do(2) <= di(11) or (di(7) and di(3)) or (di(2) and (not di(7)) and (not di(3)));
	do(1) <= di(7) or (di(11) and di(3)) or (di(1) and (not di(11)) and (not di(3)));
	
	do(0) <= di(0);
	
end Behavioral;

