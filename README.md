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
