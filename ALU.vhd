----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:24:57 12/21/2015 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

entity ALU is
	
	port(
		  dinA: in std_logic_vector(31 downto 0); 
		  dinB: in std_logic_vector(31 downto 0);
		  op: in std_logic;
		  dout: out std_logic_vector(31 downto 0));

end ALU;

architecture Behavioral of ALU is

signal operacion: std_logic_vector(63 downto 0);
--signal desbordamiento: std_logic;

begin
process(dinA, dinB, op)
begin

if(op = '0') then
		operacion <= std_logic_vector(unsigned(dinA) + unsigned(dinB)); 
elsif(op = '1') then
		operacion <= std_logic_vector(unsigned(dinA) * unsigned(dinB));
end if;
end process;

-- falta a�adir comprobacion de desbordamiento;
dout <= operacion(31 downto 0);

end Behavioral;