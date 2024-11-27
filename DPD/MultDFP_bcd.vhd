-- Este core efectúa la multiplicaciñón con operandos IEEE 2008 ya decodificados, trabajando con mantisa en BCD

-- Tranaja con los operandos ya decodificados 
-- <sa>, <qa> y <ma>; correspondiente a signo, exponente y 
-- mantisa de operando <a>

-- <sb>, <qb> y <mb>; correspondiente a signo, exponente y 
-- mantisa de operando <b>
-- No hay manejo de underflow, overflog, NaN, etc


-- Trabaja con operandos de entrada <a> y <b> codificados y resultado <r> tambien codificado
-- Produce ademas diferentes banderas: overflow y underflow

-- Este módulo trabaja con tres formatos
-- decimal32: Nexp=8 y P=7, bias de exponente 101 = 01100101
-- decimal64: Nexp=10 y P=16, bias de exponente 398 =  0110001110 = 18E
-- decimal128:  Nexp=14 y P=34, bias de exponente 6276 =  01 1000 1000 0100 

-- Donde 
--  N representa la cantidad de bits de los operandos
--  NExp la cantidad de bits que posee el exponente
--  P la precisión deimal de la mantisa
-- Tanto NExp como P son datos que usan los compontes de mas bajo nivel

-- para el exponente, el bias es:
-- 

-- Donde 
-- TypeRound es la técnica de redondeo

-- Para TypeRound cuando es
-- 0 => RoundTowardPositive
-- 1 => RoundTowardNegative
-- 2 => RoundTowardZero
-- 3 => RoundTiesToAway
-- 4 => RoundTiesToEven

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL; -- después veo esto pero trabajaré con signed (c2 el tema de exponente)
use work.my_package.all;

library UNISIM;
use UNISIM.VComponents.all;

entity MultDFP_bcd is
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
end MultDFP_bcd;

architecture Behavioral of MultDFP_bcd is


-- estos multiplicadores punto fijo, se usarán para el caso que requieramos 16x16 p decimal64
    component mulNxM_bcd 
         Generic (TM1:integer:=6; TAdd: integer:=0; NDigit : integer:=4; MDigit : integer:=4);
       Port (  a : in  STD_LOGIC_VECTOR (NDigit*4-1 downto 0);
               b : in  STD_LOGIC_VECTOR (MDigit*4-1 downto 0);
               p : out  STD_LOGIC_VECTOR ((NDigit+MDigit)*4-1 downto 0));
    end component; 
    -- este multiplicador posee todos los de la maestrría y además algunos basados en sumas y el de Vázquez
    -- todos se deben comentar dentro de la descripción de multNxM_bcd. no están parametrizables

    component mulNxM_bcd_Neto 
         Generic ( NDigit : integer:=4; MDigit : integer:=4);
       Port (  a : in  STD_LOGIC_VECTOR (NDigit*4-1 downto 0);
               b : in  STD_LOGIC_VECTOR (MDigit*4-1 downto 0);
               p : out  STD_LOGIC_VECTOR ((NDigit+MDigit)*4-1 downto 0));
    end component;
    
    component mulNxM_bcd_Neto_p7 
        Port (  a : in  STD_LOGIC_VECTOR (27 downto 0);
          b : in  STD_LOGIC_VECTOR (27 downto 0);
          p : out  STD_LOGIC_VECTOR (55 downto 0));
    end component;
    
    component mulNxM_bcd_Neto_p34 
        Port (  a : in  STD_LOGIC_VECTOR (135 downto 0); --34*4=136
          b : in  STD_LOGIC_VECTOR (135 downto 0);
          p : out  STD_LOGIC_VECTOR (271 downto 0));  --68*4=272
    end component;
    
