-- Este core efect�a la multiplicaci�n con operandos IEEE 2008
-- Versi�n de multiplicaci�n que se�ala overflow y underflow



-- Trabaja con operandos de entrada <ain> y <bin> codificados y 
-- resultado <o> tambien codificado en DPD 
-- manejo de NAN e inf



-- Este m�dulo trabaja con tres formatos
-- decimal32: Nexp=8 y P=7 
-- decimal64: Nexp=10 y P=16 
-- decimal128:  Nexp=14 y P=34 

-- Donde 
--  N representa la cantidad de bits de los operandos
--  NExp la cantidad de bits que posee el exponente
--  P la precisi�n deimal de la mantisa
-- Tanto NExp como P son datos que usan los compontes de mas bajo nivel

-- Donde 
-- TypeRound es la t�cnica de redondeo

-- Para TypeRound cuando es
-- 0 => RoundTowardPositive
-- 1 => RoundTowardNegative
-- 2 => RoundTowardZero
-- 3 => RoundTiesToAway
-- 4 => RoundTiesToEven

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.my_package.all;

library UNISIM;
use UNISIM.VComponents.all;

entity MultDFP_DPD is
	 generic (TypeRound: integer:= 4;  N:integer:=64; NExp: integer:= 10;  P: integer:=16);
				
    Port ( ain, bin: in std_logic_vector(N-1 downto 0);
            overflow, underflow: out std_logic;
          o: out std_logic_vector(N-1 downto 0));
end MultDFP_DPD;


architecture Behavioral of MultDFP_DPD is

    component MultDFP_bcd 
         generic (TypeRound: integer:= 4;
                    NExp: integer:= 10;
                    P: integer:=16);
                    
        Port ( sa, sb: in std_logic;
               qa, qb : in  std_logic_vector (NExp-1 downto 0);
               ma, mb : in  std_logic_vector (4*P-1 downto 0);
               sr: out std_logic;
               qr : out  std_logic_vector (NExp-1 downto 0);
               overflow, underflow: out std_logic;
               mr : out  std_logic_vector (4*P-1 downto 0));
    end component;
    
    component Decode 
         generic (N: integer:= 32;
                    NExp: integer:= 8;
                    P: integer:=7);
        Port ( d : in  std_logic_vector (N-1 downto 0);
               s: out std_logic;
                  q : out std_logic_vector (NExp-1 downto 0);
                  m : out  std_logic_vector (4*P-1 downto 0);
                  qNaN, sNaN, inf : out  STD_LOGIC);
    end component;

    component Encode 
	 generic (N: integer:= 32;
				NExp: integer:= 8;
				P: integer:=7);
    Port ( s: in std_logic;
			  q : in std_logic_vector (NExp-1 downto 0);
			  m : in  std_logic_vector (4*P-1 downto 0);
           qNaN, sNaN, inf : in  STD_LOGIC;
			  r : out  std_logic_vector (N-1 downto 0));
    end component;
    
    
    
    signal sa, sb, sr: std_logic;
    signal qa, qb, qr: std_logic_vector (NExp-1 downto 0);
    signal ma, mb, mr: std_logic_vector (4*P-1 downto 0);
    
    signal sNaN, qNaN, inf : std_logic; -- se�al que indica si el exponente a es mayor al b

begin


     
    
    EDecodeA: Decode 
                generic map (N => N, NExp => Nexp, P=> P)
                port map( d => ain, s => sa, q => qa, m => ma, 
                        qNaN => open, sNaN => open, inf => open);  
             
    EDecodeB: Decode 
                    generic map (N => N, NExp => Nexp, P=> P)
                    port map( d => bin, s => sb, q => qb, m => mb, 
                           qNaN => open, sNaN => open, inf => open);  

    
    EMult:  MultDFP_bcd 
         generic map (TypeRound => TypeRound, NExp => NExp, P => P)
         port map ( sa => sa, sb => sb, 
               qa => qa, qb => qb, 
               ma => ma, mb => mb,  
               overflow => overflow, underflow => underflow,
               sr => sr, qr => qr, mr => mr);
    
       
    -- por ahora no manejo NaN e inf    
    sNaN <= '0';
    qNaN <= '0';
    inf <= '0';

    EEncode: Encode 
        generic map (N => N, NExp => NExp, P=> P)
        port map ( s => sr,  q => qr,  m => mr, 
           qNaN => qNaN, sNaN => sNaN, inf => inf, r => o);
           
   
	
end Behavioral;

