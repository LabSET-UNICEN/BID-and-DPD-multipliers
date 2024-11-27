-- Para sintesis y obtener tiempos

-- Este módulo trabaja con tres formatos
-- decimal32: Nexp=8 y P=7 
-- decimal64: Nexp=10 y P=16 
-- decimal128:  Nexp=14 y P=34 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.my_package.all;

library UNISIM;
use UNISIM.VComponents.all;

entity MultDFP_DPD_reg is
    generic (TypeRound: integer:= 4;
				N: integer:= 64;
				NExp: integer:= 10;
				P: integer:=16);
				
    Port ( clk, rst: in std_logic;
           ain, bin : in  std_logic_vector (N-1 downto 0);
           overflow, underflow: out std_logic;
           o : out  std_logic_vector (N-1 downto 0));
end MultDFP_DPD_reg;

architecture Behavioral of MultDFP_DPD_reg is

    component MultDFP_DPD 
	       generic (TypeRound: integer:= 4;  N:integer:=64; NExp: integer:= 10;  P: integer:=16);
			port ( ain, bin: in std_logic_vector(N-1 downto 0);
                    overflow, underflow: out std_logic;
                    o: out std_logic_vector(N-1 downto 0));
    end component;
    
    signal next_underflow, next_overflow: std_logic;
    signal ff_underflow, ff_overflow: std_logic;
    signal reg_a, reg_b, next_o, reg_o: std_logic_vector(N-1 downto 0);
    

begin

   e_module: MultDFP_DPD
        generic map (TypeRound => TypeRound, N=> N,  NExp => NExp, P => P)
        Port map (  ain => reg_a, bin => reg_b, underflow => next_underflow, overflow => next_overflow,
               o => next_o);



    process (clk, rst)
    begin
        if (rst='1') then
            ff_underflow <= '0';
            ff_overflow <= '0';
            reg_a <= (others => '0');
            reg_b <= (others => '0');
            reg_o <= (others => '0');        
        elsif rising_edge(clk) then
            ff_underflow <= next_underflow;
            ff_overflow <= next_overflow;
            reg_a <= ain;
            reg_b <= bin;
            reg_o <= next_o;
        end if;
    end process;

    underflow <= ff_underflow;
    overflow <= ff_overflow;
    o <= reg_o;

end Behavioral;
