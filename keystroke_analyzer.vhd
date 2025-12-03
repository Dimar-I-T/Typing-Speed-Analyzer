library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keystroke_analyzer is
    port (
        clk            : in  std_logic;
        reset          : in  std_logic;
        char_valid     : in  std_logic;
        
        target_char    : in  std_logic_vector(7 downto 0);
        typed_char     : in  std_logic_vector(7 downto 0);
        
        elapsed_ms     : in  unsigned(31 downto 0);
        
        wpm_out        : out unsigned(31 downto 0);
        accuracy_out   : out unsigned(31 downto 0);
        error_cnt_out  : out unsigned(31 downto 0)
    );
end entity;

architecture behavioral of keystroke_analyzer is
    signal total_keystrokes   : unsigned(31 downto 0) := (others => '0');
    signal correct_keystrokes : unsigned(31 downto 0) := (others => '0');
    signal error_count        : unsigned(31 downto 0) := (others => '0');
    
    signal wpm_calc  : unsigned(31 downto 0) := (others => '0');
    signal acc_calc  : unsigned(31 downto 0) := (others => '0');
    
    signal char_valid_prev : std_logic := '0';
begin
    process(clk)
        variable total_i    : integer;
        variable correct_i  : integer;
        variable elapsed_i  : integer;
        variable wpm_i      : integer;
        variable acc_i      : integer;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                total_keystrokes   <= (others => '0');
                correct_keystrokes <= (others => '0');
                error_count        <= (others => '0');
                wpm_calc           <= (others => '0');
                acc_calc           <= (others => '0');
                char_valid_prev    <= '0';
            else
                -- Logika Pengecekan Huruf
                if char_valid = '1' and char_valid_prev = '0' then
                    total_keystrokes <= total_keystrokes + 1;
                    
                    if typed_char = target_char then
                        correct_keystrokes <= correct_keystrokes + 1;
                    else
                        error_count <= error_count + 1;
                    end if;
                end if;
                char_valid_prev <= char_valid;
                
                -- Konversi ke Integer
                total_i    := to_integer(total_keystrokes);
                correct_i  := to_integer(correct_keystrokes);
                elapsed_i  := to_integer(elapsed_ms);
                
                -- 1. Hitung WPM
                -- Rumus: (Total Chars / 5) * (60000 ms / Elapsed ms) = (Total Chars * 12000) / Elapsed ms
                if elapsed_i > 0 then
                    if total_i > 0 then
                        wpm_i := (total_i * 12000) / elapsed_i;
                    else 
                        wpm_i := 0;
                    end if;
                else
                    wpm_i := 0;
                end if;
                
                -- 2. Hitung Akurasi (%)
                if total_i > 0 then
                    acc_i := (correct_i * 100) / total_i;
                else
                    acc_i := 100;
                end if;
                
                wpm_calc <= to_unsigned(wpm_i, 32);
                acc_calc <= to_unsigned(acc_i, 32);
            end if;
        end if;
    end process;
    
    wpm_out       <= wpm_calc;
    accuracy_out  <= acc_calc;
    error_cnt_out <= error_count;
end architecture;