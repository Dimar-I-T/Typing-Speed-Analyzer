library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity result_txt_logger is
    port (
        clk          : in std_logic;
        wpm_data     : in unsigned(31 downto 0);
        accuracy_data: in unsigned(31 downto 0);
        error_data   : in unsigned(31 downto 0);
        
        target_char  : in std_logic_vector(7 downto 0);
        typed_char   : in std_logic_vector(7 downto 0);
        char_valid   : in std_logic;
        
        print_enable : in std_logic
    );
end entity;

architecture rtl of result_txt_logger is
    file outfile : text open write_mode is "output_report.txt";
    signal has_printed_final : boolean := false;
    signal char_valid_prev : std_logic := '0';
begin
    log_process : process(clk)
        variable L : line;
        variable char_targ : character;
        variable char_user : character;
    begin
        if rising_edge(clk) then
            
            -- Log Real-time setiap ketikan
            if char_valid = '1' and char_valid_prev = '0' then
                char_targ := character'val(to_integer(unsigned(target_char)));
                char_user := character'val(to_integer(unsigned(typed_char)));
                
                write(L, string'("Target: '"));
                write(L, char_targ);
                write(L, string'("' | User: '"));
                write(L, char_user);
                write(L, string'("' -> "));
                
                if target_char = typed_char then
                    write(L, string'("[OK]"));
                else
                    write(L, string'("[TYPO!]"));
                end if;
                writeline(outfile, L);
            end if;
            char_valid_prev <= char_valid;
            
            -- Log Final 
            if (print_enable = '1' and not has_printed_final) then
                write(L, string'("")); writeline(outfile, L);
                write(L, string'("========================================")); writeline(outfile, L);
                write(L, string'("    VHDL CHARACTER-BY-CHARACTER LOG     ")); writeline(outfile, L);
                write(L, string'("========================================")); writeline(outfile, L);
                write(L, string'("Log completed. Check 'python_results.txt'")); writeline(outfile, L);
                write(L, string'("for final WPM and accuracy results.")); writeline(outfile, L);
                write(L, string'("========================================")); writeline(outfile, L);
                has_printed_final <= true;
            end if;
        end if;
    end process;
end architecture;