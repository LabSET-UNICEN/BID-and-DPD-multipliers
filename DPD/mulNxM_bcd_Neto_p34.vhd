------------------------------------------------------------------
-- BCD multiplier X by Y (n by m digits)
-- -- Version combinacional
-- Este multiplicador es una implementación del multiplicador presentado por Neto y Vestias
------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.my_package.all;
library UNISIM;
use UNISIM.VComponents.all;

entity mulNxM_bcd_Neto_p34 is
	Port (  a : in  STD_LOGIC_VECTOR (135 downto 0); --34*4=136
      b : in  STD_LOGIC_VECTOR (135 downto 0);
      p : out  STD_LOGIC_VECTOR (271 downto 0));  --68*4=272
end mulNxM_bcd_Neto_p34;

architecture Behavioral of mulNxM_bcd_Neto_p34 is


component Mult_Nx1_e6_Neto 
   Generic ( NDigit :integer:=34);
   Port ( d: in  std_logic_vector (NDigit*4-1 downto 0);
       y : in  std_logic_vector (3 downto 0);
       p_bcd: out std_logic_vector(NDigit downto 0);
         p : out std_logic_vector((NDigit+1)*4-1 downto 0)); 
end component;

component adder_e6 
  Generic (NDigit : integer:=7);    
   Port ( 
           a, b : in  STD_LOGIC_VECTOR (NDigit*4-1 downto 0);
          a_bcd, b_bcd : in  STD_LOGIC_VECTOR (NDigit-1 downto 0);
          cin : in  STD_LOGIC;
          cout : out  STD_LOGIC;
          o_bcd : out  STD_LOGIC_VECTOR (NDigit-1 downto 0);
          o : out  STD_LOGIC_VECTOR (NDigit*4-1 downto 0));
end component;

component BCDe6_to_BCD 
   Port ( din : in STD_LOGIC_VECTOR (3 downto 0);
          dbcd : in STD_LOGIC;
          dout : out STD_LOGIC_VECTOR (3 downto 0));
end component;


type partialAdd_flagbcd_N1 is array (0 to 33) of STD_LOGIC_VECTOR (34 downto 0); -- P+1 bits 
signal pp_bcd: partialAdd_flagbcd_N1;

type partialAdd_flagbcd_N2 is array (0 to 16) of STD_LOGIC_VECTOR (35 downto 0); --P+2 bits 
signal pp2_bcd_in_a, pp2_bcd_in_b, pp2_bcd: partialAdd_flagbcd_N2;

type partialAdd_flagbcd_N3 is array (0 to 7) of STD_LOGIC_VECTOR (37 downto 0); -- P+4 bits 
signal pp3_bcd_in_a, pp3_bcd_in_b, pp3_bcd: partialAdd_flagbcd_N3;

type partialAdd_flagbcd_N4 is array (0 to 3) of STD_LOGIC_VECTOR (41 downto 0); -- P+8 bits
signal pp4_bcd_in_a, pp4_bcd_in_b, pp4_bcd: partialAdd_flagbcd_N4;

type partialAdd_flagbcd_N5 is array (0 to 1) of STD_LOGIC_VECTOR (49 downto 0); -- P+16 bits
signal pp5_bcd_in_a, pp5_bcd_in_b, pp5_bcd: partialAdd_flagbcd_N5;

signal pp6_bcd_in_a, pp6_bcd_in_b, pp6_bcd: STD_LOGIC_VECTOR (65 downto 0); -- P+32 bits

signal pp7_bcd_in_a, pp7_bcd_in_b, pp7_bcd: STD_LOGIC_VECTOR (67 downto 0); -- P+34 bits

-- =====

type partialAdd_N1 is array (0 to 33) of STD_LOGIC_VECTOR (139 downto 0); --P+1 dígitos => 34*4+4 = 136+4 = 136+4 = 140 bits 
signal pp: partialAdd_N1;

type partialAdd_N2 is array (0 to 16) of STD_LOGIC_VECTOR (143 downto 0); -- P+2 dígitos =>  136+2*4 = 144 bits
signal pp2_in_a, pp2_in_b, pp2: partialAdd_N2;

type partialAdd_N3 is array (0 to 7) of STD_LOGIC_VECTOR (151 downto 0); -- P+4 dígitos =>  136+4*4 = 152 bits
signal pp3_in_a, pp3_in_b, pp3: partialAdd_N3;

type partialAdd_N4 is array (0 to 3) of STD_LOGIC_VECTOR (167 downto 0);-- P+8 dígitos =>  136+8*4 = 168 bits
signal pp4_in_a, pp4_in_b, pp4: partialAdd_N4;

type partialAdd_N5 is array (0 to 1) of STD_LOGIC_VECTOR (199 downto 0);-- P+16 dígitos =>  136+16*4 = 200 bits
signal pp5_in_a, pp5_in_b, pp5: partialAdd_N5;

signal pp6_in_a, pp6_in_b, pp6: STD_LOGIC_VECTOR (263 downto 0);-- P+32 dígitos =>  136+32*4 = 264 bits

signal pp7_in_a, pp7_in_b, pp7: STD_LOGIC_VECTOR (271 downto 0);-- P+34 dígitos =>  136+34*4 = 272 bits

begin 

--  ==== Nivel 1
GenM: for i in 0 to 33 generate --Multiply one by N
    mlt: Mult_Nx1_e6_Neto generic map (NDIGIT => 34) 
                     port map (d => a, y => b((i+1)*4-1 downto i*4), 
                           p_bcd => pp_bcd(i),
                           p => pp(i));
