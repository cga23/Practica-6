----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:28:09 12/21/2015 
-- Design Name: 
-- Module Name:    ram_memory - Behavioral 
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

entity ram_memory is
	port(
		 clk: in std_logic;
		 we: in std_logic;
		 addr: in std_logic_vector(4 downto 0);
		 din: in std_logic_vector(15 downto 0);
		 dout: out std_logic_vector(15 downto 0));
end ram_memory;

architecture Behavioral of ram_memory is

type ram_type is array (0 to 31) of std_logic_vector (15 downto 0);
signal RAM : ram_type :=(
	X"0001", X"0002", X"0003", X"0004", X"0005", X"0006", X"0007", X"0008",
	X"0009", X"0010", X"0011", X"0012", X"0013", X"0014", X"0015", X"0016",
	X"0017", X"0018", X"0019", X"0020", X"0021", X"0022", X"0023", X"0024",
	X"0025", X"0026", X"0027", X"0028", X"0029", X"0030", X"0031", X"0032");

begin

memory_update : process ( clk )
begin
	if rising_edge ( clk ) then
		if we = '1' then
			RAM ( to_integer ( unsigned ( addr ))) <= din ;
		else
			dout <= RAM( to_integer ( unsigned ( addr )));
		end if;
	end if;
end process memory_update;
end Behavioral;

