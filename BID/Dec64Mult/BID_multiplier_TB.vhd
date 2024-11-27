-- Implementacion combinacional del multiplicador de TSEN con DSPs


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use IEEE.std_logic_arith.all;

entity BID_multiplier_tb is 
end BID_multiplier_tb;

architecture behavior of BID_multiplier_tb is 
   COMPONENT BID_multiplier
   PORT(
       B_Ac            : IN std_logic_vector (53 downto 0);		-- mantisa de entrada A
       B_Asign		   : IN std_logic;							-- signo de entrada A
       B_Ae			   : IN std_logic_vector (9 downto 0);		-- exponente de entrada A

       B_Bc            : IN std_logic_vector (53 downto 0);		-- mantisa de entrada B
       B_Bsign		   : IN std_logic;							-- signo de entrada B
       B_Be			   : IN std_logic_vector (9 downto 0);		-- exponente de entrada B

       B_round_mode    : IN std_logic_vector(2 downto 0);       -- modo de redondeo
       
       rst             : IN std_logic;                          -- reset de registros
       clk             : IN std_logic;                          -- clock
	   
       B_Zc            : OUT std_logic_vector (53 downto 0);	-- mantisa de salida
       B_Zc_sign	   : OUT std_logic;							-- signo de salida
       B_Zc_e		   : OUT std_logic_vector (9 downto 0));	-- exponente de salida
   END COMPONENT;	

--inputs
       SIGNAL W_Ac_53_0       : std_logic_vector (53 downto 0);
       SIGNAL W_Asign		  : std_logic;
       SIGNAL W_Aexp		  : std_logic_vector (9 downto 0);
       SIGNAL W_Bc_53_0       : std_logic_vector (53 downto 0);
       SIGNAL W_Bsign		  : std_logic;
       SIGNAL W_Bexp		  : std_logic_vector (9 downto 0);
       SIGNAL W_mode          : std_logic_vector(2 downto 0);
       SIGNAL W_rst		      : std_logic := '0';
       SIGNAL W_clk		      : std_logic := '0';

--outputs
       SIGNAL W_Zc_53_0       : std_logic_vector (53 downto 0);
       SIGNAL W_Zisign		  : std_logic;
       SIGNAL W_Zic			  : std_logic_vector (9 downto 0);

begin 
   uut: BID_multiplier port map(
       B_Ac => W_Ac_53_0,
       B_Asign => W_Asign,
       B_Ae => W_Aexp,
       B_Bc => W_Bc_53_0,
       B_Bsign => W_Bsign,
       B_Be => W_Bexp,
       B_round_mode => W_mode,
       rst => W_rst,
       clk => W_clk,
       B_Zc => W_Zc_53_0,
       B_Zc_sign => W_Zisign,
       B_Zc_e => W_Zic	
   );
   
 tclk : process
	begin
		W_clk <= '0';
		wait for 10 ns;
		W_clk <= '1';
		wait for 10 ns;
	end process;

	trst : process
	begin
		W_rst <= '0';
		wait for 10 ns;
		W_rst <= '1';
		wait for 10 ns;
		W_rst <= '0';
		wait;
	end process; 
	
	
	data : process
	begin

--------------------------------------------------
-- A = 0000000000000005 x 10**2
-- B = 0000000000000005 x 10**3

        W_Ac_53_0 <= "00" & x"71AFD498D04D2";    --50000       
        W_Asign <= '0';
        W_Aexp <= "0110001101";
        W_Bc_53_0 <= "00" & x"0000000000BBD";    --50000
        W_Bsign <= '0';
        W_Bexp <= "0110011101";
        W_mode <= "000";
        wait for 100ns;
--- - - - - - - - - - - - - - - - - - - - - - - - -
       -- RESULTADO
       -- Zc_53_0 = 0x000009502f900 = 2500000000 < 10**15
       -- Zc_sign = 0
       -- Zc_exp  = 10
--------------------------------------------------  
	end process;
	
end behavior;