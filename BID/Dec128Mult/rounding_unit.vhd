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
  port (Ci            : IN std_logic_vector (225 downto 0);		-- mantisa de entrada
        d_6_0         : IN std_logic_vector (7 downto 0);		-- digitos decimales a redondear
        Si            : IN std_logic;					        -- signo de la mantisa
	    rounding_mode : IN std_logic_vector(2 downto 0);		-- modo de redondeo
	    Co            : OUT std_logic_vector(112 downto 0)		-- resultado
        );
end entity rounding_unit;

architecture behavior of rounding_unit is

component data_shifter
  port(P_in       : in  std_logic_vector(226 downto 0);  	--input
       d_4_0      : in  std_logic_vector(5 downto 0);   	-- position
       Ctmp       : out std_logic_vector(112 downto 0);  	--output
	   r_asterisk : out std_logic;							-- bit r*
	   s_asterisk : out std_logic);							-- bit s* sticky bit
end component;

-- d_10_0 es la cantidad de digitos decimales a desplazar a la derecha
-- Se indexa una LUT con d_10_0 para calcular la cantidad de bits, desp, a desplazar
  signal W_P : std_logic_vector(339 downto 0);
  signal W_Ctmp : std_logic_vector(112 downto 0);
  signal W_r_asterisk : std_logic;
  signal W_s_asterisk : std_logic;
  signal W_Wc : std_logic_vector(113 downto 0);
  signal bypass_mux1_ctrl : std_logic;
  signal bypass_mux2_ctrl : std_logic;
  signal dmay16_mux1_ctrl : std_logic;
  signal result_mux_ctrl : std_logic;
  signal W_mux1_out : std_logic_vector(112 downto 0);
  signal W_mux2_out : std_logic_vector(112 downto 0);
  signal W_mux16 : std_logic_vector(112 downto 0);
  
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
   case d_6_0(5 downto 0) is
        when "000001" => W_Wc <= "00"&x"0066666666666667000000000000";
        when "000010" => W_Wc <= "00"&x"0051eb851eb851ec000000000000";
        when "000011" => W_Wc <= "00"&x"004189374bc6a7f0000000000000";
        when "000100" => W_Wc <= "00"&x"0068db8bac710cb3000000000000";
        when "000101" => W_Wc <= "00"&x"0053e2d6238da3c3000000000000";
        when "000110" => W_Wc <= "00"&x"00431bde82d7b635000000000000";
        when "000111" => W_Wc <= "00"&x"006b5fca6af2bd22000000000000";
        when "001000" => W_Wc <= "00"&x"0055e63b88c230e8000000000000";
        when "001001" => W_Wc <= "00"&x"0044b82fa09b5a53000000000000";
        when "001010" => W_Wc <= "00"&x"006df37f675ef6eb000000000000";
        when "001011" => W_Wc <= "00"&x"0057f5ff85e59256000000000000";
        when "001100" => W_Wc <= "00"&x"00465e6604b7a845000000000000";
        when "001101" => W_Wc <= "00"&x"00709709a125da08000000000000";
        when "001110" => W_Wc <= "00"&x"005a126e1a84ae6d000000000000";
        when "001111" => W_Wc <= "00"&x"00480ebe7b9d5857000000000000";
        when "010000" => W_Wc <= "00"&x"000734ACA6000000000000000000";
        when "010001" => W_Wc <= "00"&x"0000B877AA000000000000000000";
        when "010010" => W_Wc <= "00"&x"000012725E000000000000000000";        
        when "010011" => W_Wc <= "00"&x"00001D83D0000000000000000000";        
        when "010100" => W_Wc <= "00"&x"000002F390000000000000000000";        
        when "010101" => W_Wc <= "00"&x"0000010000000000000000000000";        
        when "010110" => W_Wc <= "00"&x"0000001000000000000000000000";        
        when "010111" => W_Wc <= "00"&x"0000000100000000000000000000";        
        when "011000" => W_Wc <= "00"&x"0000000010000000000000000000";       
        when "011001" => W_Wc <= "00"&x"0000000001000000000000000000";
        when "011010" => W_Wc <= "00"&x"0000000000100000000000000000";        
        when "011011" => W_Wc <= "00"&x"0000000000010000000000000000";        
        when "011100" => W_Wc <= "00"&x"0000000000001000000000000000";        
        when "011101" => W_Wc <= "00"&x"0000000000000100000000000000";        
        when "011110" => W_Wc <= "00"&x"0000000000000010000000000000";        
        when "011111" => W_Wc <= "00"&x"0000000000000001000000000000";        
        when "100000" => W_Wc <= "00"&x"0000000000000000100000000000";        
        when "100001" => W_Wc <= "00"&x"0000000000000000010000000000";        
        when  others  => W_Wc  <= "00"&x"0000000000000000000000000000";
   end case;        
  end process;

-- multiplicacion de mantisa por 1/Wd  
  W_P <= Ci&"00"&x"0000000000000000000000000000" when d_6_0(5 downto 0) ="000000" else
         Ci * W_Wc ;
 
-- redondeo y generacion de r* y s* 
 extraccion: data_shifter 
 port map(
       P_in => W_P(338 downto 112),
       d_4_0 => d_6_0(5 downto 0),
       Ctmp => W_Ctmp,
	   r_asterisk => W_r_asterisk,
	   s_asterisk => W_s_asterisk
 );
 
 -- MUX de resultado
 Co <= (W_Ctmp + 1) when result_mux_ctrl = '1' else
            W_Ctmp;
  
end architecture behavior;