----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:24:25 12/21/2015 
-- Design Name: 
-- Module Name:    algorithmic - Behavioral 
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

entity algorithmic is
	generic(control: natural := 15;
			  status: natural := 2);
	port(
		  clk: in std_logic;
		  reset: in std_logic;
		  inicio: in std_logic;
		  n: in std_logic_vector(4 downto 0);
		  x: in std_logic_vector(15 downto 0);
		  y: out std_logic_vector(31 downto 0);
		  fin: out std_logic;
		  error: out std_logic);

end algorithmic;

architecture Behavioral of algorithmic is

component RD is
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

end component;

component UC is
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
end component;
  
signal control_sig: std_logic_vector(control-1 downto 0);
signal status_sig: std_logic_vector(status-1 downto 0);

begin

Ruta_de_datos: RD
	generic map( cntrl => control,
					 status => status
					)
	port map(
				clk => clk,
			   reset => reset,
			   n => n,
			   x => x,
			   control => control_sig,
			   y => y,
				error => error,
			   status_sig => status_sig
			  );

Unidad_de_control: UC
	generic map( cntrl => control,
					 status => status
					)
	port map(
			   clk => clk,
			   reset => reset,
			   inicio => inicio,
			   status_sig => status_sig,
			   control => control_sig,
			   fin => fin
				);

end Behavioral;