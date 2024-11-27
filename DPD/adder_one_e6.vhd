-- Sumador del trabajo de Neto y Vestias
-- posibilita suma en exceso 6

-- wbcd y zbcd son flags que indican si w y z 
-- respectivamente son números en BCD o se encuentran en exceso 6 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity adder4_e6 is
    Port ( z,w : in std_logic_vector(3 downto 0);
           cin, zbcd, wbcd : in std_logic;
           o : out std_logic_vector(3 downto 0);
           cout : out std_logic);
end adder4_e6;

architecture Behavioral of adder4_e6 is

    signal p,g: std_logic_vector(3 downto 0);
    signal co: std_logic_vector(2 downto 0);

begin
        
         g <= w; 
           
-- ============ Comienzo: Para el bit 0
	     
          p(0) <= z(0) xor w(0);
                      
		  Mxcy_0: MUXCY port map (
		    	DI => g(0),
		    	CI => cin,
		    	S => p(0),
		    	O => co(0));

		  XORCY_0 : XORCY
			   port map (
			      O => o(0), 
			      CI => cin, 
			      LI => p(0) 
			   );				
-- ============ Fin: Para el bit 0				
	
-- ============ Comienzo: Para el bit 1
	   	
		  p(1) <= ((not z(1)) xor w(1)) when (wbcd = zbcd) else
		          (z(1) xor w(1));
                      
		  Mxcy_1: MUXCY port map (
		    	DI => g(1),
		    	CI => co(0),
		    	S => p(1),
		    	O => co(1));

		  XORCY_1 : XORCY
			   port map (
			      O => o(1), 
			      CI => co(0), 
			      LI => p(1) 
			   );						
-- ============ Fin: Para el bit 1						


-- ============ Comienzo: Para el bit 2
	 

		  p(2) <= ((not z(2)) xor z(1) xor w(2)) when ((zbcd = '1') and (wbcd='1')) else
		          (z(2) xor z(1) xor w(2)) when ((zbcd = '0') and (wbcd='0')) else
		          (z(2) xor w(2));
                      
		  Mxcy_2: MUXCY port map (
		    	DI => g(2),
		    	CI => co(1),
		    	S => p(2),
		    	O => co(2));

		  XORCY_2 : XORCY
			   port map (
			      O => o(2), 
			      CI => co(1), 
			      LI => p(2) 
			   );				
-- ============ Fin: Para el bit 2				


-- ============ Comienzo: Para el bit 3

	     p(3) <= (z(3) xor (z(2) or z(1)) xor w(3)) when ((zbcd = '1') and (wbcd='1')) else
		          ((not z(3)) xor (z(2) and z(1)) xor w(3)) when ((zbcd = '0') and (wbcd='0')) else
		          (z(3) xor w(3)); 
		              
         Mxcy_3: MUXCY port map (
               DI => g(3),
               CI => co(2),
               S => p(3),
               O => cout);

         XORCY_3 : XORCY
              port map (
                 O => o(3), 
                 CI => co(2), 
                 LI => p(3) 
              );    				

-- ============ Fin: Para el bit 3				


end Behavioral;
