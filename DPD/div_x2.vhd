library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


library UNISIM;
use UNISIM.VComponents.all;

entity div_x2 is
	generic (P: integer:=34);
    Port ( v : in  STD_LOGIC_VECTOR (4*P-1 downto 0);
           o : out  STD_LOGIC_VECTOR (4*P-1 downto 0);
           r : out  STD_LOGIC_VECTOR (3 downto 0));
end div_x2;

architecture Behavioral of div_x2 is

component div2 
    Port ( v : in  STD_LOGIC_VECTOR (3 downto 0);
           ci: in std_logic;			
           d : out  STD_LOGIC_VECTOR (3 downto 0);
           co : out  STD_LOGIC);
end component;

signal c: std_logic_vector(P downto 0);

begin

	c(P) <= '0';
	
	gen_div2: for I in P-1 downto 0 generate

		e_div2:  div2 port map ( v => v(4*(I+1)-1 downto 4*I),ci => c(I+1), d => o(4*(I+1)-1 downto 4*I),co => c(I));

	end generate;
	r <= "000"&c(0);
	
end Behavioral;

