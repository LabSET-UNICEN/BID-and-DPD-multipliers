-- sumador de N dígitos de planteado por Neto
-- es un sumador que tiene soporte de operandos en exceso 6
-- para ello se encuentran los flags a_bcd, b_bcd
-- y la salida o_bcd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



library UNISIM;
use UNISIM.VComponents.all;

entity adder_e6 is
   Generic (NDigit : integer:=7);    
    Port ( 
	        a, b : in  STD_LOGIC_VECTOR (NDigit*4-1 downto 0);
           a_bcd, b_bcd : in  STD_LOGIC_VECTOR (NDigit-1 downto 0);
           cin : in  STD_LOGIC;
           cout : out  STD_LOGIC;
           o_bcd : out  STD_LOGIC_VECTOR (NDigit-1 downto 0);
           o : out  STD_LOGIC_VECTOR (NDigit*4-1 downto 0));
end adder_e6;

architecture Behavioral of adder_e6 is

    
    component adder4_e6 
        Port ( z,w : in std_logic_vector(3 downto 0);
               cin, zbcd, wbcd : in std_logic;
               o : out std_logic_vector(3 downto 0);
               cout : out std_logic);
    end component;

    signal cyin: std_logic_vector(NDigit downto 0); 
    
 
begin

	cyin(0) <= cin;
	
	GenAdd: for i in 0 to NDigit-1 generate
		
		GAdd: adder4_e6 
		      port map(w => a((i+1)*4-1 downto i*4),
							 z => b((i+1)*4-1 downto i*4),
							wbcd => a_bcd(I),
							zbcd => b_bcd(I),
							cin => cyin(i),
							o => o((i+1)*4-1 downto i*4),
							cout => cyin(i+1));
	
	end generate;	
	
    o_bcd <= cyin(NDigit downto 1);
    cout <= cyin(NDigit);
    
end Behavioral;
