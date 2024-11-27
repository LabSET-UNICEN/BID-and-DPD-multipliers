-- Multiplicador DFP BID con redondeo
-- Implementa el multiplicador DECIMAL32 de forma combinacional 
-- Usa multiplicadores de 24 bits

--   ENTRADAS
--       Ac mantisa del operando de entrada A
--       Bc mantisa del operando de entrada B
--       Asign signo del operando de entrada A
--       Bsign signo del operando de entrada B
--       Ae exponente del operando de entrada A
--       Be exponente del operando de entrada B

--   SALIDAS
--	     Zc mantisa redondeada de salida
--       Zsign signo de salida
--       Ze exponente de salida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BID_multiplier is
 port (B_Ac            : IN std_logic_vector (23 downto 0);		-- mantisa de entrada A
       B_Asign		   : IN std_logic;							-- signo de entrada A
       B_Ae		       : IN std_logic_vector (7 downto 0);		-- exponente de entrada A

       B_Bc            : IN std_logic_vector (23 downto 0);		-- mantisa de entrada B
       B_Bsign		   : IN std_logic;							-- signo de entrada B
       B_Be            : IN std_logic_vector (7 downto 0);		-- exponente de entrada B

       B_round_mode    : IN std_logic_vector(2 downto 0);       -- modo de redondeo
       
       rst             : IN std_logic;                          -- reset de registros
       clk             : IN std_logic;                          -- clock
	   
       B_Zc            : OUT std_logic_vector (23 downto 0);	-- mantisa de salida
       B_Zc_sign	   : OUT std_logic;							-- signo de salida
       B_Zc_e		   : OUT std_logic_vector (7 downto 0)		-- exponente de salida
        );
end entity BID_multiplier;

architecture behavior of BID_multiplier is

-- unidad de redondeo generica
   COMPONENT rounding_unit
   PORT(
       Ci            : IN std_logic_vector (47 downto 0);		-- mantisa de entrada
       d_6_0         : IN std_logic_vector (2 downto 0);		-- digitos decimales a redondear
       Si            : IN std_logic;						    -- signo de la mantisa
	   rounding_mode : IN std_logic_vector(2 downto 0);			-- modo de redondeo
	   Co            : OUT std_logic_vector(23 downto 0));		-- resultado
   END COMPONENT;	

  -- Posición del primer 1 a izquierda
   COMPONENT digits_counter
   PORT ( 
       A  : in  std_logic_vector (23 downto 0);
       Qa : out std_logic_vector (6 downto 0));
   END COMPONENT;
   
   COMPONENT luts_unit
  PORT (
       K_index       : IN std_logic_vector (6 downto 0);		-- indice de las luts
	   dprima_out    : OUT std_logic_vector(6 downto 0);		-- valor de dprima
	   diezN_out     : OUT std_logic_vector(47 downto 0));		-- valor de 10**N
END COMPONENT;
   

-- señales de almacenamiento de AN y BN
       SIGNAL Ac                        : std_logic_vector(23 downto 0);
       SIGNAL Bc                        : std_logic_vector(23 downto 0);
       SIGNAL Ae                        : std_logic_vector(7 downto 0);
       SIGNAL Be                        : std_logic_vector(7 downto 0);
       SIGNAL Asign                     : std_logic;
       SIGNAL Bsign                     : std_logic;
       
       SIGNAL Zc                        : std_logic_vector(23 downto 0);
       SIGNAL Zsign                     : std_logic;
       SIGNAL Ze	  	                : std_logic_vector (7 downto 0);
       
       SIGNAL flag_mayor                 : std_logic;
       SIGNAL flag_menor                 : std_logic;

       SIGNAL round_mode                 : std_logic_vector (2 downto 0);
       SIGNAL IPc                        : std_logic_vector (47 downto 0);
       SIGNAL IPe                        : std_logic_vector(7 downto 0);
       SIGNAL Alop                       : std_logic_vector(6 downto 0);
       SIGNAL Blop                       : std_logic_vector(6 downto 0);
       SIGNAL d                          : std_logic_vector(6 downto 0);
       SIGNAL k                          : std_logic_vector(6 downto 0);
       SIGNAL IPe_plus_d                 : std_logic_vector(7 downto 0);
       SIGNAL round_needed               : std_logic;
       SIGNAL IPe_plus_d1                : std_logic_vector(7 downto 0);
       SIGNAL dprima                     : std_logic_vector(6 downto 0);
       SIGNAL diez_a_la_N                : std_logic_vector(47 downto 0);
       SIGNAL IPc_GT_10N                 : std_logic;
       SIGNAL IPe_plus                   : std_logic_vector(7 downto 0);
       SIGNAL temp                       : std_logic_vector(23 downto 0);
       SIGNAL Zc_tmp                     : std_logic_vector(23 downto 0);
       SIGNAL Zc_tmp_eq_1016             : std_logic;
       


