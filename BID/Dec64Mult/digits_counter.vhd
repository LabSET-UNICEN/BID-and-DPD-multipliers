--Circuito contador de digitos decimales en una mantisa en BID

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity digits_counter is
    Port ( A : in  std_logic_vector (53 downto 0);
           Qa : out std_logic_vector (6 downto 0));
end digits_counter;

architecture Behavioral of digits_counter is
    signal first_one : std_logic_vector (6 downto 0);	
    signal digits : std_logic_vector(4 downto 0);
    signal pow_of_ten : std_logic_vector(53 downto 0);

begin
   -- Busca posicion del primer '1' a izquierda. MSB=53, LSB=0
   leading_zeros:process (A)
      variable count: integer range 53 downto 0;     
   begin            
      count := 53;            
      for i in A'range loop             
         case A(i) is                    
            when '0' => count := count - 1;                 
            when others => exit;                
         end case;            
      end loop;  
      --count := count;          
      first_one <= conv_std_logic_vector(count, 7);        
   end process;  

   Qa <= "0000000" when first_one = "1111111" else first_one;

end Behavioral;

