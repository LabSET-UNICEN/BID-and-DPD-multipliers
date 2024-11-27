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

entity rounding_unit is
  port (Ci            : IN std_logic_vector (107 downto 0);		-- mantisa de entrada
        d_6_0         : IN std_logic_vector (6 downto 0);		-- digitos decimales a redondear
        Si            : IN std_logic;					        -- signo de la mantisa
	    rounding_mode : IN std_logic_vector(2 downto 0);		-- modo de redondeo
	    Co            : OUT std_logic_vector(53 downto 0)		-- resultado
        );
end entity rounding_unit;

architecture behavior of rounding_unit is

component data_shifter
  port(P_in       : in  std_logic_vector(108 downto 0);  	--input
       d_4_0      : in  std_logic_vector(4 downto 0);   	-- position
       Ctmp       : out std_logic_vector(53 downto 0);  	--output
	   r_asterisk : out std_logic;							-- bit r*
	   s_asterisk : out std_logic);							-- bit s* sticky bit
end component;

-- d_10_0 es la cantidad de digitos decimales a desplazar a la derecha
-- Se indexa una LUT con d_10_0 para calcular la cantidad de bits, desp, a desplazar
  signal W_P : std_logic_vector(162 downto 0);
  signal W_Ctmp : std_logic_vector(53 downto 0);
  signal W_r_asterisk : std_logic;
  signal W_s_asterisk : std_logic;
  signal W_Wc : std_logic_vector(54 downto 0);
  signal bypass_mux1_ctrl : std_logic;
  signal bypass_mux2_ctrl : std_logic;
  signal dmay16_mux1_ctrl : std_logic;
  signal result_mux_ctrl : std_logic;
  signal W_mux1_out : std_logic_vector(53 downto 0);
  signal W_mux2_out : std_logic_vector(53 downto 0);
  signal W_mux16 : std_logic_vector(53 downto 0);
  
begin  
  
 process(W_r_asterisk, W_s_asterisk, W_Ctmp(0), bypass_mux2_ctrl, Si, rounding_mode)
 begin
    if rounding_mode(2) = '1' then  -- modos que incrementan Ctmp si se dan las otras condiciones
        if ((W_r_asterisk = '1') and ((W_s_asterisk = '1') or (W_Ctmp(0) = '1'))) or   --RTE
           ((Si = '0') and (W_s_asterisk = '1' or W_r_asterisk = '1')) or                   --RTP
           ((Si = '1') and (W_s_asterisk = '1' or W_r_asterisk = '1')) or                   --RTN
           (W_r_asterisk = '1') then                                                        --RTA
               result_mux_ctrl <= '1';
        else                                                                                --RTZ
               result_mux_ctrl <= '0';
        end if;
    else                                                                                    --RTZ
        result_mux_ctrl <= '0';                     
    end if;
 end process;
 
                       
 -- LUT generador de Wc = 1/Wd
  process(d_6_0)
  begin
   case d_6_0(4 downto 0) is
        when "00001" => W_Wc <= "110" & x"6666666666667";
        when "00010" => W_Wc <= "101" & x"1eb851eb851ec";
        when "00011" => W_Wc <= "100" & x"189374bc6a7f0";
        when "00100" => W_Wc <= "110" & x"8db8bac710cb3";
        when "00101" => W_Wc <= "101" & x"3e2d6238da3c3";
        when "00110" => W_Wc <= "100" & x"31bde82d7b635";
        when "00111" => W_Wc <= "110" & x"b5fca6af2bd22";
        when "01000" => W_Wc <= "101" & x"5e63b88c230e8";
        when "01001" => W_Wc <= "100" & x"4b82fa09b5a53";
        when "01010" => W_Wc <= "110" & x"df37f675ef6eb";
        when "01011" => W_Wc <= "101" & x"7f5ff85e59256";
        when "01100" => W_Wc <= "100" & x"65e6604b7a845";
        when "01101" => W_Wc <= "111" & x"09709a125da08";
        when "01110" => W_Wc <= "101" & x"a126e1a84ae6d";
        when "01111" => W_Wc <= "100" & x"80ebe7b9d5857";
        when "10000" => W_Wc <= "111" & x"34aca5f6226f1";
        when others  => W_Wc <= "000" & x"0000000000000";
   end case;        
  end process;

-- multiplicacion de mantisa por 1/Wd  
  W_P <= Ci&"000"&x"0000000000000" when d_6_0(4 downto 0) ="00000" else
         Ci * W_Wc ;
 
-- redondeo y generacion de r* y s* 
 extraccion: data_shifter 
 port map(
       P_in => W_P(162 downto 54),
       d_4_0 => d_6_0(4 downto 0),
       Ctmp => W_Ctmp,
	   r_asterisk => W_r_asterisk,
	   s_asterisk => W_s_asterisk
 );
 
 -- MUX de resultado
 Co <= (W_Ctmp + 1) when result_mux_ctrl = '1' else
            W_Ctmp;
  
end architecture behavior;