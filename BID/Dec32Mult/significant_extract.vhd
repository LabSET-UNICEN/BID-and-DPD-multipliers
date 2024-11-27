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
  port (P_in       : in  std_logic_vector(48 downto 0);  	--input
        d_4_0      : in  std_logic_vector(2 downto 0);   	-- position
        Ctmp       : out std_logic_vector(23 downto 0);  	--output
		r_asterisk : out std_logic;							-- bit r*
		s_asterisk : out std_logic							-- bit s* sticky bit
        );
end entity data_shifter;

architecture behavior of data_shifter is
  signal desp : std_logic_vector(4 downto 0);
  signal resto : std_logic_vector(23 downto 0);
  signal temp1 : std_logic_vector(72 downto 0);
  signal temp2 : std_logic_vector(72 downto 0);
begin

-- d_4_0 es la cantidad de digitos decimales a desplazar a la derecha
-- Se indexa una LUT con d_4_0 para calculad la cantidad de bits, desp, a desplazar
  process(d_4_0)
  begin
   case d_4_0 is
        when "000" => desp <= "00000";  --desplaza 0 bits
        when "001" => desp <= "00100";  --desplaza 4 bits
        when "010" => desp <= "00111";  --desplaza 7 bits
        when "011" => desp <= "01010";  --desplaza 10 bits
        when "100" => desp <= "01110";  --desplaza 14 bits
        when "101" => desp <= "10001";  --desplaza 17 bits
        when "110" => desp <= "10100";  --desplaza 20 bits
        when "111" => desp <= "11000";  --desplaza 24 bits
        when others => desp <= "00000";
   end case;        
  end process;
  
-- desplaza desp bits a la derecha obteniendo Ctmp y resto
  temp1 <= P_in & x"000000";
  temp2 <= std_logic_vector(shift_right(unsigned(temp1), to_integer(unsigned(desp))));
  Ctmp <= temp2(47 downto 24);  
  resto <= temp2(23 downto 0); 


-- calcula r*
   r_asterisk <= resto(23);
 
-- calcula s*   
   process (resto)
   begin
     if  unsigned(resto(22 downto 0)) = 0 then
        s_asterisk <= '0';
     else 
        s_asterisk <= '1';
     end if;
   end process;  
  
end architecture behavior;