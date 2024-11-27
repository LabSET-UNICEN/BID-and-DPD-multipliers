--
--Este módulo realiza el la decodificación según Densely Packed Decimal
-- Efectúa la decodificación de 3 dígitos BCD


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity DPD_decode3 is
    Port ( di : in  STD_LOGIC_VECTOR (9 downto 0);
           do : out  STD_LOGIC_VECTOR (11 downto 0));
end DPD_decode3;

architecture Behavioral of DPD_decode3 is

signal tmp, tmp2, tmp3, tmp4, tmp5: std_logic;
-- estas son señales auxiliares intermedias

begin

	do(11) <= (di(3) and di(2)) and
	( ((not di(1)) or (not di(6))) or  (di(6) and di(5)) );   
	
	tmp <= ((not di(3)) or (not di(2)) or (di(1) and di(6) and (not di(5))));
	
	do(10)<= di(9) and tmp;
	do(9) <= di(8) and tmp;
	do(8) <= di(7);
	
	do(7) <= di(3) and (  ((not di(2)) and di(1)) or 
	        (di(2) and di(1) and (di(6) or (not di(5)))) );
	
	tmp2 <= di(3) and di(2) and di(1) and ((not di(6)) and di(5));
	tmp3 <= (not di(3)) or (di(3) and ( not di(1)));
	
	do(6) <= (di(6) and tmp3) or (di(9)and tmp2);
	do(5) <= (di(5) and tmp3) or (di(8)and tmp2);
	do(4) <= di(4);
	
	do(3) <= di(3) and (  ((not di(2)) and ( not di(1)) ) or 
	        (di(2) and di(1) and (di(6) or di(5)) ) );
	
	tmp4 <= di(3) and di(2) and (
	        (not di(1)) or ((not di(6)) and ( not di(5))));

	tmp5 <= di(3) and (not di(2)) and di(1);
	
	do(2) <= (di(2) and (not di(3))) or 
	         (di(6) and tmp5) or (di(9) and tmp4);
	
	do(1) <= (di(1) and (not di(3))) or 
	         (di(5) and tmp5) or (di(8) and tmp4);
	
	do(0) <= di(0);

end Behavioral;

