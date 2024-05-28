library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Traffic_TB is
end Traffic_TB;

architecture Behavioral of Traffic_TB is

    signal clk    : std_logic := '1';
    signal rst    : std_logic := '1';
    
    signal buton  : std_logic := '0';

    -- outputs
    signal led          : std_logic_vector(13 downto 0);
    signal segment_out  : std_logic_vector(6 downto 0);
   
    constant clk_period : time := 10ns;

begin

    clk <= not clk after 5 ns;
    rst <= '1', '0' after 0 ns;
    uut: entity work.Traffic
    port map (
        clk => clk,
        rst => rst,
        buton => buton,
        led => led,
        segment_out => segment_out
    );
    
    stimulus: process
    begin
        wait until (rst = '0');
--        if buton = '1' then
--          wait for 5 ns;
--          buton <= '0';
--        end if;
        --wait;
    end process;
end Behavioral;
