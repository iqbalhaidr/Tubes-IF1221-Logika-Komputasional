# Tugas Besar IF1221 Logika Komputasional 2024/2025

### Kelompok K01-G15
| NIM      | Nama                      |
| -------- | ------------------------- |
| 13523041 | Hanif Kalyana Aditya      |
| 13523051 | Ferdinand Gabe Tua Sinaga |
| 13523063 | Syahrizal Bani Khairan    |
| 13523111 | Muhammad Iqbal Haidar     |

## CamelPOP!
CamelPop adalah permainan berbasis giliran yang menggabungkan strategi dan keberuntungan, pemain berlomba mengumpulkan poin terbanyak melalui berbagai aksi dan keputusan taktis. Permainan ini dimainkan oleh 2-4 pemain, masing-masing memulai dengan 30 poin, 4 kartu warna (merah, kuning, hijau, biru), dan 1 jebakan (trap). Pemain berinteraksi dengan papan permainan berbentuk grid 5x5 yang menjadi arena balapan untuk 5 unta berwarna. Setiap giliran, pemain dapat memilih satu aksi utama, seperti berinvestasi pada unta tertentu untuk memprediksi pemenang, menjalankan unta menggunakan hasil lemparan dadu warna dan angka, atau memasang jebakan untuk memengaruhi lawan dan mendapatkan poin tambahan. Permainan berakhir ketika satu unta melewati garis finis, dan poin akhir dihitung berdasarkan hasil investasi pemain dan posisi unta di akhir balapan.


## Menjalankan Program

_Di bawah ini adalah langkah menjalankan program pada terminal linux._
1. Clone repository
   ```sh
   git clone https://github.com/praktikum-if1221-logika-komputasional/praktikum-if1221-logika-komputasional-keos.git
   ```
2. Ganti direktori
   ```sh
   cd ./src
   ```
3. Jalankan GNU Prolog
   ```sh
   gprolog
   ```
4. Jalankan program
   ```sh
   | ?- ['main.pl'].
   ```
   
## Fitur

* startGame (Inisialisasi)
* cek_map
* cek_info
* investasi
* papan_investasi
* jalankanUnta
* pasangTrap
* nextTurn
* godsHand
