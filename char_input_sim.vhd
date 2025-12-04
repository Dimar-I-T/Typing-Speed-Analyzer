library ieee;
use ieee.std_logic_1164.all;

entity char_input_sim is
    port (
        clk        : in  std_logic;
        char_valid : out std_logic
    );
end entity;

architecture behavior of char_input_sim is
begin
    process
    begin
        char_valid <= '0';
        wait for 100 ms;
        
        -- 10 karakter diketik
        for i in 1 to 10 loop
            char_valid <= '1';
            wait for 30 ms;  -- jarak antar karakter
            char_valid <= '0';
            wait for 40 ms;
        end loop;

        wait;
    end process;
end architecture;
