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

entity mulNxM_bcd_Neto_p7 is
	Port (  a : in  STD_LOGIC_VECTOR (27 downto 0);
      b : in  STD_LOGIC_VECTOR (27 downto 0);
      p : out  STD_LOGIC_VECTOR (55 downto 0));
end mulNxM_bcd_Neto_p7;

architecture Behavioral of mulNxM_bcd_Neto_p7 is


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


type partialAdd_flagbcd_N1 is array (0 to 6 ) of STD_LOGIC_VECTOR (7 downto 0);
signal pp_bcd: partialAdd_flagbcd_N1;

type partialAdd_flagbcd_N2 is array (0 to 3) of STD_LOGIC_VECTOR (8 downto 0); 
signal pp2_bcd_in_a, pp2_bcd_in_b, pp2_bcd: partialAdd_flagbcd_N2;

type partialAdd_flagbcd_N3 is array (0 to 1) of STD_LOGIC_VECTOR (10 downto 0); 
signal pp3_bcd_in_a, pp3_bcd_in_b, pp3_bcd: partialAdd_flagbcd_N3;

type partialAdd_flagbcd_N4 is array (0 to 0) of STD_LOGIC_VECTOR (14 downto 0); 
signal pp4_bcd_in_a, pp4_bcd_in_b, pp4_bcd: partialAdd_flagbcd_N4;

-- =====

type partialAdd_N1 is array (0 to 6) of STD_LOGIC_VECTOR (31 downto 0);
signal pp: partialAdd_N1;

type partialAdd_N2 is array (0 to 3) of STD_LOGIC_VECTOR (35 downto 0);
signal pp2_in_a, pp2_in_b, pp2: partialAdd_N2;

type partialAdd_N3 is array (0 to 1) of STD_LOGIC_VECTOR (43 downto 0);
signal pp3_in_a, pp3_in_b, pp3: partialAdd_N3;

type partialAdd_N4 is array (0 to 1) of STD_LOGIC_VECTOR (59 downto 0);
signal pp4_in_a, pp4_in_b, pp4: partialAdd_N4;

begin 


--  ==== Nivel 1
GenM: for i in 0 to 6 generate --Multiply one by N
    mlt: Mult_Nx1_e6_Neto generic map (NDIGIT => 7) 
                     port map (d => a, y => b((i+1)*4-1 downto i*4), 
                           p_bcd => pp_bcd(i),
                           p => pp(i));
end generate;
-- =====


--  ==== Nivel 2
GenPP_2: for i in 0 to 2 generate 
    
    pp2_in_a(i) <= (x"0"&pp(2*i));
    pp2_bcd_in_a(i) <= ('1'&pp_bcd(2*i));
    pp2_in_b(i) <= (pp(2*i+1)&x"0");
    pp2_bcd_in_b(i) <= (pp_bcd(2*i+1)&'1');

    e_adder_2: adder_e6  Generic map (NDigit => 9)    
                     Port map ( 
                            a => pp2_in_a(i), 
                            b => pp2_in_b(i),
                            a_bcd => pp2_bcd_in_a(i), 
                            b_bcd => pp2_bcd_in_b(i), 
                            cin => '0', cout => open,
                            o_bcd => pp2_bcd(i),
                            o => pp2(i));
end generate;

pp2(3) <= (x"0"&pp(6));
pp2_bcd(3) <= ('1'&pp_bcd(6));
-- =======

--  ==== Nivel 3
GenPP_3: for i in 0 to 1 generate 
    
    pp3_in_a(i) <= (x"00"&pp2(2*i));
    pp3_bcd_in_a(i) <= ("11"&pp2_bcd(2*i));
    pp3_in_b(i) <= (pp2(2*i+1)&x"00");
    pp3_bcd_in_b(i) <= (pp2_bcd(2*i+1)&"11");

    e_adder_3: adder_e6  Generic map (NDigit => 11)    
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
GenPP_4: for i in 0 to 0 generate 
    
    pp4_in_a(i) <= (x"0000"&pp3(2*i));
    pp4_bcd_in_a(i) <= ("1111"&pp3_bcd(2*i));
    pp4_in_b(i) <= (pp3(2*i+1)&x"0000");
    pp4_bcd_in_b(i) <= (pp3_bcd(2*i+1)&"1111");

    e_adder_4: adder_e6  Generic map (NDigit => 15)    
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


--  ==== el dígito más significativo será 0 en esta configuración de P=7

gen_conv: for i in 0 to 13 generate
   e_conv: BCDe6_to_BCD port map ( 
               din => pp4(0)(4*(i+1)-1 downto 4*i),
               dbcd => pp4_bcd(0)(i),
               dout => p(4*(i+1)-1 downto 4*i));
end generate;

end Behavioral;

