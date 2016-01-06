----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:27:05 12/21/2015 
-- Design Name: 
-- Module Name:    UC - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
	generic(cntrl: natural;
			  status: natural);
	port(
		  clk: in std_logic;
		  reset: in std_logic;
		  inicio: in std_logic;
		  status_sig: in std_logic_vector(status-1 downto 0);
		  control: out std_logic_vector(cntrl-1 downto 0);
		  fin: out std_logic
		  );
	
end UC;

architecture Behavioral of UC is

--señales de control
signal control_aux: std_logic_vector(cntrl - 1 downto 0);
alias rst_iterador is control_aux(0);
alias ld_iterador is control_aux(1);
alias ce is control_aux(2);
alias up_ndn is control_aux(3);
alias rst_n is control_aux(4);
alias ld_n is control_aux(5);
alias rst_acumulador is control_aux(6);
alias ld_acumulador is control_aux(7);
alias we is control_aux(8);
alias op is control_aux(9);
alias ld_error is control_aux(10);
alias rst_error is control_aux(11);
alias ld_y is control_aux(12);
alias rst_y is control_aux(13);
alias mux_acu is control_aux(14);

--señales status
signal status_aux: std_logic_vector(status-1 downto 0);
alias error_0 is status_aux(0);
alias iterador_equ is status_aux(1);

type ESTADOS is (INICIAR, CARGAR, ESPERAR, ACTUALIZAR, ERROR);
signal estado, estado_siguiente: ESTADOS;

begin

control <= control_aux;
status_aux <= status_sig;

secuencial: process(clk, reset)
begin
	if(reset = '1') then
		estado <= INICIAR;
	elsif(clk'event and clk = '1') then
		estado <= estado_siguiente;
	end if;
end process;

combiancional: process(ESTADO, inicio, error_0, iterador_equ)
begin
	--establezco por defecto todas las salidas a cero
	control_aux <= (others => '0');
	fin <= '0';

case ESTADO is
	when INICIAR =>
		if(inicio = '0') then
			ESTADO_SIGUIENTE <= INICIAR;
		elsif(error_0 = '0') then
			ESTADO_SIGUIENTE <= CARGAR;
		else
			ESTADO_SIGUIENTE <= ERROR;
		end if;
		
		fin <= '1';
		rst_iterador <= '1';
		rst_n <= '1';
		rst_acumulador <= '1';
	
	when CARGAR =>
		ESTADO_SIGUIENTE <= ESPERAR;
		
		ld_n <= '1';
		ld_acumulador <= '1';
		rst_error <= '1';
		rst_y <= '1';
	
	when ESPERAR =>
		if(iterador_equ = '1') then
			ESTADO_SIGUIENTE <= INICIAR;
		else
			ESTADO_SIGUIENTE <= ACTUALIZAR;
		end if;
	
	when ACTUALIZAR =>
		ESTADO_SIGUIENTE <= ESPERAR;
		
		ld_acumulador <= '1';
		mux_acu <= '1';
		ce <= '1';
		up_ndn <= '1';
		ld_y <= '1';
		op <= '1';
	
	when ERROR =>
		ESTADO_SIGUIENTE <= INICIAR;
		
		ld_error <= '1';

end case;
end process;

end Behavioral;

