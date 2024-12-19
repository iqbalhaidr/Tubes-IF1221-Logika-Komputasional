/* Fakta statik */
/* poinInvestasi(UrutanUnta, UrutanInvestasi, Poin) */
poinInvestasi(1, 1, 50).
poinInvestasi(2, 1, 30).
poinInvestasi(3, 1, 20).
poinInvestasi(4, 1, 20).

poinInvestasi(1, 2, 10).
poinInvestasi(2, 2, 10).
poinInvestasi(3, 2, 10).
poinInvestasi(4, 2, 10).

poinInvestasi(1, 3, 5).
poinInvestasi(2, 3, 5).
poinInvestasi(3, 3, 5).
poinInvestasi(4, 3, 5).

poinInvestasi(1, 4, 0).
poinInvestasi(2, 4, 0).
poinInvestasi(3, 4, 0).
poinInvestasi(4, 4, 0).

/* Fakta dinamik */

/* dadu(Warna) */
/* dadu akan dihapus satu persatu setelah dikocok. Lalu saat sudah habis akan ditambahkan lagi */
dadu("Merah").
dadu("Kuning").
dadu("Hijau").
dadu("Biru").
dadu("Putih").

/* ronde(Jumlah) */
/* Jumlah akan diupdate setiap kali ronde selesai */
/* Satu ronde selesai ketika semua dadu habis */
ronde(1).

/* kartu(Warna, NamaPemain) */
/* Pada awalnya setiap pemain akan diberi 4 kartu berwarna */
:- dynamic(kartu/2).

/* unta(Warna, Posisi, Tumpuk) */
/* Warna : string, Posisi : integer, Tumpuk : List of WarnaUnta string */
/* Posisi unta pada awal game seperti berikut */
unta("Merah", 0, []).
unta("Kuning", 0, []).
unta("Hijau", 0, []).
unta("Biru", 0, []). 
unta("Putih", 16, []).

/* jumlahPemain(Jumlah) */
/* Jumlah : integer */
/* Jumlah pemain akan diinputkan oleh user */
:- dynamic(jumlahPemain/1).

/* pemain(Nama, Poin, Trap, Action) */
/* Nama : string, Poin : integer, Trap : integer, Action : string */
/* Poin memiliki nilai inisial */
/* Trap menyimpan jumlah trap yang dimiliki pemain */
/* Action akan diupdate setiap kali pemain melakukan aksi */
/* Jika belum melakukan aksi, Action = "Belum" */
:- dynamic(pemain/4).

/* urutanPemain(Urutan) */
/* Urutan : List of NamaPemain string */
:- dynamic(urutanPemain/1).

/* urutanInvestasi(WarnaUnta, Urutan) */
/* WarnaUnta : string, Urutan : List of NamaPemain string */
urutanInvestasi("Merah", []).
urutanInvestasi("Kuning", []).
urutanInvestasi("Hijau", []).
urutanInvestasi("Biru", []).

/* urutanUnta(Pertama, Kedua, Ketiga, Keempat, Kelima) */
/* Pertama, Kedua, Ketiga, Keempat, Kelima : WarnaUnta string */
/* Urutan unta pada awal game seperti berikut */
urutanUnta("Merah", "Kuning", "Hijau", "Biru", "Putih").

/* trap(KiriAtauKana, Posisi, Pemilik) */
/* KiriAtauKanan : string, Posisi : integer, Pemilik : NamaPemain string */

/* currentPemain(NomorPemain) */
/* Menunjukkan giliran pemain saat ini dengan NomorPemain 1-jumlahPemain */
:- dynamic(currentPemain/1).