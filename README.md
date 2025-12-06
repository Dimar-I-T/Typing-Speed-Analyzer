# Typing-Speed-Analyzer

## Deskripsi Proyek
Typing Speed Analyzer adalah sistem digital yang dirancang untuk mengukur kecepatan dan akurasi mengetik pengguna. Sistem ini menerima input karakter, menghitung waktu pengetikan, membandingkan teks yang diketik dengan teks referensi, lalu menghasilkan nilai seperti Words Per Minute (WPM), jumlah kesalahan, dan akurasi akhir.

## Fitur-Fitur
- Mengukur waktu pengetikan secara real time
- Menghitung WPM
- Mengukur jumlah kesalahan ketik
- Menghasilkan tingkat akurasi pengetikan
- Menampilkan hasil analisis dalam bentuk output digital

## Arsitektur Sistem
- Modul Input Karakter
- Modul Timer
- Modul Perbandingan Teks
- Modul Perhitungan WPM dan Akurasi
- Modul Output Hasil

## Implementasi Modul
- Dataflow Style
  <br> <img width="831" height="145" alt="image" src="https://github.com/user-attachments/assets/bd5c4495-42c3-486a-a837-cafb04c6d26d" />
  Dataflow digunakan untuk menetapkan nilai sinyal secara concurrent (bersamaan) tanpa menunggu clock, seperti menghubungkan sinyal internal ke port output utama.

- Behavorial Style
  <br> <img width="532" height="527" alt="image" src="https://github.com/user-attachments/assets/4a57f2f3-e842-453f-92d3-bec169253f56" />
  Behavioral digunakan di dalam blok process untuk mendeskripsikan algoritma kompleks secara berurutan (sekuensial), seperti logika pengecekan huruf dan penghitungan counter.

- Testbench
  <br> <img width="527" height="132" alt="image" src="https://github.com/user-attachments/assets/f5b4cd90-d6d3-4b99-a460-a8b883b6016c" />
  <img width="505" height="468" alt="image" src="https://github.com/user-attachments/assets/15519e4b-167b-46ee-9e26-09f0842bde1d" />
  Testbench dirancang sebagai modul penguji tanpa port input/output fisik, yang bertugas membangkitkan sinyal simulasi untuk memverifikasi sistem dan berinteraksi dengan lingkungan eksternal (Python) melalui mekanisme I/O file untuk simulasi Hardware-in-the-Loop (HIL).

- Structural Programming
  <br> <img width="502" height="67" alt="image" src="https://github.com/user-attachments/assets/3b44265c-ca1e-4a8e-ac60-d227479f67ab" />
  <img width="633" height="481" alt="image" src="https://github.com/user-attachments/assets/eedb9afc-8d45-4ffe-8b74-52c140a541fb" />
  Pemrograman struktural digunakan pada modul top-level untuk merakit dan menghubungkan komponen-komponen kecil (Timer dan Analyzer) menjadi satu sistem yang utuh. Sinyal internal seperti elapsed_ms_sig digunakan sebagai "kabel" untuk menghubungkan output dari satu modul ke input modul lainnya melalui mekanisme port map.

- Looping Construct
  <br> <img width="892" height="382" alt="image" src="https://github.com/user-attachments/assets/27a66f30-03da-4cce-b4f6-a9ef696ebf3a" />
  While loop digunakan secara intensif dalam testbench untuk membaca file input karakter demi karakter secara terus-menerus hingga simulasi selesai.

- Procedure, Function, and Impure Function
  <br> <img width="677" height="93" alt="image" src="https://github.com/user-attachments/assets/79bbc232-7844-4203-9c82-e1d6fdcbf2f3" />
  <img width="846" height="77" alt="image" src="https://github.com/user-attachments/assets/424eb3d9-4a4b-47f2-9dc9-ad10679a341a" />
  <img width="871" height="52" alt="image" src="https://github.com/user-attachments/assets/a6294913-cf32-403c-b3d8-22e2196990c7" />
  Menerapkan Function (to_integer) untuk mengonversi tipe data sinyal menjadi integer agar bisa diproses, Procedure (write) untuk menyusun string dan data ke dalam variabel buffer baris (Line), serta Impure Procedure (writeline) yang memiliki side effect untuk menuliskan baris tersebut secara fisik ke file eksternal.

## Kontributor
- Dimar Ilham Tamara (2406413804)
- Fernanda Raeka Yan Putra (2406415791)
- Gogra Friedrik Simatupang (2406487020)
- Naufal Rahman (2406413142)

## Cara Menggunakan Typing Speed Analyzer (Integrasi VHDL & Python)
Proyek ini mensimulasikan sistem penganalisis kecepatan mengetik dengan pendekatan Hardware-in-the-Loop. Logika digital (VHDL) dijalankan pada simulator Vivado, sementara antarmuka input pengguna ditangani oleh skrip Python.

### Prasyarat
Xilinx Vivado (untuk simulasi VHDL).

Python (untuk menjalankan skrip input/output).

Sistem Operasi Windows (diperlukan karena penggunaan pustaka msvcrt pada skrip Python).

### Persiapan Awal
Pastikan seluruh file sumber VHDL (.vhd) telah ditambahkan ke dalam proyek Vivado.

Letakkan file typing_game.py di dalam direktori simulasi aktif Vivado. Lokasi standar biasanya berada di: [FolderProyek]/*.sim/sim_1/behav/xsim/

Apabila skrip Python dijalankan dari luar direktori tersebut, sesuaikan variabel XSIM_FOLDER di dalam typing_game.py agar mengarah ke path folder xsim yang valid.

### Langkah-Langkah Menjalankan

1. Jalankan Simulasi di Vivado:
Pilih Run Simulation -> Run Behavioral Simulation.

2. Jalankan Skrip Python
Run script python di Visual Studio Code maupun CMD, yang penting lokasinya benar (sesuai yang sudah ditulis di atas)

3. Klik Run All pada Vivado
Status: Vivado akan tampak memuat (loading). Hal ini karena VHDL sedang menunggu sinyal "START" dari Python.

4. Mulai Mengetik
Kembali ke terminal Python. Script akan menampilkan soal dan siap menerima input.

5. Ketik kalimat sesuai dengan soal yang ditampilkan di layar.
Setiap karakter yang diketik akan dikirim secara real-time ke simulasi VHDL.
Kesalahan pengetikan dapat dikoreksi menggunakan tombol Backspace (VHDL akan menyesuaikan posisi pengecekan secara otomatis).

6. Selesai & Lihat Hasil.
Setelah karakter terakhir diketik, tekan Enter untuk mengakhiri permainan.
Script python akan berhenti dan menampilkan statistik singkat.
Simulasi Vivado akan berhenti secara otomatis.

7. Hasil analisis lengkap akan tersimpan dalam dua file:
python_results.txt: Laporan statistik (WPM, CPM, Akurasi, Typo) dari sisi software (python).
output_report.txt: Log verifikasi karakter per karakter dari sisi hardware (VHDL).

### Struktur File Output
target_soal.txt: Soal yang dihasilkan oleh Python untuk dibaca oleh VHDL.
realtime_input.txt: Media komunikasi karakter antara Python dan VHDL.
python_results.txt: Laporan akhir performa pengetikan .
output_report.txt: Log debug dari sistem VHDL.