--==========
     
     component LeadingZeros is
        generic (P: integer:=16);
        Port ( a : in  STD_LOGIC_VECTOR (4*P-1 downto 0);
             c : out  STD_LOGIC_VECTOR (log2sup(P+1)-1 downto 0));
    end component; 
     
    component adder_BCD_L6 
           Generic (TAdd: integer:= 1; NDigit : integer:=7);    
            Port ( 
                    a, b : in  STD_LOGIC_VECTOR (NDigit*4-1 downto 0);
                   cin : in  STD_LOGIC;
                   cout : out  STD_LOGIC;
                   s : out  STD_LOGIC_VECTOR (NDigit*4-1 downto 0));
    end component; 
          
    signal qr_add_bias2: std_logic_vector(NExp+1 downto 0); 
    -- posee el qr de sumar los exponentes, se encuentra 2xbias, hay qeu corregisrlo 
   
    signal qr_add_corr: std_logic_vector(NExp+1 downto 0); 
    -- posee el qr con la corrección (resta del bias) y suma de P 
     
   signal qr_pre_rd: std_logic_vector(NExp+1 downto 0); 
   -- posee el qr previo al redondeo, en donde se considera el leading zero  
          
   signal qr_rd:  std_logic_vector(NExp+1 downto 0); 
     -- posee el qr luego del redondeo
   
   signal mp: std_logic_vector (8*P-1 downto 0); -- Posee el resultado completo de la multiplicación punto fijo
   
   signal count_lz: std_logic_vector(log2sup(P+1)-1 downto 0);
   -- posee la cantidad de ceros iniciales del operando con mayor exponente  
   
   signal m_pre_rd: std_logic_vector(4*(P+2)-1 downto 0);
   -- señal de P+2 dígitos que posee el producto sin los 0 iniciales, listo para que se redondee
   
   signal oper_zero_rd : std_logic_vector(4*P-1 downto 0); --usado para suma en redondeo
   signal oper_rd: std_logic; -- usado para sumar uno en redondeo

   signal cy_rd: std_logic; -- modela carry generado por ultima soma en redondeo
   signal m_rd: std_logic_vector(4*P-1 downto 0); -- resultado de efectuar la suma de uno en redondeo
    
