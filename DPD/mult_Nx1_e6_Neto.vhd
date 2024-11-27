
-- Realiza el producto entre un operando multiplicando de Nx1|
-- Según paper de Neto y Vestias
-- La salida puede encontrarse en excess 6
-- Debido a ello, cuando se realiza la reducción de productos parciales en mult de NxM se considera esto
-- Para el caso que se requiera la mult Nx1 BCD, se debará convertir de BCD/excess6 a BCD

 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity Mult_Nx1_e6_Neto is
    Generic ( NDigit :integer:=34);
    Port ( d: in  std_logic_vector (NDigit*4-1 downto 0);
	        y : in  std_logic_vector (3 downto 0);
	        p_bcd: out std_logic_vector(NDigit downto 0);
			  p : out std_logic_vector((NDigit+1)*4-1 downto 0)); 
end Mult_Nx1_e6_Neto;


architecture Behavioral of Mult_Nx1_e6_Neto is

	
   component addersub_e6 
   Generic (NDigit : integer:=7);    
    Port ( 
	        a, b : in  STD_LOGIC_VECTOR (NDigit*4-1 downto 0);
           a_bcd, b_bcd : in  STD_LOGIC_VECTOR (NDigit-1 downto 0);
           op : in  STD_LOGIC;
           cout : out  STD_LOGIC;
           o_bcd : out  STD_LOGIC_VECTOR (NDigit-1 downto 0);
           o : out  STD_LOGIC_VECTOR (NDigit*4-1 downto 0));
    end component;
	
	component div_x2 
	generic (P: integer:=16);
    Port ( v : in  STD_LOGIC_VECTOR (4*P-1 downto 0);
           o : out  STD_LOGIC_VECTOR (4*P-1 downto 0);
           r : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	component mult_bcd_x2 
	   generic (P:integer:=8);
	   port ( d : in  STD_LOGIC_VECTOR (4*P-1 downto 0);
           r : out  STD_LOGIC_VECTOR (4*P+3 downto 0));
	end component;
	
		
    signal px0, px1, px2, px5, px10: std_logic_vector(4*(NDigit+1)-1 downto 0);
    -- para modelar 0x, 1x, 5x, 10x y 2x en la creación de productos parciales
	
	signal ones_bcd: std_logic_vector(NDigit downto 0);
	
	signal sa, sb: std_logic_vector (1 downto 0); 
	-- selectores según el paper de Neto para eefctuar la suma/resta de productos parciales
	
	signal op: std_logic; -- la operación a efectuar para generar el producto parcial excess 6
	
	signal oper_sela, oper_selb: std_logic_vector(4*(NDigit+1)-1 downto 0);
	
begin

    ones_bcd <= (others => '1');
    
    px0 <= (others => '0');
    
    px1 <= "0000"&d;
    
    ex2: mult_bcd_x2 generic map (P => NDigit)
                    port map( d => d, r => px2);
     
    px10 <= d&"0000";	

    ex5: div_x2 generic map (P => NDigit+1)
            port map ( v => px10 , o => px5, r => open); 
   									  

	sa <= "00" when (y="0000" or y="0001" or y="0010") else
	      "10" when (y="1000" or y="1001") else
	      "01"; -- para el resto de los casos 	 
	 
	sb <= "00" when (y="0000" or y="0101") else
                "10" when (y="0010" or y="0011" or y="0111" or y="1000") else
                "01"; -- para el resto de los casos      
	 
	op <= '1' when (y="0011" or y="0100" or y="1000" or y="1001") else
          '0'; -- para el resto de los casos      
	 
	
	oper_sela <= px0 when sa="00" else 
	             px5 when sa="01" else
                 px10; -- when sa="10";

	oper_selb <= px0 when sb="00" else 
	             px1 when sb="01" else
                 px2; -- when sb="10";

   e_addsub:  addersub_e6 generic map (NDigit => NDigit+1)    
                        Port map ( a => oper_sela, b => oper_selb,
                                    a_bcd => ones_bcd, b_bcd => ones_bcd, op => op, cout => open,
                                    o_bcd => p_bcd, o => p);
          

end Behavioral;

