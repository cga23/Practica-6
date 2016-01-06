----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:26:53 12/21/2015 
-- Design Name: 
-- Module Name:    RD - Behavioral 
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

entity RD is
	generic(cntrl: natural;
			  status: natural);
	port(
		  clk: in std_logic;
		  reset: in std_logic;
		  n: in std_logic_vector(4 downto 0);
		  x: in std_logic_vector(15 downto 0);
		  control: in std_logic_vector(cntrl - 1 downto 0);
		  y: out std_logic_vector(31 downto 0);
		  error: out std_logic;
		  status_sig: out std_logic_vector(status-1 downto 0));
end RD;

architecture Behavioral of RD is

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
--alias

--señales internas ruta de datos
signal iter_dir: std_logic_vector(4 downto 0);
signal dato_ram: std_logic_vector(15 downto 0);
signal dato_ram_extendido: std_logic_vector(31 downto 0);
signal alu_acumulado: std_logic_vector(31 downto 0);
signal acumulador_acumulado: std_logic_vector(31 downto 0);
signal din_acumulador: std_logic_vector(31 downto 0);
signal modulo: std_logic_vector(4 downto 0);
signal valor_y: std_logic_vector(31 downto 0);

--señales auxiliares resets
signal reset_iterador: std_logic;
signal reset_n: std_logic;
signal reset_acumulador: std_logic;
signal reset_y: std_logic;
signal reset_error: std_logic;

component registro is
	generic(N: natural);
	port(
		  clk: in std_logic;
		  reset: in std_logic;
		  load: in std_logic;
		  din: in std_logic_vector(N-1 downto 0);
		  dout: out std_logic_vector(N-1 downto 0));
end component;

component ram_memory is 
	port(
		 clk: in std_logic;
		 we: in std_logic;
		 addr: in std_logic_vector(4 downto 0);
		 din: in std_logic_vector(15 downto 0);
		 dout: out std_logic_vector(15 downto 0));
end component;

component ALU is
	port(
		  dinA: in std_logic_vector(31 downto 0); 
		  dinB: in std_logic_vector(31 downto 0);
		  op: in std_logic;
		  dout: out std_logic_vector(31 downto 0));
	
end component;

component contador_asc_desc is
	generic(N: integer);
	port(
		  clk: in std_logic;
		  reset: in std_logic;
		  load: in std_logic;
		  ce: in std_logic;
		  up_ndn: in std_logic;
		  modulo: in std_logic_vector(N-1 downto 0);
		  din: in std_logic_vector(N-1 downto 0);
		  dout: out std_logic_vector(N-1 downto 0));
end component;

begin
--asignacion de valores reset
reset_iterador <= reset or rst_iterador;
reset_n <= reset or rst_n;
reset_acumulador <= reset or rst_acumulador;
reset_y <= reset or rst_y;
reset_error <= reset or rst_error;


control_aux <= control;
status_sig <= status_aux;

registro_N: registro
	generic map(N => 5)
	port map(
				clk => clk,
				reset => reset_n,
				load => ld_n,
				din => n,
				dout => modulo);
				
ram: ram_memory
	port map(
				clk => clk,
				we => we,
				addr => iter_dir,
				din => "0000000000000000",
				dout => dato_ram 
				);
				
dato_ram_extendido <= "0000000000000000" & dato_ram;

unidad_aritmetico_logica: ALU
	port map(
				dinA => dato_ram_extendido,
				dinB => acumulador_acumulado,
				op => op,
				dout => alu_acumulado
				);

-- multiplexor seleccion entrada dato o acumulado de la alu al registro			
din_acumulador <= "0000000000000000" & x when mux_acu = '0' else alu_acumulado;
				
acumulador: registro
	generic map(N => 32)
	port map(
				clk => clk,
				reset => reset_acumulador,
				load => ld_acumulador,
				din => din_acumulador,
				dout => acumulador_acumulado
				);
				
iterador: contador_asc_desc
	generic map(N => 5)
	port map(
				clk => clk,
				reset => reset_iterador,
				load => ld_iterador,
			   ce => ce,
			   up_ndn => up_ndn,
			   modulo => modulo,
			   din => "00000",
			   dout => iter_dir
			   );
				
valor_y <= din_acumulador;
			  
registro_y: registro
	generic map( N => 32)
	port map(
				clk => clk,
				reset => reset_y,
				load => ld_y,
				din => valor_y,
				dout => y
				);
				
registro_error: registro
	generic map(N => 1)
	port map(
				clk => clk,
				reset => reset_error,
				load => ld_error,
				din => "1",
				dout(0) => error
				);
				
--comprobacion de las señales x y n con 0
error_0 <= '1' when x = "0000000000000000" or n = "00000" else '0';
iterador_equ <= '1' when iter_dir = std_logic_vector(unsigned(modulo) - 1)  else '0';

end Behavioral;