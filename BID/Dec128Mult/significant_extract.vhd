-- Unidad de extraccion de mantisa, bit de redondeo (r*) y bit pegajoso (s*)
-- ENTRADAS:
--   P(108:54) es la parte util del resultado de la multiplicacion
--   d(3:0) es la cantidad de digitos decimales a desplazar a derecha sobre P

-- SALIDAS:
--   Ctmp es la mantisa resultante luego del redondeo. Contiene '0' adelante
--   r* es indicador de resto = 0.5
--   s* es indicador de que al menos algun bit restante del resto es '1'

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_shifter is
  port (P_in       : in  std_logic_vector(226 downto 0);  	--input
        d_4_0      : in  std_logic_vector(5 downto 0);   	-- position
        Ctmp       : out std_logic_vector(112 downto 0);  	--output
		r_asterisk : out std_logic;							-- bit r*
		s_asterisk : out std_logic							-- bit s* sticky bit
        );
end entity data_shifter;

architecture behavior of data_shifter is
  signal desp : std_logic_vector(6 downto 0);
  signal resto : std_logic_vector(112 downto 0);
  signal temp1 : std_logic_vector(339 downto 0);
  signal temp2 : std_logic_vector(339 downto 0);
begin

-- d_4_0 es la cantidad de digitos decimales a desplazar a la derecha
-- Se indexa una LUT con d_4_0 para calculad la cantidad de bits, desp, a desplazar
  process(d_4_0)
  begin
   case d_4_0 is
        when "000000" => desp <= "0000000";  --desplaza 0 bits
        when "000001" => desp <= "0000100";  --desplaza 4 bits
        when "000010" => desp <= "0000111";  --desplaza 7 bits
        when "000011" => desp <= "0001010";  --desplaza 10 bits
        when "000100" => desp <= "0001110";  --desplaza 14 bits
        when "000101" => desp <= "0010001";  --desplaza 17 bits
        when "000110" => desp <= "0010100";  --desplaza 20 bits
        when "000111" => desp <= "0011000";  --desplaza 24 bits
        when "001000" => desp <= "0011011";  --desplaza 27 bits
        when "001001" => desp <= "0011110";  --desplaza 30 bits
        when "001010" => desp <= "0100010";  --desplaza 34 bits
        when "001011" => desp <= "0100101";  --desplaza 37 bits
        when "001100" => desp <= "0101000";  --desplaza 40 bits
        when "001101" => desp <= "0101100";  --desplaza 44 bits
        when "001110" => desp <= "0101111";  --desplaza 47 bits
        when "001111" => desp <= "0110010";  --desplaza 50 bits
        when "010000" => desp <= "0110110";  --desplaza 54 bits
        when "010001" => desp <= "0111001";  --desplaza 57 bits
        when "010010" => desp <= "0111100";  --desplaza 60 bits
        when "010011" => desp <= "1000000";  --desplaza 64 bits
        when "010100" => desp <= "1000011";  --desplaza 67 bits
        when "010101" => desp <= "1000110";  --desplaza 70 bits
        when "010110" => desp <= "1001010";  --desplaza 74 bits
        when "010111" => desp <= "1001101";  --desplaza 77 bits
        when "011000" => desp <= "1010000";  --desplaza 80 bits
        when "011001" => desp <= "1010100";  --desplaza 84 bits
        when "011010" => desp <= "1010111";  --desplaza 87 bits
        when "011011" => desp <= "1011010";  --desplaza 90 bits
        when "011100" => desp <= "1011110";  --desplaza 94 bits
        when "011101" => desp <= "1100001";  --desplaza 97 bits
        when "011110" => desp <= "1100100";  --desplaza 100 bits
        when "011111" => desp <= "1101000";  --desplaza 104 bits
        when "100000" => desp <= "1101011";  --desplaza 107 bits
        when "100001" => desp <= "1101110";  --desplaza 110 bits
        when "100010" => desp <= "1110001";  --desplaza 113 bits
        when others =>   desp <= "0000000";
   end case;        
  end process;
  
-- desplaza desp bits a la derecha obteniendo Ctmp y resto
  temp1 <= P_in(112 downto 0) & "000" & x"00000000000000000000000000000000000000000000000000000000";
  temp2 <= std_logic_vector(shift_right(unsigned(temp1), to_integer(unsigned(desp))));
  Ctmp <= temp2(225 downto 113);  
  resto <= temp2(112 downto 0); 


-- calcula r*
   r_asterisk <= resto(112);
 
-- calcula s*   
   process (resto)
   begin
     if  unsigned(resto(111 downto 0)) = 0 then --"00000000000000000000000000000000000000000000000000" then
        s_asterisk <= '0';
     else 
        s_asterisk <= '1';
     end if;
   end process;  
  
end architecture behavior;