begin

    sr <= sa xor sb;

    qr_add_bias2 <= ("00"&qa) + ('0'&qb); -- posee la suma de los exponentes, se debe corregir restando bias
    -- posee un bit mas porque puede que cuando corrija me quede un némero negativo (en C2)
    
    -- detección de zeros iniciales del 
    E_lz: LeadingZeros generic map (P => P)
                    Port map (a =>  mp(8*P-1 downto 4*P),  c => count_lz);
    
    

  
    e_proc_7: if P=7 generate 
           
              e_mult_7: mulNxM_bcd_Neto_p7 Port map (  a => ma, b => mb,  p => mp );

              m_pre_rd(4*(P+2)-1 downto 4) <= (mp(8*P-1 downto 4*(P-1))) when (count_lz="000") else
                                                          (mp(8*P-5 downto 4*(P-1)-4)) when (count_lz="001") else
                                                           (mp(8*P-9 downto 4*(P-1)-8)) when (count_lz="010") else
                                                           (mp(8*P-13 downto 4*(P-1)-12)) when (count_lz="011") else
                                                           (mp(8*P-17 downto 4*(P-1)-16)) when (count_lz="100") else
                                                           (mp(8*P-21 downto 4*(P-1)-20)) when (count_lz="101") else
                                                           (mp(8*P-25 downto 4*(P-1)-24)) when (count_lz="110") else
                                                           (mp(8*P-29 downto 0)&x"0"); --when (count_lz="111")  
                                                           
                         -- ====  m_pred_rd(3 downto 0) posee el digit sticky
                         
                                m_pre_rd(3 downto 1) <= "000";
                                m_pre_rd(0) <= '1' when (count_lz="00000") and (mp(4*(P-1)-1 downto 0)/=0) else
                                               '1' when (count_lz="00001") and (mp(4*(P-2)-1 downto 0)/=0) else
                                               '1' when (count_lz="00010") and (mp(4*(P-3)-1 downto 0)/=0) else
                                               '1' when (count_lz="00011") and (mp(4*(P-4)-1 downto 0)/=0) else
                                               '1' when (count_lz="00100") and (mp(4*(P-5)-1 downto 0)/=0) else
                                               '1' when (count_lz="00101") and (mp(4*(P-6)-1 downto 0)/=0) else
                                               '0'; -- when (count_lz="110") o  when (count_lz="111")               
                                                                                                                                              
                                    
                                qr_add_corr <= qr_add_bias2 - "0001011110";  
                                -- suma P para quedarme con los más significativos y corrijo restando el bias =>  -bias+P=  resto (101-7)= 94 = 01011110    
                                -- se corrige la operación de suma y además se desplaza  mantisa*10**P 
                                
                                overflow <=  '1' when qr_rd>191 else '0'; -- mayor al máximo representable 101+90=191 = 10 111111
                                         
     end generate;
    
                            
    e_proc_16: if P=16 generate 

        e_mult_16: --   mulNxM_bcd Generic map (TM1 => 6, TAdd => 2, NDigit => P, MDigit => P) 
                    mulNxM_bcd_Neto Generic map (NDigit => P, MDigit => P)
                                    Port map (  a => ma, b => mb,  p => mp ); 
            

        m_pre_rd(4*(P+2)-1 downto 4) <= (mp(8*P-1 downto 4*(P-1))) when (count_lz="00000") else
                                  (mp(8*P-5 downto 4*(P-1)-4)) when (count_lz="00001") else
                                   (mp(8*P-9 downto 4*(P-1)-8)) when (count_lz="00010") else
                                   (mp(8*P-13 downto 4*(P-1)-12)) when (count_lz="00011") else
                                   (mp(8*P-17 downto 4*(P-1)-16)) when (count_lz="00100") else
                                   (mp(8*P-21 downto 4*(P-1)-20)) when (count_lz="00101") else
                                   (mp(8*P-25 downto 4*(P-1)-24)) when (count_lz="00110") else
                                   (mp(8*P-29 downto 4*(P-1)-28)) when (count_lz="00111") else
                                   (mp(8*P-33 downto 4*(P-1)-32)) when (count_lz="01000") else
                                   (mp(8*P-37 downto 4*(P-1)-36)) when (count_lz="01001") else
                                   (mp(8*P-41 downto 4*(P-1)-40)) when (count_lz="01010") else
                                   (mp(8*P-45 downto 4*(P-1)-44)) when (count_lz="01011") else
                                   (mp(8*P-49 downto 4*(P-1)-48)) when (count_lz="01100") else
                                   (mp(8*P-53 downto 4*(P-1)-52)) when (count_lz="01101") else
                                   (mp(8*P-57 downto 4*(P-1)-56)) when (count_lz="01110") else
                                   (mp(8*P-61 downto 4*(P-1)-60)) when (count_lz="01111") else
                                   (mp(8*P-65 downto 0)&x"0");  -- when (count_lz="10000")
                                                  
 -- ====  m_pred_rd(3 downto 0) posee el digit sticky
 
        m_pre_rd(3 downto 1) <= "000";
        m_pre_rd(0) <= '1' when (count_lz="00000") and (mp(4*(P-1)-1 downto 0)/=0) else
                       '1' when (count_lz="00001") and (mp(4*(P-2)-1 downto 0)/=0) else
                       '1' when (count_lz="00010") and (mp(4*(P-3)-1 downto 0)/=0) else
                       '1' when (count_lz="00011") and (mp(4*(P-4)-1 downto 0)/=0) else
                       '1' when (count_lz="00100") and (mp(4*(P-5)-1 downto 0)/=0) else
                       '1' when (count_lz="00101") and (mp(4*(P-6)-1 downto 0)/=0) else
                       '1' when (count_lz="00110") and (mp(4*(P-7)-1 downto 0)/=0) else
                       '1' when (count_lz="00111") and (mp(4*(P-8)-1 downto 0)/=0) else
                       '1' when (count_lz="01000") and (mp(4*(P-9)-1 downto 0)/=0) else                      
                       '1' when (count_lz="01001") and (mp(4*(P-10)-1 downto 0)/=0) else
                       '1' when (count_lz="01010") and (mp(4*(P-11)-1 downto 0)/=0) else
                       '1' when (count_lz="01011") and (mp(4*(P-12)-1 downto 0)/=0) else
                       '1' when (count_lz="01100") and (mp(4*(P-13)-1 downto 0)/=0) else
                       '1' when (count_lz="01101") and (mp(4*(P-14)-1 downto 0)/=0) else
                       '1' when (count_lz="01110") and (mp(4*(P-15)-1 downto 0)/=0) else
                       '0'; -- when (count_lz="01111") o  when (count_lz="10000")               
                       
            
        qr_add_corr <= qr_add_bias2 - "000101111110";  
        -- suma P para quedarme con los más significativos y corrijo restando el bias =>  -bias+P=  resto (398-16)= 382 = 001 0111 1110)       
        -- se corrige la operación de suma y además se desplaza  mantisa*10**P 
        
        overflow <=  '1' when qr_rd>767 else '0'; -- mayor al máximo representable 369+398=767 = 10 1111 1111 
                 
    end generate;


    e_proc_34: if P=34 generate 

        e_mult_34:  mulNxM_bcd_Neto_p34 Port map (  a => ma, b => mb,  p => mp );

        m_pre_rd(4*(P+2)-1 downto 4) <= 
                                   (mp(8*P-1 downto 4*(P-1))) when (count_lz="000000") else
                                   (mp(8*P-5 downto 4*(P-1)-4)) when (count_lz="000001") else
                                   (mp(8*P-9 downto 4*(P-1)-8)) when (count_lz="000010") else
                                   (mp(8*P-13 downto 4*(P-1)-12)) when (count_lz="000011") else
                                   (mp(8*P-17 downto 4*(P-1)-16)) when (count_lz="000100") else
                                   (mp(8*P-21 downto 4*(P-1)-20)) when (count_lz="000101") else
                                   (mp(8*P-25 downto 4*(P-1)-24)) when (count_lz="000110") else
                                   (mp(8*P-29 downto 4*(P-1)-28)) when (count_lz="000111") else
                                   (mp(8*P-33 downto 4*(P-1)-32)) when (count_lz="001000") else
                                   (mp(8*P-37 downto 4*(P-1)-36)) when (count_lz="001001") else
                                   (mp(8*P-41 downto 4*(P-1)-40)) when (count_lz="001010") else
                                   (mp(8*P-45 downto 4*(P-1)-44)) when (count_lz="001011") else
                                   (mp(8*P-49 downto 4*(P-1)-48)) when (count_lz="001100") else
                                   (mp(8*P-53 downto 4*(P-1)-52)) when (count_lz="001101") else
                                   (mp(8*P-57 downto 4*(P-1)-56)) when (count_lz="001110") else
                                   (mp(8*P-61 downto 4*(P-1)-60)) when (count_lz="001111") else
                                   (mp(8*P-65 downto 4*(P-1)-64)) when (count_lz="010000") else
                                   (mp(8*P-69 downto 4*(P-1)-68)) when (count_lz="010001") else
                                   (mp(8*P-73 downto 4*(P-1)-72)) when (count_lz="010010") else
                                   (mp(8*P-77 downto 4*(P-1)-76)) when (count_lz="010011") else
                                   (mp(8*P-81 downto 4*(P-1)-80)) when (count_lz="010100") else
                                   (mp(8*P-85 downto 4*(P-1)-84)) when (count_lz="010101") else
                                   (mp(8*P-89 downto 4*(P-1)-88)) when (count_lz="010110") else
                                   (mp(8*P-93 downto 4*(P-1)-92)) when (count_lz="010111") else
                                   (mp(8*P-97 downto 4*(P-1)-96)) when (count_lz="011000") else
                                   (mp(8*P-101 downto 4*(P-1)-100)) when (count_lz="011001") else
                                   (mp(8*P-105 downto 4*(P-1)-104)) when (count_lz="011010") else
                                   (mp(8*P-109 downto 4*(P-1)-108)) when (count_lz="011011") else
                                   (mp(8*P-113 downto 4*(P-1)-112)) when (count_lz="011100") else
                                   (mp(8*P-117 downto 4*(P-1)-116)) when (count_lz="011101") else
                                   (mp(8*P-121 downto 4*(P-1)-120)) when (count_lz="011110") else
                                   (mp(8*P-125 downto 4*(P-1)-124)) when (count_lz="011111") else
                                   (mp(8*P-129 downto 4*(P-1)-128)) when (count_lz="100000") else
                                   (mp(8*P-133 downto 4*(P-1)-132)) when (count_lz="100001") else
                                   (mp(8*P-137 downto 0)&x"0"); -- when (count_lz="100010") else
                                            
 -- ====  m_pred_rd(3 downto 0) posee el digit sticky
 
        m_pre_rd(3 downto 1) <= "000";
        m_pre_rd(0) <= 
                       '1' when (count_lz="000000") and (mp(4*(P-1)-1 downto 0)/=0) else
                       '1' when (count_lz="000001") and (mp(4*(P-2)-1 downto 0)/=0) else
                       '1' when (count_lz="000010") and (mp(4*(P-3)-1 downto 0)/=0) else
                       '1' when (count_lz="000011") and (mp(4*(P-4)-1 downto 0)/=0) else
                       '1' when (count_lz="000100") and (mp(4*(P-5)-1 downto 0)/=0) else
                       '1' when (count_lz="000101") and (mp(4*(P-6)-1 downto 0)/=0) else
                       '1' when (count_lz="000110") and (mp(4*(P-7)-1 downto 0)/=0) else
                       '1' when (count_lz="000111") and (mp(4*(P-8)-1 downto 0)/=0) else
                       '1' when (count_lz="001000") and (mp(4*(P-9)-1 downto 0)/=0) else                      
                       '1' when (count_lz="001001") and (mp(4*(P-10)-1 downto 0)/=0) else
                       '1' when (count_lz="001010") and (mp(4*(P-11)-1 downto 0)/=0) else
                       '1' when (count_lz="001011") and (mp(4*(P-12)-1 downto 0)/=0) else
                       '1' when (count_lz="001100") and (mp(4*(P-13)-1 downto 0)/=0) else
                       '1' when (count_lz="001101") and (mp(4*(P-14)-1 downto 0)/=0) else
                       '1' when (count_lz="001110") and (mp(4*(P-15)-1 downto 0)/=0) else
                       '1' when (count_lz="001111") and (mp(4*(P-16)-1 downto 0)/=0) else
                       '1' when (count_lz="010000") and (mp(4*(P-17)-1 downto 0)/=0) else
                       '1' when (count_lz="010001") and (mp(4*(P-18)-1 downto 0)/=0) else
                       '1' when (count_lz="010010") and (mp(4*(P-19)-1 downto 0)/=0) else
                       '1' when (count_lz="010011") and (mp(4*(P-20)-1 downto 0)/=0) else
                       '1' when (count_lz="010100") and (mp(4*(P-21)-1 downto 0)/=0) else
                       '1' when (count_lz="010101") and (mp(4*(P-22)-1 downto 0)/=0) else
                       '1' when (count_lz="010110") and (mp(4*(P-23)-1 downto 0)/=0) else
                       '1' when (count_lz="010111") and (mp(4*(P-24)-1 downto 0)/=0) else
                       '1' when (count_lz="011000") and (mp(4*(P-25)-1 downto 0)/=0) else
                       '1' when (count_lz="011001") and (mp(4*(P-26)-1 downto 0)/=0) else
                       '1' when (count_lz="011010") and (mp(4*(P-27)-1 downto 0)/=0) else
                       '1' when (count_lz="011011") and (mp(4*(P-28)-1 downto 0)/=0) else
                       '1' when (count_lz="011100") and (mp(4*(P-29)-1 downto 0)/=0) else
                       '1' when (count_lz="011101") and (mp(4*(P-30)-1 downto 0)/=0) else
                       '1' when (count_lz="011110") and (mp(4*(P-31)-1 downto 0)/=0) else
                       '1' when (count_lz="011111") and (mp(4*(P-32)-1 downto 0)/=0) else
                       '1' when (count_lz="100000") and (mp(4*(P-33)-1 downto 0)/=0) else
                       '0'; -- when (count_lz="100001") o  when (count_lz="100010")               
                       
            
        qr_add_corr <= qr_add_bias2 - "0001100000000000";  
        -- suma P para quedarme con los más significativos y corrijo restando el bias =>  -bias+P=  resto (6178-34)= 6144 = 00011000 00000000)       
        -- se corrige la operación de suma y además se desplaza  mantisa*10**P 
        
        overflow <=  '1' when qr_rd>12287 else '0'; -- mayor al máximo representable 12287 = 10  1111 1111 1111 
                 
   
   end generate;         

   
    qr_pre_rd <= qr_add_corr - ('0'&count_lz); 
    -- consideración de zeros iniciales en el desplazamiento para los P dígitos más significativos de mantisa   


    oper_zero_rd <= (others => '0');    
                        
    round_ties_Even: if TypeRound=4 generate
                           oper_rd <= '1'  when  ( (m_pre_rd(7) ='1')  or  (m_pre_rd(6 downto 5)="11") )  else -- si segundo dígito es mayor a 5 
                                      '1'  when  ( (m_pre_rd(7 downto 4)="0101") and 
                                                  ( (m_pre_rd(3) ='1') or (m_pre_rd(2) ='1') or (m_pre_rd(1) ='1') or (m_pre_rd(0) ='1'))) else
                                                  -- si segundo dígito es =5 y resto diferente a 0         
                                      '1'  when ( (m_pre_rd(7 downto 4)="0101") and (m_pre_rd(8) ='1')) -- si segundo dígito es 5 y menos significativo de parte entera es impar                                               (m_pre_rd(8) ='1')) 
                                            else '0';                       
                            
    end generate;
                        
    e_AddRound: adder_BCD_L6  generic map (TAdd => 2, NDigit => P)    
                                port map ( a => m_pre_rd(4*(P+2)-1 downto 8), b => oper_zero_rd, cin => oper_rd,
                                       cout => cy_rd, s => m_rd);
    -- si existe cy (cy_rd), se debe hacer corrimiento a izquierda y sumar uno al exponente del resultado                




    qr_rd <=  qr_pre_rd when (cy_rd='0') else (qr_pre_rd+"01");    
   
    qr <= qr_rd(Nexp-1 downto 0);
    mr <= m_rd when (cy_rd='0') else ("0001"&m_rd(4*P-1 downto 4));
    underflow <= '1' when qr_rd<0 else '0'; -- si es menor a cero (zero desplazado es menor que qmin)    

    
end Behavioral;
