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
  port (P_in       : in  std_logic_vector(108 downto 0);  	--input
        d_4_0      : in  std_logic_vector(4 downto 0);   	-- position
        Ctmp       : out std_logic_vector(53 downto 0);  	--output
		r_asterisk : out std_logic;							-- bit r*
		s_asterisk : out std_logic							-- bit s* sticky bit
        );
end entity data_shifter;

architecture behavior of data_shifter is
  signal desp : std_logic_vector(5 downto 0);
  signal resto : std_logic_vector(53 downto 0);
  signal temp1 : std_logic_vector(162 downto 0);
  signal temp2 : std_logic_vector(162 downto 0);
begin

-- d_4_0 es la cantidad de digitos decimales a desplazar a la derecha
-- Se indexa una LUT con d_4_0 para calculad la cantidad de bits, desp, a desplazar
  process(d_4_0)
  begin
   case d_4_0 is
        when "00000" => desp <= "000000";  --desplaza 0 bits
        when "00001" => desp <= "000100";  --desplaza 4 bits
        when "00010" => desp <= "000111";  --desplaza 7 bits
        when "00011" => desp <= "001010";  --desplaza 10 bits
        when "00100" => desp <= "001110";  --desplaza 14 bits
        when "00101" => desp <= "010001";  --desplaza 17 bits
        when "00110" => desp <= "010100";  --desplaza 20 bits
        when "00111" => desp <= "011000";  --desplaza 24 bits
        when "01000" => desp <= "011011";  --desplaza 27 bits
        when "01001" => desp <= "011110";  --desplaza 30 bits
        when "01010" => desp <= "100010";  --desplaza 34 bits
        when "01011" => desp <= "100101";  --desplaza 37 bits
        when "01100" => desp <= "101000";  --desplaza 40 bits
        when "01101" => desp <= "101100";  --desplaza 44 bits
        when "01110" => desp <= "101111";  --desplaza 47 bits
        when "01111" => desp <= "110010";  --desplaza 50 bits
        when "10000" => desp <= "110101";  --desplaza 53 bits
        when others => desp <= "000000";
   end case;        
  end process;
  
-- desplaza desp bits a la derecha obteniendo Ctmp y resto
  temp1 <= P_in & "00" & x"0000000000000";
  temp2 <= std_logic_vector(shift_right(unsigned(temp1), to_integer(unsigned(desp))));
  Ctmp <= temp2(107 downto 54);  
  resto <= temp2(53 downto 0); 


-- calcula r*
   r_asterisk <= resto(53);
 
-- calcula s*   
   process (resto)
   begin
     if  unsigned(resto(52 downto 0)) = 0 then --"00000000000000000000000000000000000000000000000000" then
        s_asterisk <= '0';
     else 
        s_asterisk <= '1';
     end if;
   end process;  
  
end architecture behavior;