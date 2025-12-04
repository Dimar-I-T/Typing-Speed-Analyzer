library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.typing_speed_pkg.all;

entity tb_typing_speed_file is
    generic (
        SEED_OFFSET : integer := 0 
    );
end entity;

architecture sim of tb_typing_speed_file is

    component typing_speed_analyzer is
        port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            start      : in  std_logic;
            stop       : in  std_logic;
            char_valid : in  std_logic;
            target_char: in  std_logic_vector(7 downto 0);
            typed_char : in  std_logic_vector(7 downto 0);
            wpm_out    : out unsigned(31 downto 0);
            accuracy_out : out unsigned(31 downto 0);
            error_out  : out unsigned(31 downto 0)
        );
    end component;

    component result_txt_logger is
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
    end component;

    signal clk        : std_logic := '0';
    signal reset      : std_logic := '1';
    signal start      : std_logic := '0';
    signal stop       : std_logic := '0';
    signal char_valid : std_logic := '0';
    
    signal target_char_sig : std_logic_vector(7 downto 0) := (others => '0');
    signal typed_char_sig  : std_logic_vector(7 downto 0) := (others => '0');
    
    signal wpm_out      : unsigned(31 downto 0);
    signal accuracy_out : unsigned(31 downto 0);
    signal error_out    : unsigned(31 downto 0);
    
    signal sim_finished_flag : std_logic := '0';
    signal timeout_flag : std_logic := '0';
    signal stop_clock   : std_logic := '0';

    constant clk_period : time := 10 ns; 

