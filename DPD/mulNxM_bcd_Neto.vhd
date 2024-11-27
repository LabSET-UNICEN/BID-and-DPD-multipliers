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

entity mulNxM_bcd_Neto is
	 Generic ( NDigit : integer:=4; MDigit : integer:=4);
   Port (  a : in  STD_LOGIC_VECTOR (NDigit*4-1 downto 0);
           b : in  STD_LOGIC_VECTOR (MDigit*4-1 downto 0);
           p : out  STD_LOGIC_VECTOR ((NDigit+MDigit)*4-1 downto 0));
end mulNxM_bcd_Neto;

architecture Behavioral of mulNxM_bcd_Neto is


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


  --constant logM natural:= log2sup(MDigit);
  type partialSum is array (2*MDigit-2 downto 0) of STD_LOGIC_VECTOR ((NDigit+MDigit)*4-1 downto 0);
  signal pp,pps: partialSum;
  
  type partialSum_flagbcd is array (2*MDigit-2 downto 0) of STD_LOGIC_VECTOR (NDigit+MDigit-1 downto 0);
  signal pp_bcd,pps_bcd: partialSum_flagbcd;


begin 
 

 
	GenM: for i in 0 to (MDigit-1) generate --Multiply one by N
         mlt: Mult_Nx1_e6_Neto generic map (NDIGIT => NDigit) 
						  port map (d => a, y => b((i+1)*4-1 downto i*4), 
						        p_bcd => pp_bcd(i)(NDigit downto 0),
						        p => pp(i)((NDigit+1)*4-1 downto 0) );
    end generate;



	GenOps: for i in 0 to log2sup(MDigit)-1 generate --Tree of adders
    GP: for j in ((2**i-1)*2**(log2sup(MDigit)-i)) to (((2**i-1)*2**(log2sup(MDigit)-i)) + 2**(log2sup(MDigit)-i-1) -1) generate
     
        pps(2*j)((NDigit+MDigit)*4-1 downto (NDigit)*4) <= (others => '0'); 
        pps(2*j)((NDigit)*4-1 downto 0) <= pp(2*j)((NDigit+2**i)*4-1 downto (2**i)*4);
        
        pps_bcd(2*j)(NDigit+MDigit-1 downto NDigit) <= (others => '1'); 
        pps_bcd(2*j)(NDigit-1 downto 0) <= pp_bcd(2*j)(NDigit+2**i-1 downto 2**i);
                
--		adder: adder_BCD generic map (TAdd => TAdd, NDIGIT => NDigit+2**i) 
--            PORT MAP( a => pps(2*j)((NDigit+2**i)*4-1 downto 0), b => pp(2*j+1)((NDigit+2**i)*4-1 downto 0), 
--                      cin => '0', cout => open,	s => pp(MDIGIT+j)((NDigit+2**i+2**i)*4-1 downto ((2**i)*4))); 
      
		
		e_adder: adder_e6  Generic map (NDigit => NDigit+2**i)    
                          Port map ( 
                                  a => pps(2*j)((NDigit+2**i)*4-1 downto 0), 
                                  b => pp(2*j+1)((NDigit+2**i)*4-1 downto 0),
                                 a_bcd => pps_bcd(2*j)(NDigit+2**i-1 downto 0), 
                                 b_bcd => pp_bcd(2*j+1)(NDigit+2**i-1 downto 0), 
                                 cin => '0', cout => open,
                                 o_bcd => pp_bcd(MDIGIT+j)(NDigit+2**i+2**i-1 downto 2**i),
                                 o => pp(MDIGIT+j)((NDigit+2**i+2**i)*4-1 downto ((2**i)*4)));
                      		
		pp(MDIGIT+j)((2**i)*4-1 downto 0) <= pp(2*j)((2**i)*4-1 downto 0);
		pp_bcd(MDIGIT+j)(2**i-1 downto 0) <= pp_bcd(2*j)(2**i-1 downto 0);
		
    end generate;
  end generate;
  
  
  
--  p((NDigit+MDigit)*4-1 downto 0) <= pp(MDigit*2-2);
  gen_conv: for i in 0 to NDigit+MDigit-1 generate
        e_conv: BCDe6_to_BCD port map ( 
                    din => pp(MDigit*2-2)(4*(i+1)-1 downto 4*i),
                    dbcd =>pp_bcd(MDigit*2-2)(i),
                    dout => p(4*(i+1)-1 downto 4*i));
  end generate;
  
end Behavioral;

