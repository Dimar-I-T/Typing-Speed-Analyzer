library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity typing_speed_analyzer is
    port (
        clk            : in  std_logic;
        reset          : in  std_logic;
        start          : in  std_logic;
        stop           : in  std_logic;
        char_valid     : in  std_logic;
        
        target_char    : in  std_logic_vector(7 downto 0);
        typed_char     : in  std_logic_vector(7 downto 0);
        
        wpm_out        : out unsigned(31 downto 0);
        accuracy_out   : out unsigned(31 downto 0);
        error_out      : out unsigned(31 downto 0)
    );
end entity;

architecture structural of typing_speed_analyzer is
    signal elapsed_ms_sig : unsigned(31 downto 0);
    signal wpm_sig        : unsigned(31 downto 0);
    signal accuracy_sig   : unsigned(31 downto 0);
    signal error_sig      : unsigned(31 downto 0);
begin
    timer_inst : entity work.timer_module
        port map (
            clk        => clk,
            reset      => reset,
            start      => start,
            stop       => stop,
            elapsed_ms => elapsed_ms_sig
        );
    
    analyzer_inst : entity work.keystroke_analyzer
        port map (
            clk            => clk,
            reset          => reset,
            char_valid     => char_valid,
            target_char    => target_char,
            typed_char     => typed_char,
            elapsed_ms     => elapsed_ms_sig,
            wpm_out        => wpm_sig,
            accuracy_out   => accuracy_sig,
            error_cnt_out  => error_sig
        );
    
    wpm_out      <= wpm_sig;
    accuracy_out <= accuracy_sig;
    error_out    <= error_sig;
end architecture;