begin  
-- registro de entradas y salidas
-- ======================
   PAc: process (clk, rst)
   begin
      if rst='1' then
         Ac <= x"000000";
      elsif (clk'event and clk='1') then
         Ac <= B_Ac;
      end if;   
   end process;
   
   PAsign: process (clk, rst)
   begin
      if rst='1' then
         Asign <= '0';
      elsif (clk'event and clk='1') then
         Asign <= B_Asign;
      end if;   
   end process;
   
   PAe: process (clk, rst)
   begin
      if rst='1' then
         Ae <= "00000000";
      elsif (clk'event and clk='1') then
         Ae <= B_Ae;
      end if;   
   end process;
   
   PBc: process (clk, rst)
   begin
      if rst='1' then
         Bc <= x"000000";
      elsif (clk'event and clk='1') then
         Bc <= B_Bc;
      end if;   
   end process;
   
   PBsign: process (clk, rst)
   begin
      if rst='1' then
         Bsign <= '0';
      elsif (clk'event and clk='1') then
         Bsign <= B_Bsign;
      end if;   
   end process;
   
   PBexp: process (clk, rst)
   begin
      if rst='1' then
         Be <= "00000000";
      elsif (clk'event and clk='1') then
         Be <= B_Be;
      end if;   
   end process;
   
   PZc: process (clk, rst)
   begin
      if rst='1' then
         B_Zc <= x"000000";
      elsif (clk'event and clk='1') then
         B_Zc <= Zc;
      end if;   
   end process;
   
   PZsign: process (clk, rst)
   begin
      if rst='1' then
         B_Zc_sign <= '0';
      elsif (clk'event and clk='1') then
         B_Zc_sign <= Zsign;
      end if;   
   end process;
   
   PZe: process (clk, rst)
   begin
      if rst='1' then
         B_Zc_e <= "00000000";
      elsif (clk'event and clk='1') then
         B_Zc_e <= Ze;
      end if;   
   end process;
   

   mode: process (clk, rst)
   begin
      if rst='1' then
         round_mode <= "000";
      elsif (clk'event and clk='1') then
         round_mode <= B_round_mode;
      end if;   
   end process;
-- ======================



-- calculo de signo del resultado
-- ======================
   Zsign <= Asign xor Bsign;
-- ======================

-- calculo de IPc = Ac * Bc
-- ======================
   IPc <= Ac * Bc;
-- ======================

-- calculo de IPe = Ae + Be - bias
-- ======================
   IPe <= Ae + Be - "10000000";
-- ======================


-- calculo de round_needed = IPC > 10**7
-- ======================
   round_needed <= '1' when IPc > x"0989680" else '0';
-- ======================


--Calculo de la posicion del primer uno a izquierda de Ac 
-- ======================
   contadorA: digits_counter port map(
             A  => Ac,
             Qa => Alop             
   );
-- ======================   

--Calculo de la posicion del primer uno a izquierda de Bc 
-- ======================
   contadorB: digits_counter port map(
             A  => Bc,
             Qa => Blop             
   );
-- ======================   

--Calculo de K 
-- ======================
  K <= Alop + Blop;
-- ======================   

--acceso a las luts de dprima y 10**N 
-- ======================
   luts: luts_unit port map(
             K_index => K,
             dprima_out => dprima,
             diezN_out => diez_a_la_N             
   );
-- ======================   

--Calculo de IPe_plus_d = IPe + d 
-- ======================
IPe_plus_d <= IPe + ("0"&d);
-- ======================   

--Calculo de IPe_plus_d1 = IPe_plus_d + 1 
-- ======================
IPe_plus_d1 <= IPe_plus_d + "00000001";
-- ======================   

-- calculo de IPc_GT_10N = IPC > 10**N
-- ======================
   IPc_GT_10N <= '1' when IPc > diez_a_la_N else '0';
-- ======================

--Calculo de d = IPe + d 
-- ======================
   d <= dprima + "0000001" when IPc_GT_10N = '1' else dprima;
-- ======================   

-- redondeo de IPc en d digitos
-- ======================   
   Round_IPc: rounding_unit port map(
            Ci => IPc,
            d_6_0 => d(2 downto 0),
            Si => Zsign, 
			rounding_mode => B_round_mode,
			Co => Zc_tmp
   );
-- ======================

-- calculo de Zc_tmp_EQ_1016 = Zc_tmp == 10**8
-- ======================
   Zc_tmp_EQ_1016 <= '1' when Zc_tmp = x"0989680" else '0';
-- ======================

-- MUX de generacion de IPe_plus
IPe_plus <= IPe_plus_d1 when Zc_tmp_EQ_1016='1' else IPe_plus_d;

-- MUX de generacion de temp
temp <= x"989680" when Zc_tmp_EQ_1016='1' else Zc_tmp;


-- MUX de generacion de Ze
Ze <= IPe_plus when round_needed='1' else IPe;


-- MUX de generacion de Zc
Zc <= temp when round_needed='1' else IPc(23 downto 0);

end architecture behavior;
