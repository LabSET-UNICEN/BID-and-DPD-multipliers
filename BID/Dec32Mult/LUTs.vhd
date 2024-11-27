-- Unidad de redondeo
--   ENTRADAS
--       Ci_53_0 mantisa de entrada. Es el resultado de la operacion que se realizó y hay que redondear
--       d_10_0  cantidad de digitos decimales a redondear
--       Si signo de la mantisa de entrada
--	     rounding_mode modo de redondeo (RTE, RTA, RTZ, RTN o RTP)

--   SALIDAS
--	     Co mantisa redondeada de salida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity luts_unit is
  port (K_index       : IN std_logic_vector (6 downto 0);		-- indice de las luts
	    dprima_out    : OUT std_logic_vector(6 downto 0);		-- valor de dprima
	    diezN_out     : OUT std_logic_vector(47 downto 0)		-- valor de 10**N	    
        );
end entity luts_unit;

architecture behavior of luts_unit is

begin  

            
 -- LUT generador de dprima_out
  process(K_index)
  begin
   case K_index is
        when "0010111" => dprima_out(2 downto 0) <= "000";  --K = 23
        
        when "0011000" => dprima_out(2 downto 0) <= "001";  --K = 24
        when "0011001" => dprima_out(2 downto 0) <= "001";  --K = 25
        when "0011010" => dprima_out(2 downto 0) <= "001";  --K = 26
        
        when "0011011" => dprima_out(2 downto 0) <= "010";  --K = 27
        when "0011100" => dprima_out(2 downto 0) <= "010";  --K = 28
        when "0011101" => dprima_out(2 downto 0) <= "010";  --K = 29
        
        when "0011110" => dprima_out(2 downto 0) <= "011";  --K = 30
        when "0011111" => dprima_out(2 downto 0) <= "011";  --K = 31
        when "0100000" => dprima_out(2 downto 0) <= "011";  --K = 32
        when "0100001" => dprima_out(2 downto 0) <= "011";  --K = 33
        
        when "0100010" => dprima_out(2 downto 0) <= "100";  --K = 34
        when "0100011" => dprima_out(2 downto 0) <= "100";  --K = 35
        when "0100100" => dprima_out(2 downto 0) <= "100";  --K = 36
        
        when "0100101" => dprima_out(2 downto 0) <= "101";  --K = 37
        when "0100110" => dprima_out(2 downto 0) <= "101";  --K = 38
        when "0100111" => dprima_out(2 downto 0) <= "101";  --K = 39
        
        when "0101000" => dprima_out(2 downto 0) <= "110";  --K = 40
        when "0101001" => dprima_out(2 downto 0) <= "110";  --K = 41
        when "0101010" => dprima_out(2 downto 0) <= "110";  --K = 42
        when "0101011" => dprima_out(2 downto 0) <= "110";  --K = 43
        
        when "0101100" => dprima_out(2 downto 0) <= "111";  --K = 44
        when "0101101" => dprima_out(2 downto 0) <= "111";  --K = 45
        when "0101110" => dprima_out(2 downto 0) <= "111";  --K = 46
        
        when others => dprima_out <= "0000000";
   end case;        
  end process;


 -- LUT generador de diezN_out
  process(K_index)
  begin
   case K_index is
        when "0010111" => diezN_out <= x"000000989680";  --K = 23
        
        when "0011000" => diezN_out <= x"000005F5E100";  --K = 24
        when "0011001" => diezN_out <= x"000005F5E100";  --K = 25
        when "0011010" => diezN_out <= x"000005F5E100";  --K = 26
        
        when "0011011" => diezN_out <= x"00003B9ACA00";  --K = 27
        when "0011100" => diezN_out <= x"00003B9ACA00";  --K = 28
        when "0011101" => diezN_out <= x"00003B9ACA00";  --K = 29
        
        when "0011110" => diezN_out <= x"0002540BE400";  --K = 30
        when "0011111" => diezN_out <= x"0002540BE400";  --K = 31
        when "0100000" => diezN_out <= x"0002540BE400";  --K = 32
        when "0100001" => diezN_out <= x"0002540BE400";  --K = 33
        
        when "0100010" => diezN_out <= x"00174876E800";  --K = 34
        when "0100011" => diezN_out <= x"00174876E800";  --K = 35
        when "0100100" => diezN_out <= x"00174876E800";  --K = 36
        
        when "0100101" => diezN_out <= x"00E8D4A51000";  --K = 37
        when "0100110" => diezN_out <= x"00E8D4A51000";  --K = 38
        when "0100111" => diezN_out <= x"00E8D4A51000";  --K = 39
        
        when "0101000" => diezN_out <= x"90184E72A000";  --K = 40
        when "0101001" => diezN_out <= x"09184E72A000";  --K = 41
        when "0101010" => diezN_out <= x"09184E72A000";  --K = 42
        when "0101011" => diezN_out <= x"09184E72A000";  --K = 43
        
        when "0101100" => diezN_out <= x"5AF3107A4000";  --K = 44
        when "0101101" => diezN_out <= x"5AF3107A4000";  --K = 45
        when "0101110" => diezN_out <= x"5AF3107A4000";  --K = 46
                
        when others => diezN_out <= x"000000000000";
   end case;        
  end process;
end architecture behavior;