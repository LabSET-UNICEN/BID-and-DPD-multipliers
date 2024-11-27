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
  port (K_index       : IN std_logic_vector (7 downto 0);		-- indice de las luts
	    dprima_out    : OUT std_logic_vector(7 downto 0);		-- valor de dprima
	    diezN_out     : OUT std_logic_vector(225 downto 0)		-- valor de 10**N	    
        );
end entity luts_unit;

architecture behavior of luts_unit is

begin  

            
 -- LUT generador de dprima_out
  process(K_index)
  begin
   case K_index is
        when "01110000" => dprima_out <= "00000000";  --K = 112

        when "01110001" => dprima_out <= "00000001";  --K = 113
        when "01110010" => dprima_out <= "00000001";  --K = 114
        when "01110011" => dprima_out <= "00000001";  --K = 115
        when "01110100" => dprima_out <= "00000001";  --K = 116

        when "01110101" => dprima_out <= "00000010";  --K = 117
        when "01110110" => dprima_out <= "00000010";  --K = 118
        when "01110111" => dprima_out <= "00000010";  --K = 119

        when "01111000" => dprima_out <= "00000011";  --K = 120
        when "01111001" => dprima_out <= "00000011";  --K = 121
        when "01111010" => dprima_out <= "00000011";  --K = 122

        when "01111011" => dprima_out <= "00000100";  --K = 123
        when "01111100" => dprima_out <= "00000100";  --K = 124
        when "01111101" => dprima_out <= "00000100";  --K = 125
        when "01111110" => dprima_out <= "00000100";  --K = 126

        when "01111111" => dprima_out <= "00000101";  --K = 127
        when "10000000" => dprima_out <= "00000101";  --K = 128
        when "10000001" => dprima_out <= "00000101";  --K = 129

        when "10000010" => dprima_out <= "00000110";  --K = 130
        when "10000011" => dprima_out <= "00000110";  --K = 131
        when "10000100" => dprima_out <= "00000110";  --K = 132

        when "10000101" => dprima_out <= "00000111";  --K = 133
        when "10000110" => dprima_out <= "00000111";  --K = 134
        when "10000111" => dprima_out <= "00000111";  --K = 135
        when "10001000" => dprima_out <= "00000111";  --K = 136

        when "10001001" => dprima_out <= "00001000";  --K = 137
        when "10001010" => dprima_out <= "00001000";  --K = 138
        when "10001011" => dprima_out <= "00001000";  --K = 139

        when "10001100" => dprima_out <= "00001001";  --K = 140
        when "10001101" => dprima_out <= "00001001";  --K = 141
        when "10001110" => dprima_out <= "00001001";  --K = 142

        when "10001111" => dprima_out <= "00001010";  --K = 143
        when "10010000" => dprima_out <= "00001010";  --K = 144
        when "10010001" => dprima_out <= "00001010";  --K = 145
        when "10010010" => dprima_out <= "00001010";  --K = 146

        when "10010011" => dprima_out <= "00001011";  --K = 147
        when "10010100" => dprima_out <= "00001011";  --K = 148
        when "10010101" => dprima_out <= "00001011";  --K = 149

        when "10010110" => dprima_out <= "00001100";  --K = 150
        when "10010111" => dprima_out <= "00001100";  --K = 151
        when "10011000" => dprima_out <= "00001100";  --K = 152

        when "10011001" => dprima_out <= "00001101";  --K = 153
        when "10011010" => dprima_out <= "00001101";  --K = 154
        when "10011011" => dprima_out <= "00001101";  --K = 155
        when "10011100" => dprima_out <= "00001101";  --K = 156

        when "10011101" => dprima_out <= "00001110";  --K = 157
        when "10011110" => dprima_out <= "00001110";  --K = 158
        when "10011111" => dprima_out <= "00001110";  --K = 159

        when "10100000" => dprima_out <= "00001111";  --K = 160
        when "10100001" => dprima_out <= "00001111";  --K = 161
        when "10100010" => dprima_out <= "00001111";  --K = 162

        when "10100011" => dprima_out <= "00010000";  --K = 163
        when "10100100" => dprima_out <= "00010000";  --K = 164
        when "10100101" => dprima_out <= "00010000";  --K = 165
        when "10100110" => dprima_out <= "00010000";  --K = 166

        when "10100111" => dprima_out <= "00010001";  --K = 167
        when "10101000" => dprima_out <= "00010001";  --K = 168
        when "10101001" => dprima_out <= "00010001";  --K = 169

        when "10101010" => dprima_out <= "00010010";  --K = 170
        when "10101011" => dprima_out <= "00010010";  --K = 171
        when "10101100" => dprima_out <= "00010010";  --K = 172

        when "10101101" => dprima_out <= "00010011";  --K = 173
        when "10101110" => dprima_out <= "00010011";  --K = 174
        when "10101111" => dprima_out <= "00010011";  --K = 175
        when "10110000" => dprima_out <= "00010011";  --K = 176

        when "10110001" => dprima_out <= "00010100";  --K = 177
        when "10110010" => dprima_out <= "00010100";  --K = 178
        when "10110011" => dprima_out <= "00010100";  --K = 179

        when "10110100" => dprima_out <= "00010101";  --K = 180
        when "10110101" => dprima_out <= "00010101";  --K = 181
        when "10110110" => dprima_out <= "00010101";  --K = 182

        when "10110111" => dprima_out <= "00010110";  --K = 183
        when "10111000" => dprima_out <= "00010110";  --K = 184
        when "10111001" => dprima_out <= "00010110";  --K = 185
        when "10111010" => dprima_out <= "00010110";  --K = 186

        when "10111011" => dprima_out <= "00010111";  --K = 187
        when "10111100" => dprima_out <= "00010111";  --K = 188
        when "10111101" => dprima_out <= "00010111";  --K = 189

        when "10111110" => dprima_out <= "00011000";  --K = 190
        when "10111111" => dprima_out <= "00011000";  --K = 191
        when "11000000" => dprima_out <= "00011000";  --K = 192

        when "11000001" => dprima_out <= "00011001";  --K = 193
        when "11000010" => dprima_out <= "00011001";  --K = 194
        when "11000011" => dprima_out <= "00011001";  --K = 195

        when "11000100" => dprima_out <= "00011010";  --K = 196
        when "11000101" => dprima_out <= "00011010";  --K = 197
        when "11000110" => dprima_out <= "00011010";  --K = 198
        when "11000111" => dprima_out <= "00011010";  --K = 199

        when "11001000" => dprima_out <= "00011011";  --K = 200
        when "11001001" => dprima_out <= "00011011";  --K = 201
        when "11001010" => dprima_out <= "00011011";  --K = 202

        when "11001011" => dprima_out <= "00011100";  --K = 203
        when "11001100" => dprima_out <= "00011100";  --K = 204
        when "11001101" => dprima_out <= "00011100";  --K = 205

        when "11001110" => dprima_out <= "00011101";  --K = 206
        when "11001111" => dprima_out <= "00011101";  --K = 207
        when "11010000" => dprima_out <= "00011101";  --K = 208
        when "11010001" => dprima_out <= "00011101";  --K = 209

        when "11010010" => dprima_out <= "00011110";  --K = 210
        when "11010011" => dprima_out <= "00011110";  --K = 211
        when "11010100" => dprima_out <= "00011110";  --K = 212

        when "11010101" => dprima_out <= "00011111";  --K = 213
        when "11010110" => dprima_out <= "00011111";  --K = 214
        when "11010111" => dprima_out <= "00011111";  --K = 215

        when "11011000" => dprima_out <= "00100000";  --K = 216
        when "11011001" => dprima_out <= "00100000";  --K = 217
        when "11011010" => dprima_out <= "00100000";  --K = 218
        when "11011011" => dprima_out <= "00100000";  --K = 219

        when "11011100" => dprima_out <= "00100001";  --K = 220
        when "11011101" => dprima_out <= "00100001";  --K = 221
        when "11011110" => dprima_out <= "00100001";  --K = 222

        when "11011111" => dprima_out <= "00100010";  --K = 223
        when "11100000" => dprima_out <= "00100010";  --K = 224
        
        when others => dprima_out <= "00000000";
   end case;        
  end process;


 -- LUT generador de diezN_out
  process(K_index)
  begin
   case K_index is
       
        when "01110000" => diezN_out <= "00" & x"0000000000000000000000000001ED09BEAD87C0378D8E6400000000";  --K = 112

        when "01110001" => diezN_out <= "00" & x"0000000000000000000000000013426172C74D822B878FE800000000";  --K = 113
        when "01110010" => diezN_out <= "00" & x"0000000000000000000000000013426172C74D822B878FE800000000";  --K = 114
        when "01110011" => diezN_out <= "00" & x"0000000000000000000000000013426172C74D822B878FE800000000";  --K = 115
        when "01110100" => diezN_out <= "00" & x"0000000000000000000000000013426172C74D822B878FE800000000";  --K = 116

        when "01110101" => diezN_out <= "00" & x"00000000000000000000000000C097CE7BC90715B34B9F1000000000";  --K = 117
        when "01110110" => diezN_out <= "00" & x"00000000000000000000000000C097CE7BC90715B34B9F1000000000";  --K = 118
        when "01110111" => diezN_out <= "00" & x"00000000000000000000000000C097CE7BC90715B34B9F1000000000";  --K = 119

        when "01111000" => diezN_out <= "00" & x"0000000000000000000000000785EE10D5DA46D900F436A000000000";  --K = 120
        when "01111001" => diezN_out <= "00" & x"0000000000000000000000000785EE10D5DA46D900F436A000000000";  --K = 121
        when "01111010" => diezN_out <= "00" & x"0000000000000000000000000785EE10D5DA46D900F436A000000000";  --K = 122

        when "01111011" => diezN_out <= "00" & x"0000000000000000000000004B3B4CA85A86C47A098A224000000000";  --K = 123
        when "01111100" => diezN_out <= "00" & x"0000000000000000000000004B3B4CA85A86C47A098A224000000000";  --K = 124
        when "01111101" => diezN_out <= "00" & x"0000000000000000000000004B3B4CA85A86C47A098A224000000000";  --K = 125
        when "01111110" => diezN_out <= "00" & x"0000000000000000000000004B3B4CA85A86C47A098A224000000000";  --K = 126

        when "01111111" => diezN_out <= "00" & x"000000000000000000000002F050FE938943ACC45F65568000000000";  --K = 127
        when "10000000" => diezN_out <= "00" & x"000000000000000000000002F050FE938943ACC45F65568000000000";  --K = 128
        when "10000001" => diezN_out <= "00" & x"000000000000000000000002F050FE938943ACC45F65568000000000";  --K = 129

        when "10000010" => diezN_out <= "00" & x"00000000000000000000001D6329F1C35CA4BFABB9F5610000000000";  --K = 130
        when "10000011" => diezN_out <= "00" & x"00000000000000000000001D6329F1C35CA4BFABB9F5610000000000";  --K = 131
        when "10000100" => diezN_out <= "00" & x"00000000000000000000001D6329F1C35CA4BFABB9F5610000000000";  --K = 132

        when "10000101" => diezN_out <= "00" & x"000000000000000000000125DFA371A19E6F7CB54395CA0000000000";  --K = 133
        when "10000110" => diezN_out <= "00" & x"000000000000000000000125DFA371A19E6F7CB54395CA0000000000";  --K = 134
        when "10000111" => diezN_out <= "00" & x"000000000000000000000125DFA371A19E6F7CB54395CA0000000000";  --K = 135
        when "10001000" => diezN_out <= "00" & x"000000000000000000000125DFA371A19E6F7CB54395CA0000000000";  --K = 136

        when "10001001" => diezN_out <= "00" & x"000000000000000000000B7ABC627050305ADF14A3D9E40000000000";  --K = 137
        when "10001010" => diezN_out <= "00" & x"000000000000000000000B7ABC627050305ADF14A3D9E40000000000";  --K = 138
        when "10001011" => diezN_out <= "00" & x"000000000000000000000B7ABC627050305ADF14A3D9E40000000000";  --K = 139

        when "10001100" => diezN_out <= "00" & x"0000000000000000000072CB5BD86321E38CB6CE6682E80000000000";  --K = 140
        when "10001101" => diezN_out <= "00" & x"0000000000000000000072CB5BD86321E38CB6CE6682E80000000000";  --K = 141
        when "10001110" => diezN_out <= "00" & x"0000000000000000000072CB5BD86321E38CB6CE6682E80000000000";  --K = 142

        when "10001111" => diezN_out <= "00" & x"000000000000000000047BF19673DF52E37F2410011D100000000000";  --K = 143
        when "10010000" => diezN_out <= "00" & x"000000000000000000047BF19673DF52E37F2410011D100000000000";  --K = 144
        when "10010001" => diezN_out <= "00" & x"000000000000000000047BF19673DF52E37F2410011D100000000000";  --K = 145
        when "10010010" => diezN_out <= "00" & x"000000000000000000047BF19673DF52E37F2410011D100000000000";  --K = 146

        when "10010011" => diezN_out <= "00" & x"0000000000000000002CD76FE086B93CE2F768A00B22A00000000000";  --K = 147
        when "10010100" => diezN_out <= "00" & x"0000000000000000002CD76FE086B93CE2F768A00B22A00000000000";  --K = 148
        when "10010101" => diezN_out <= "00" & x"0000000000000000002CD76FE086B93CE2F768A00B22A00000000000";  --K = 149

        when "10010110" => diezN_out <= "00" & x"000000000000000001C06A5EC5433C60DDAA16406F5A400000000000";  --K = 150
        when "10010111" => diezN_out <= "00" & x"000000000000000001C06A5EC5433C60DDAA16406F5A400000000000";  --K = 151
        when "10011000" => diezN_out <= "00" & x"000000000000000001C06A5EC5433C60DDAA16406F5A400000000000";  --K = 152

        when "10011001" => diezN_out <= "00" & x"0000000000000000118427B3B4A05BC8A8A4DE845986800000000000";  --K = 153
        when "10011010" => diezN_out <= "00" & x"0000000000000000118427B3B4A05BC8A8A4DE845986800000000000";  --K = 154
        when "10011011" => diezN_out <= "00" & x"0000000000000000118427B3B4A05BC8A8A4DE845986800000000000";  --K = 155
        when "10011100" => diezN_out <= "00" & x"0000000000000000118427B3B4A05BC8A8A4DE845986800000000000";  --K = 156

        when "10011101" => diezN_out <= "00" & x"0000000000000000AF298D050E4395D69670B12B7F41000000000000";  --K = 157
        when "10011110" => diezN_out <= "00" & x"0000000000000000AF298D050E4395D69670B12B7F41000000000000";  --K = 158
        when "10011111" => diezN_out <= "00" & x"0000000000000000AF298D050E4395D69670B12B7F41000000000000";  --K = 159

        when "10100000" => diezN_out <= "00" & x"0000000000000006D79F82328EA3DA61E066EBB2F88A000000000000";  --K = 160
        when "10100001" => diezN_out <= "00" & x"0000000000000006D79F82328EA3DA61E066EBB2F88A000000000000";  --K = 161
        when "10100010" => diezN_out <= "00" & x"0000000000000006D79F82328EA3DA61E066EBB2F88A000000000000";  --K = 162

        when "10100011" => diezN_out <= "00" & x"00000000000000446C3B15F9926687D2C40534FDB564000000000000";  --K = 163
        when "10100100" => diezN_out <= "00" & x"00000000000000446C3B15F9926687D2C40534FDB564000000000000";  --K = 164
        when "10100101" => diezN_out <= "00" & x"00000000000000446C3B15F9926687D2C40534FDB564000000000000";  --K = 165
        when "10100110" => diezN_out <= "00" & x"00000000000000446C3B15F9926687D2C40534FDB564000000000000";  --K = 166

        when "10100111" => diezN_out <= "00" & x"00000000000002AC3A4EDBBFB8014E3BA83411E915E8000000000000";  --K = 167
        when "10101000" => diezN_out <= "00" & x"00000000000002AC3A4EDBBFB8014E3BA83411E915E8000000000000";  --K = 168
        when "10101001" => diezN_out <= "00" & x"00000000000002AC3A4EDBBFB8014E3BA83411E915E8000000000000";  --K = 169

        when "10101010" => diezN_out <= "00" & x"0000000000001ABA4714957D300D0E549208B31ADB10000000000000";  --K = 170
        when "10101011" => diezN_out <= "00" & x"0000000000001ABA4714957D300D0E549208B31ADB10000000000000";  --K = 171
        when "10101100" => diezN_out <= "00" & x"0000000000001ABA4714957D300D0E549208B31ADB10000000000000";  --K = 172

        when "10101101" => diezN_out <= "00" & x"0000000000010B46C6CDD6E3E0828F4DB456FF0C8EA0000000000000";  --K = 173
        when "10101110" => diezN_out <= "00" & x"0000000000010B46C6CDD6E3E0828F4DB456FF0C8EA0000000000000";  --K = 174
        when "10101111" => diezN_out <= "00" & x"0000000000010B46C6CDD6E3E0828F4DB456FF0C8EA0000000000000";  --K = 175
        when "10110000" => diezN_out <= "00" & x"0000000000010B46C6CDD6E3E0828F4DB456FF0C8EA0000000000000";  --K = 176

        when "10110001" => diezN_out <= "00" & x"00000000000A70C3C40A64E6C51999090B65F67D9240000000000000";  --K = 177
        when "10110010" => diezN_out <= "00" & x"00000000000A70C3C40A64E6C51999090B65F67D9240000000000000";  --K = 178
        when "10110011" => diezN_out <= "00" & x"00000000000A70C3C40A64E6C51999090B65F67D9240000000000000";  --K = 179

        when "10110100" => diezN_out <= "00" & x"00000000006867A5A867F103B2FFFA5A71FBA0E7B680000000000000";  --K = 180
        when "10110101" => diezN_out <= "00" & x"00000000006867A5A867F103B2FFFA5A71FBA0E7B680000000000000";  --K = 181
        when "10110110" => diezN_out <= "00" & x"00000000006867A5A867F103B2FFFA5A71FBA0E7B680000000000000";  --K = 182

        when "10110111" => diezN_out <= "00" & x"0000000004140C78940F6A24FDFFC78873D4490D2100000000000000";  --K = 183
        when "10111000" => diezN_out <= "00" & x"0000000004140C78940F6A24FDFFC78873D4490D2100000000000000";  --K = 184
        when "10111001" => diezN_out <= "00" & x"0000000004140C78940F6A24FDFFC78873D4490D2100000000000000";  --K = 185
        when "10111010" => diezN_out <= "00" & x"0000000004140C78940F6A24FDFFC78873D4490D2100000000000000";  --K = 186

        when "10111011" => diezN_out <= "00" & x"0000000028C87CB5C89A2571EBFDCB54864ADA834A00000000000000";  --K = 187
        when "10111100" => diezN_out <= "00" & x"0000000028C87CB5C89A2571EBFDCB54864ADA834A00000000000000";  --K = 188
        when "10111101" => diezN_out <= "00" & x"0000000028C87CB5C89A2571EBFDCB54864ADA834A00000000000000";  --K = 189

        when "10111110" => diezN_out <= "00" & x"0000000197D4DF19D605767337E9F14D3EEC8920E400000000000000";  --K = 190
        when "10111111" => diezN_out <= "00" & x"0000000197D4DF19D605767337E9F14D3EEC8920E400000000000000";  --K = 191
        when "11000000" => diezN_out <= "00" & x"0000000197D4DF19D605767337E9F14D3EEC8920E400000000000000";  --K = 192

        when "11000001" => diezN_out <= "00" & x"0000000FEE50B7025C36A0802F236D04753D5B48E800000000000000";  --K = 193
        when "11000010" => diezN_out <= "00" & x"0000000FEE50B7025C36A0802F236D04753D5B48E800000000000000";  --K = 194
        when "11000011" => diezN_out <= "00" & x"0000000FEE50B7025C36A0802F236D04753D5B48E800000000000000";  --K = 195

        when "11000100" => diezN_out <= "00" & x"0000009F4F2726179A224501D762422C946590D91000000000000000";  --K = 196
        when "11000101" => diezN_out <= "00" & x"0000009F4F2726179A224501D762422C946590D91000000000000000";  --K = 197
        when "11000110" => diezN_out <= "00" & x"0000009F4F2726179A224501D762422C946590D91000000000000000";  --K = 198
        when "11000111" => diezN_out <= "00" & x"0000009F4F2726179A224501D762422C946590D91000000000000000";  --K = 199

        when "11001000" => diezN_out <= "00" & x"0000063917877CEC0556B21269D695BDCBF7A87AA000000000000000";  --K = 200
        when "11001001" => diezN_out <= "00" & x"0000063917877CEC0556B21269D695BDCBF7A87AA000000000000000";  --K = 201
        when "11001010" => diezN_out <= "00" & x"0000063917877CEC0556B21269D695BDCBF7A87AA000000000000000";  --K = 202

        when "11001011" => diezN_out <= "00" & x"00003E3AEB4AE1383562F4B82261D969F7AC94CA4000000000000000";  --K = 203
        when "11001100" => diezN_out <= "00" & x"00003E3AEB4AE1383562F4B82261D969F7AC94CA4000000000000000";  --K = 204
        when "11001101" => diezN_out <= "00" & x"00003E3AEB4AE1383562F4B82261D969F7AC94CA4000000000000000";  --K = 205

        when "11001110" => diezN_out <= "00" & x"00026E4D30ECCC3215DD8F3157D27E23ACBDCFE68000000000000000";  --K = 206
        when "11001111" => diezN_out <= "00" & x"00026E4D30ECCC3215DD8F3157D27E23ACBDCFE68000000000000000";  --K = 207
        when "11010000" => diezN_out <= "00" & x"00026E4D30ECCC3215DD8F3157D27E23ACBDCFE68000000000000000";  --K = 208
        when "11010001" => diezN_out <= "00" & x"00026E4D30ECCC3215DD8F3157D27E23ACBDCFE68000000000000000";  --K = 209

        when "11010010" => diezN_out <= "00" & x"00184F03E93FF9F4DAA797ED6E38ED64BF6A1F010000000000000000";  --K = 210
        when "11010011" => diezN_out <= "00" & x"00184F03E93FF9F4DAA797ED6E38ED64BF6A1F010000000000000000";  --K = 211
        when "11010100" => diezN_out <= "00" & x"00184F03E93FF9F4DAA797ED6E38ED64BF6A1F010000000000000000";  --K = 212

        when "11010101" => diezN_out <= "00" & x"00F316271C7FC3908A8BEF464E3945EF7A25360A0000000000000000";  --K = 213
        when "11010110" => diezN_out <= "00" & x"00F316271C7FC3908A8BEF464E3945EF7A25360A0000000000000000";  --K = 214
        when "11010111" => diezN_out <= "00" & x"00F316271C7FC3908A8BEF464E3945EF7A25360A0000000000000000";  --K = 215

        when "11011000" => diezN_out <= "00" & x"097EDD871CFDA3A5697758BF0E3CBB5AC5741C640000000000000000";  --K = 216
        when "11011001" => diezN_out <= "00" & x"097EDD871CFDA3A5697758BF0E3CBB5AC5741C640000000000000000";  --K = 217
        when "11011010" => diezN_out <= "00" & x"097EDD871CFDA3A5697758BF0E3CBB5AC5741C640000000000000000";  --K = 218
        when "11011011" => diezN_out <= "00" & x"097EDD871CFDA3A5697758BF0E3CBB5AC5741C640000000000000000";  --K = 219

        when "11011100" => diezN_out <= "00" & x"5EF4A74721E864761EA977768E5F518BB6891BE80000000000000000";  --K = 220
        when "11011101" => diezN_out <= "00" & x"5EF4A74721E864761EA977768E5F518BB6891BE80000000000000000";  --K = 221
        when "11011110" => diezN_out <= "00" & x"5EF4A74721E864761EA977768E5F518BB6891BE80000000000000000";  --K = 222

        when "11011111" => diezN_out <= "11" & x"B58E88C75313EC9D329EAAA18FB92F75215B17100000000000000000";  --K = 223
        when "11100000" => diezN_out <= "11" & x"B58E88C75313EC9D329EAAA18FB92F75215B17100000000000000000";  --K = 224
        
        when others =>     diezN_out <= "11" & x"00000000000000000000000000000000000000000000000000000000";
   end case;        
  end process;
end architecture behavior;