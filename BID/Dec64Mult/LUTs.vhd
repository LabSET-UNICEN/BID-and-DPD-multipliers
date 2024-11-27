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
	    diezN_out     : OUT std_logic_vector(107 downto 0)		-- valor de 10**N	    
        );
end entity luts_unit;

architecture behavior of luts_unit is

begin  

            
 -- LUT generador de dprima_out
  process(K_index)
  begin
   case K_index is
        when "0110101" => dprima_out(4 downto 0) <= "00000";  --K = 53
        
        when "0110110" => dprima_out(4 downto 0) <= "00001";  --K = 54
        when "0110111" => dprima_out(4 downto 0) <= "00001";  --K = 55
        when "0111000" => dprima_out(4 downto 0) <= "00001";  --K = 56
        
        when "0111001" => dprima_out(4 downto 0) <= "00010";  --K = 57
        when "0111010" => dprima_out(4 downto 0) <= "00010";  --K = 58
        when "0111011" => dprima_out(4 downto 0) <= "00010";  --K = 59
        
        when "0111100" => dprima_out(4 downto 0) <= "00011";  --K = 60
        when "0111101" => dprima_out(4 downto 0) <= "00011";  --K = 61
        when "0111110" => dprima_out(4 downto 0) <= "00011";  --K = 62
        when "0111111" => dprima_out(4 downto 0) <= "00011";  --K = 63
        
        when "1000000" => dprima_out(4 downto 0) <= "00100";  --K = 64
        when "1000001" => dprima_out(4 downto 0) <= "00100";  --K = 65
        when "1000010" => dprima_out(4 downto 0) <= "00100";  --K = 66
        
        when "1000011" => dprima_out(4 downto 0) <= "00101";  --K = 67
        when "1000100" => dprima_out(4 downto 0) <= "00101";  --K = 68
        when "1000101" => dprima_out(4 downto 0) <= "00101";  --K = 69
        
        when "1000110" => dprima_out(4 downto 0) <= "00110";  --K = 70
        when "1000111" => dprima_out(4 downto 0) <= "00110";  --K = 71
        when "1001000" => dprima_out(4 downto 0) <= "00110";  --K = 72
        when "1001001" => dprima_out(4 downto 0) <= "00110";  --K = 73
        
        when "1001010" => dprima_out(4 downto 0) <= "00111";  --K = 74
        when "1001011" => dprima_out(4 downto 0) <= "00111";  --K = 75
        when "1001100" => dprima_out(4 downto 0) <= "00111";  --K = 76
        
        when "1001101" => dprima_out(4 downto 0) <= "01000";  --K = 77
        when "1001110" => dprima_out(4 downto 0) <= "01000";  --K = 78
        when "1001111" => dprima_out(4 downto 0) <= "01000";  --K = 79
        
        when "1010000" => dprima_out(4 downto 0) <= "01001";  --K = 80        
        when "1010001" => dprima_out(4 downto 0) <= "01001";  --K = 81
        when "1010010" => dprima_out(4 downto 0) <= "01001";  --K = 82
        when "1010011" => dprima_out(4 downto 0) <= "01001";  --K = 83
        
        when "1010100" => dprima_out(4 downto 0) <= "01010";  --K = 84
        when "1010101" => dprima_out(4 downto 0) <= "01010";  --K = 85
        when "1010110" => dprima_out(4 downto 0) <= "01010";  --K = 86
        
        when "1010111" => dprima_out(4 downto 0) <= "01011";  --K = 87
        when "1011000" => dprima_out(4 downto 0) <= "01011";  --K = 88
        when "1011001" => dprima_out(4 downto 0) <= "01011";  --K = 89
        
        when "1011010" => dprima_out(4 downto 0) <= "01100";  --K = 90     
        when "1011011" => dprima_out(4 downto 0) <= "01100";  --K = 91
        when "1011100" => dprima_out(4 downto 0) <= "01100";  --K = 92
        when "1011101" => dprima_out(4 downto 0) <= "01100";  --K = 93
        
        when "1011110" => dprima_out(4 downto 0) <= "01101";  --K = 94
        when "1011111" => dprima_out(4 downto 0) <= "01101";  --K = 95
        when "1100000" => dprima_out(4 downto 0) <= "01101";  --K = 96
        
        when "1100001" => dprima_out(4 downto 0) <= "01110";  --K = 97
        when "1100010" => dprima_out(4 downto 0) <= "01110";  --K = 98
        when "1100011" => dprima_out(4 downto 0) <= "01110";  --K = 99
        
        when "1100100" => dprima_out(4 downto 0) <= "01111";  --K = 100                
        when "1100101" => dprima_out(4 downto 0) <= "01111";  --K = 101
        when "1100110" => dprima_out(4 downto 0) <= "01111";  --K = 102
        
        when "1100111" => dprima_out(4 downto 0) <= "10000";  --K = 103
        when "1101000" => dprima_out(4 downto 0) <= "10000";  --K = 104
        when "1101001" => dprima_out(4 downto 0) <= "10000";  --K = 105
        when "1101010" => dprima_out(4 downto 0) <= "10000";  --K = 106
        when others => dprima_out <= "0000000";
   end case;        
  end process;


 -- LUT generador de diezN_out
  process(K_index)
  begin
   case K_index is
        when "0110101" => diezN_out <= x"00000000000002386F26FC10000";  --K = 53
        
        when "0110110" => diezN_out <= x"00000000000016345785D8A0000";  --K = 54
        when "0110111" => diezN_out <= x"00000000000016345785D8A0000";  --K = 55
        when "0111000" => diezN_out <= x"00000000000016345785D8A0000";  --K = 56
        
        when "0111001" => diezN_out <= x"000000000000DE0B6B3A7640000";  --K = 57
        when "0111010" => diezN_out <= x"000000000000DE0B6B3A7640000";  --K = 58
        when "0111011" => diezN_out <= x"000000000000DE0B6B3A7640000";  --K = 59
        
        when "0111100" => diezN_out <= x"000000000008AC7230489E80000";  --K = 60
        when "0111101" => diezN_out <= x"000000000008AC7230489E80000";  --K = 61
        when "0111110" => diezN_out <= x"000000000008AC7230489E80000";  --K = 62
        when "0111111" => diezN_out <= x"000000000008AC7230489E80000";  --K = 63
        
        when "1000000" => diezN_out <= x"000000000056BC75E2D63100000";  --K = 64
        when "1000001" => diezN_out <= x"000000000056BC75E2D63100000";  --K = 65
        when "1000010" => diezN_out <= x"000000000056BC75E2D63100000";  --K = 66
        
        when "1000011" => diezN_out <= x"0000000003635C9ADC5DEA00000";  --K = 67
        when "1000100" => diezN_out <= x"0000000003635C9ADC5DEA00000";  --K = 68
        when "1000101" => diezN_out <= x"0000000003635C9ADC5DEA00000";  --K = 69
        
        when "1000110" => diezN_out <= x"0000000021E19E0C9BAB2400000";  --K = 70
        when "1000111" => diezN_out <= x"0000000021E19E0C9BAB2400000";  --K = 71
        when "1001000" => diezN_out <= x"0000000021E19E0C9BAB2400000";  --K = 72
        when "1001001" => diezN_out <= x"0000000021E19E0C9BAB2400000";  --K = 73
        
        when "1001010" => diezN_out <= x"0000000152D02C7E14AF6800000";  --K = 74
        when "1001011" => diezN_out <= x"0000000152D02C7E14AF6800000";  --K = 75
        when "1001100" => diezN_out <= x"0000000152D02C7E14AF6800000";  --K = 76
        
        when "1001101" => diezN_out <= x"0000000D3C21BCECCEDA1000000";  --K = 77
        when "1001110" => diezN_out <= x"0000000D3C21BCECCEDA1000000";  --K = 78
        when "1001111" => diezN_out <= x"0000000D3C21BCECCEDA1000000";  --K = 79
        
        when "1010000" => diezN_out <= x"00000084595161401484A000000";  --K = 80        
        when "1010001" => diezN_out <= x"00000084595161401484A000000";  --K = 81
        when "1010010" => diezN_out <= x"00000084595161401484A000000";  --K = 82
        when "1010011" => diezN_out <= x"00000084595161401484A000000";  --K = 83
        
        when "1010100" => diezN_out <= x"0000052B7D2DCC80CD2E4000000";  --K = 84
        when "1010101" => diezN_out <= x"0000052B7D2DCC80CD2E4000000";  --K = 85
        when "1010110" => diezN_out <= x"0000052B7D2DCC80CD2E4000000";  --K = 86
        
        when "1010111" => diezN_out <= x"000033B2E3C9FD0803CE8000000";  --K = 87
        when "1011000" => diezN_out <= x"000033B2E3C9FD0803CE8000000";  --K = 88
        when "1011001" => diezN_out <= x"000033B2E3C9FD0803CE8000000";  --K = 89
        
        when "1011010" => diezN_out <= x"000204FCE5E3E25026110000000";  --K = 90     
        when "1011011" => diezN_out <= x"000204FCE5E3E25026110000000";  --K = 91
        when "1011100" => diezN_out <= x"000204FCE5E3E25026110000000";  --K = 92
        when "1011101" => diezN_out <= x"000204FCE5E3E25026110000000";  --K = 93
        
        when "1011110" => diezN_out <= x"001431E0FAE6D7217CAA0000000";  --K = 94
        when "1011111" => diezN_out <= x"001431E0FAE6D7217CAA0000000";  --K = 95
        when "1100000" => diezN_out <= x"001431E0FAE6D7217CAA0000000";  --K = 96
        
        when "1100001" => diezN_out <= x"00C9F2C9CD04674EDEA40000000";  --K = 97
        when "1100010" => diezN_out <= x"00C9F2C9CD04674EDEA40000000";  --K = 98
        when "1100011" => diezN_out <= x"00C9F2C9CD04674EDEA40000000";  --K = 99
        
        when "1100100" => diezN_out <= x"07E37BE2022C0914B2680000000";  --K = 100                
        when "1100101" => diezN_out <= x"07E37BE2022C0914B2680000000";  --K = 101
        when "1100110" => diezN_out <= x"07E37BE2022C0914B2680000000";  --K = 102
        
        when "1100111" => diezN_out <= x"4EE2D6D415B85ACEF8100000000";  --K = 103
        when "1101000" => diezN_out <= x"4EE2D6D415B85ACEF8100000000";  --K = 104
        when "1101001" => diezN_out <= x"4EE2D6D415B85ACEF8100000000";  --K = 105
        when "1101010" => diezN_out <= x"4EE2D6D415B85ACEF8100000000";  --K = 106
        
        when others =>    diezN_out <= x"000000000000000000000000000";
   end case;        
  end process;
end architecture behavior;