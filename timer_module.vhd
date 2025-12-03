library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.typing_speed_pkg.all;

entity timer_module is
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        start        : in  std_logic;
        stop         : in  std_logic;
        elapsed_ms   : out unsigned(31 downto 0)
    );
end entity;

architecture behavioral of timer_module is

    signal counter      : unsigned(31 downto 0) := (others => '0');
    signal running_flag : std_logic := '0';

    constant TICKS_PER_MS : integer := CLOCK_FREQ / 1000;
    signal tick_count     : unsigned(31 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                counter      <= (others => '0');
                tick_count   <= (others => '0');
                running_flag <= '0';

            elsif start = '1' then
                running_flag <= '1';

            elsif stop = '1' then
                running_flag <= '0';

            elsif running_flag = '1' then
                if tick_count = to_unsigned(TICKS_PER_MS - 1, 32) then
                    tick_count <= (others => '0');
                    counter    <= counter + 1;       -- +1ms
                else
                    tick_count <= tick_count + 1;
                end if;
            end if;
        end if;
    end process;

    elapsed_ms <= counter;

end architecture;