begin

    uut: typing_speed_analyzer
        port map (
            clk          => clk,
            reset        => reset,
            start        => start,
            stop         => stop,
            char_valid   => char_valid,
            target_char  => target_char_sig,
            typed_char   => typed_char_sig,
            wpm_out      => wpm_out,
            accuracy_out => accuracy_out,
            error_out    => error_out
        );

    logger_inst : result_txt_logger
        port map (
            clk          => clk,
            wpm_data     => wpm_out,
            accuracy_data=> accuracy_out,
            error_data   => error_out,
            target_char  => target_char_sig,
            typed_char   => typed_char_sig,
            char_valid   => char_valid,
            print_enable => sim_finished_flag
        );

    clk_process : process
    begin
        while stop_clock = '0' loop
            clk <= '0'; wait for clk_period/2;
            clk <= '1'; wait for clk_period/2;
        end loop;
        wait;
    end process;

    timeout_process : process
    begin
        wait for 120 sec;
        report "TIMEOUT: Simulasi melebihi 2 menit!" severity warning;
        timeout_flag <= '1';
        wait for 100 ns;
        assert false report "Simulation stopped by timeout" severity failure;
    end process;

    main_process : process
        file target_file : text;
        file input_file  : text;
        variable linebuf : line;
        variable int_val : integer;
        variable status  : file_open_status;
        
        type char_array is array (0 to 200) of integer;
        variable target_buffer : char_array;
        variable target_len    : integer := 0;
        variable typed_count   : integer := 0;
        variable last_line_count : integer := 1;
        variable line_count    : integer := 0;
        variable found_new_data : boolean := false;
        variable wait_for_start : boolean := true;
        variable user_finished  : boolean := false;
        variable polling_cycles : integer := 0;
        variable timer_started  : boolean := false;
        
    begin
        reset <= '1'; 
        wait for 100 ns;
        reset <= '0'; 
        wait for 100 ns;
        
        report "STATUS: Waiting for Python START signal..." severity note;
        
        while wait_for_start loop
            file_open(status, input_file, "realtime_input.txt", read_mode);
            
            if status = open_ok then
                if not endfile(input_file) then
                    readline(input_file, linebuf);
                    read(linebuf, int_val);
                    
                    if int_val = 1 then
                        wait_for_start := false;
                        report "START SIGNAL DETECTED!" severity note;
                    end if;
                end if;
                file_close(input_file);
            end if;
            
            if wait_for_start then
                for i in 0 to 9999 loop
                    wait until rising_edge(clk);
                    if timeout_flag = '1' then exit; end if;
                end loop;
            end if;
            
            if timeout_flag = '1' then
                stop_clock <= '1';
                wait;
            end if;
        end loop;

        for i in 0 to 9999 loop
            wait until rising_edge(clk);
        end loop;

        file_open(status, target_file, "target_soal.txt", read_mode);
        if status /= open_ok then
             report "ERROR: Cannot open target_soal.txt" severity failure;
             stop_clock <= '1';
             wait;
        end if;
        
        target_len := 0;
        while not endfile(target_file) loop
            readline(target_file, linebuf);
            read(linebuf, int_val);
            target_buffer(target_len) := int_val;
            target_len := target_len + 1;
        end loop;
        file_close(target_file);
        
        report "Target loaded: " & integer'image(target_len) & " characters" severity note;

        while not user_finished loop
            found_new_data := false;
            
            file_open(status, input_file, "realtime_input.txt", read_mode);
            
            if status = open_ok then
                line_count := 0;
                while not endfile(input_file) loop
                    if line_count > 500 then exit; end if;
                    readline(input_file, linebuf);
                    line_count := line_count + 1;
                end loop;
                file_close(input_file);
                
                if line_count > last_line_count then
                    file_open(status, input_file, "realtime_input.txt", read_mode);
                    
                    for i in 0 to last_line_count - 1 loop
                        if not endfile(input_file) then
                            readline(input_file, linebuf);
                        end if;
                    end loop;
                    
                    while not endfile(input_file) loop
                        readline(input_file, linebuf);
                        
                        if linebuf'length = 0 then
                            last_line_count := last_line_count + 1;
                            next;
                        end if;
                        
                        read(linebuf, int_val);
                        last_line_count := last_line_count + 1;
                        
                        if int_val = 13 then
                            report "STOP SIGNAL DETECTED (Enter)" severity note;
                            user_finished := true;
                            exit;
                        end if;
                        
                        if int_val >= 32 and int_val <= 126 then
                            found_new_data := true;
                            
                            if not timer_started then
                                report "FIRST CHARACTER! Starting timer..." severity note;
                                start <= '1'; 
                                wait until rising_edge(clk);
                                start <= '0';
                                timer_started := true;
                            end if;
                            
                            if typed_count < target_len then
                                typed_char_sig  <= std_logic_vector(to_unsigned(int_val, 8));
                                target_char_sig <= std_logic_vector(to_unsigned(target_buffer(typed_count), 8));
                            else
                                typed_char_sig  <= std_logic_vector(to_unsigned(int_val, 8));
                                target_char_sig <= (others => '0');
                            end if;
                            
                            wait until rising_edge(clk);
                            char_valid <= '1';
                            wait until rising_edge(clk);
                            wait until rising_edge(clk);
                            char_valid <= '0';
                            
                            typed_count := typed_count + 1;
                            
                            if typed_count >= target_len then
                                report "TARGET REACHED! Stopping timer..." severity note;
                                stop <= '1'; 
                                wait until rising_edge(clk);
                                stop <= '0';
                            end if;
                        end if;
                    end loop;
                    
                    file_close(input_file);
                end if;
            end if;

            if not found_new_data then
                for i in 0 to 99999 loop
                    wait until rising_edge(clk);
                    if timeout_flag = '1' or user_finished then exit; end if;
                end loop;
            else
                for i in 0 to 99 loop
                    wait until rising_edge(clk);
                    if timeout_flag = '1' or user_finished then exit; end if;
                end loop;
            end if;
            
            if timeout_flag = '1' then
                stop_clock <= '1';
                wait;
            end if;
        end loop;

        report "========================================" severity note;
        report "VHDL SIMULATION COMPLETE" severity note;
        report "Characters logged: " & integer'image(typed_count) severity note;
        report "Check 'output_report.txt' for character-by-character log" severity note;
        report "Check 'python_results.txt' for final WPM/accuracy" severity note;
        report "========================================" severity note;
        
        for i in 0 to 9999 loop
            wait until rising_edge(clk);
        end loop;

        sim_finished_flag <= '1';
        
        for i in 0 to 9999 loop
            wait until rising_edge(clk);
        end loop;
        
        stop_clock <= '1';
        wait for 100 ns;
        
        assert false report "Simulation finished" severity failure;
        wait;
    end process;

end architecture;