end generate;
-- =====

--  ==== Nivel 2
GenPP_2: for i in 0 to 16 generate 
    
    pp2_in_a(i) <= (x"0"&pp(2*i));
    pp2_bcd_in_a(i) <= ('1'&pp_bcd(2*i));
    pp2_in_b(i) <= (pp(2*i+1)&x"0");
    pp2_bcd_in_b(i) <= (pp_bcd(2*i+1)&'1');

    e_adder_2: adder_e6  Generic map (NDigit => 36) -- P+2   
                     Port map ( 
                            a => pp2_in_a(i), 
                            b => pp2_in_b(i),
                            a_bcd => pp2_bcd_in_a(i), 
                            b_bcd => pp2_bcd_in_b(i), 
                            cin => '0', cout => open,
                            o_bcd => pp2_bcd(i),
                            o => pp2(i));
end generate;
-- pp2(16) y pp2_bcd(16) son de P+2 dígitos, esto se desplazará 32 dígitos para suma de último nivel

-- =======

--  ==== Nivel 3
GenPP_3: for i in 0 to 7 generate 
    
    pp3_in_a(i) <= (x"00"&pp2(2*i));
    pp3_bcd_in_a(i) <= ("11"&pp2_bcd(2*i));
    pp3_in_b(i) <= (pp2(2*i+1)&x"00");
    pp3_bcd_in_b(i) <= (pp2_bcd(2*i+1)&"11");

    e_adder_3: adder_e6  Generic map (NDigit => 38) -- P+4   
                     Port map ( 
                            a => pp3_in_a(i), 
                            b => pp3_in_b(i),
                            a_bcd => pp3_bcd_in_a(i), 
                            b_bcd => pp3_bcd_in_b(i), 
                            cin => '0', cout => open,
                            o_bcd => pp3_bcd(i),
                            o => pp3(i));
end generate;
--  ======

--  ==== Nivel 4
GenPP_4: for i in 0 to 3 generate 
    
    pp4_in_a(i) <= (x"0000"&pp3(2*i));
    pp4_bcd_in_a(i) <= ("1111"&pp3_bcd(2*i));
    pp4_in_b(i) <= (pp3(2*i+1)&x"0000");
    pp4_bcd_in_b(i) <= (pp3_bcd(2*i+1)&"1111");

    e_adder_4: adder_e6  Generic map (NDigit => 42) -- P+8   
                     Port map ( 
                            a => pp4_in_a(i), 
                            b => pp4_in_b(i),
                            a_bcd => pp4_bcd_in_a(i), 
                            b_bcd => pp4_bcd_in_b(i), 
                            cin => '0', cout => open,
                            o_bcd => pp4_bcd(i),
                            o => pp4(i));
end generate;
--  ======


--  ==== Nivel 5
GenPP_5: for i in 0 to 1 generate 
    
    pp5_in_a(i) <= (x"00000000"&pp4(2*i));
    pp5_bcd_in_a(i) <= ("11111111"&pp4_bcd(2*i));
    pp5_in_b(i) <= (pp4(2*i+1)&x"00000000");
    pp5_bcd_in_b(i) <= (pp4_bcd(2*i+1)&"11111111");

    e_adder_5: adder_e6  Generic map (NDigit => 50) -- P+16   
                     Port map ( 
                            a => pp5_in_a(i), 
                            b => pp5_in_b(i),
                            a_bcd => pp5_bcd_in_a(i), 
                            b_bcd => pp5_bcd_in_b(i), 
                            cin => '0', cout => open,
                            o_bcd => pp5_bcd(i),
                            o => pp5(i));
end generate;
--  ======

--  ==== Nivel 6
pp6_in_a <= (x"0000000000000000"&pp5(0));
pp6_bcd_in_a <= ("1111111111111111"&pp5_bcd(0));
pp6_in_b <= (pp5(1)&x"0000000000000000");
pp6_bcd_in_b <= (pp5_bcd(1)&"1111111111111111");

e_adder_6: adder_e6  Generic map (NDigit => 66) -- P+32  
                Port map ( 
                    a => pp6_in_a, 
                    b => pp6_in_b,
                    a_bcd => pp6_bcd_in_a, 
                    b_bcd => pp6_bcd_in_b, 
                    cin => '0', cout => open,
                    o_bcd => pp6_bcd,
                    o => pp6);
--  ======

--  ==== Último Nivel 
pp7_in_a <= (x"00"&pp6);
pp7_bcd_in_a <= ("11"&pp6_bcd);
pp7_in_b <= (pp2(16)&x"00000000000000000000000000000000");
pp7_bcd_in_b <= (pp2_bcd(16)&"11111111111111111111111111111111");

e_adder_7: adder_e6  Generic map (NDigit => 68) -- P+34 
                Port map ( 
                    a => pp7_in_a, 
                    b => pp7_in_b,
                    a_bcd => pp7_bcd_in_a, 
                    b_bcd => pp7_bcd_in_b, 
                    cin => '0', cout => open,
                    o_bcd => pp7_bcd,
                    o => pp7);
--  ======


gen_conv: for i in 0 to 67 generate
   e_conv: BCDe6_to_BCD port map ( 
               din => pp7(4*(i+1)-1 downto 4*i),
               dbcd => pp7_bcd(i),
               dout => p(4*(i+1)-1 downto 4*i));
end generate;

end Behavioral;

