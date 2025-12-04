import msvcrt
import time
import os
import random

XSIM_FOLDER = r"C:\Users\Naufal Rahman\Downloads\VIVADO PSD\Typing Speed Analyzer\Typing Speed Analyzer.sim\sim_1\behav\xsim"

if not os.path.exists(XSIM_FOLDER):
    print("="*60)
    print("ERROR: Folder xsim tidak ditemukan!")
    XSIM_FOLDER = os.getcwd()
    print(f"Menggunakan folder saat ini: {XSIM_FOLDER}")

try:
    os.chdir(XSIM_FOLDER)
except:
    pass

FILE_INPUT = "realtime_input.txt"
FILE_TARGET = "target_soal.txt"
FILE_RESULT = "python_results.txt"

# Bank Soal
SENTENCES = [
    "the quick brown fox jumps over the lazy dog near the riverbank",
    "artificial intelligence and machine learning are transforming our world",
    "ketika matahari terbenam di ufuk barat langit berubah menjadi jingga keemasan",
    "debugging is like being a detective in a crime movie where you are also the murderer",
    "practice makes perfect but nobody is perfect so why practice at all",
    "kopi hitam panas mengepul di pagi hari sambil membaca berita terkini",
    "life is what happens when you are busy making other plans for tomorrow",
    "to be or not to be that is the question shakespeare once wrote",
    "komputer generasi terbaru menggunakan teknologi quantum computing yang revolusioner",
    "never gonna give you up never gonna let you down never gonna run around",
]

def write_to_file(filename, data, mode='a'):
    try:
        with open(filename, mode) as f:
            f.write(data)
            f.flush()
            os.fsync(f.fileno())
        return True
    except Exception as e:
        return False

def main():
    os.system('cls' if os.name == 'nt' else 'clear')
    print("="*60)
    print("   VHDL TYPING SPEED TEST - CLEAN MODE")
    print("="*60)
    
    # 1. BERSIHKAN FILE LAMA
    write_to_file(FILE_INPUT, "", 'w')
    
    # 2. PILIH SOAL
    target_sentence = random.choice(SENTENCES)
    
    # Kirim soal ke VHDL
    soal_content = ""
    for char in target_sentence:
        soal_content += f"{ord(char)}\n"
    write_to_file(FILE_TARGET, soal_content, 'w')
    
    print(f"Soal siap! Menunggu VHDL...")

    # 3. KIRIM SINYAL START
    time.sleep(0.5)
    write_to_file(FILE_INPUT, "1\n", 'w')
    time.sleep(0.5)

    # 4. MULAI GAME
    print("\n" + "="*60)
    print(f"SOAL : {target_sentence}")
    print("-" * 60)
    print("KETIK: ", end="", flush=True)

    user_buffer = []
    start_time = time.time()
    
    total_typos_made = 0 
    total_keystrokes = 0

    try:
        while True:
            if msvcrt.kbhit():
                key = msvcrt.getch()
                key_code = ord(key)
                
                # ESC
                if key_code == 27:
                    print("\n[DIBATALKAN]")
                    return

                # ENTER
                if key_code == 13:
                    break
                
                # BACKSPACE
                if key_code == 8:
                    if len(user_buffer) > 0:
                        print("\b \b", end="", flush=True)
                        user_buffer.pop()
                        
                        content = "1\n"
                        for char in user_buffer:
                            content += f"{ord(char)}\n"
                        write_to_file(FILE_INPUT, content, 'w')
                    continue
                
                # Karakter Normal
                if 32 <= key_code <= 126:
                    try:
                        char = key.decode('utf-8')
                        
                        if len(user_buffer) < len(target_sentence): 
                            print(char, end="", flush=True)
                            user_buffer.append(char)
                            
                            # --- CEK TYPO ---
                            current_index = len(user_buffer) - 1
                            expected_char = target_sentence[current_index]
                            
                            total_keystrokes += 1
                            
                            if char != expected_char:
                                total_typos_made += 1 

                            write_to_file(FILE_INPUT, f"{key_code}\n", 'a')
                    except:
                        pass
            
            time.sleep(0.001)

        # HITUNG HASIL
        end_time = time.time()
        elapsed_sec = end_time - start_time
        elapsed_min = elapsed_sec / 60
        
        typed_str = "".join(user_buffer)
        final_len = len(typed_str)
        
        # Kecepatan
        cpm = 0
        wpm = 0
        if elapsed_min > 0:
            cpm = final_len / elapsed_min
            wpm = cpm / 5

        # Hitung typo  
        # max(0, ...) biar gak minus kalau typonya 0
        final_typos = max(0, total_typos_made - 1)

        # Akurasi 
        accuracy = 0
        if total_keystrokes > 0:
            accuracy = ((total_keystrokes - final_typos) / total_keystrokes) * 100
            if accuracy < 0: accuracy = 0
        elif final_len > 0:
             accuracy = 100.0

        # Tampilan Layar 
        print("\n\n" + "="*60)
        print("                  HASIL AKHIR")
        print("="*60)
        print(f"Waktu       : {elapsed_sec:.2f} detik")
        print(f"CPM         : {cpm:.0f}")
        print(f"WPM         : {wpm:.1f}")
        print(f"Akurasi     : {accuracy:.1f}%")
        print(f"Typo (Adj)  : {final_typos}")
        print("="*60)

        # SIMPAN LAPORAN KE FILE 
        report_content = f"""
            ==================================================
                    LAPORAN HASIL TYPING SPEED GAME          
            ==================================================
            Tanggal       : {time.strftime('%Y-%m-%d %H:%M:%S')}

            LAPORAN PERFORMA:
            -----------------
            Waktu         : {elapsed_sec:.2f} detik
            Kecepatan     : {wpm:.1f} WPM | {cpm:.0f} CPM
            Akurasi       : {accuracy:.1f} %
            Jumlah Typo   : {final_typos} 
            ==================================================
        """
        write_to_file(FILE_RESULT, report_content.strip(), 'w')
        
        print(f"\n[SUKSES] Laporan singkat tersimpan di:\n{os.path.join(XSIM_FOLDER, FILE_RESULT)}")

        # Kirim STOP ke VHDL
        write_to_file(FILE_INPUT, "13\n", 'a')

    except KeyboardInterrupt:
        print("\nStopped.")
    except Exception as e:
        print(f"\nError: {e}")

if __name__ == "__main__":
    main()