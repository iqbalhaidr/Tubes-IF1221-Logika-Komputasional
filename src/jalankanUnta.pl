/* Mengocok Dadu */
kocokDadu(Warna, Angka) :-
    findall(W, dadu(W), DaduWarna), 
    random_member(Warna, DaduWarna), 
    random_between(1, 6, Angka), 
    retract(dadu(Warna)), 
    (DaduWarna = [Warna] -> 
        forall(member(W, ["Merah", "Kuning", "Hijau", "Biru", "Putih"]), asserta(dadu(W)))
    ;
        true).

/* Jalankan Unta */
jalankanUnta :-
    currentPemain(NomorPemain),
    pemain(NamaPemain, Poin, Trap, _),
    kocokDadu(Warna, Angka),
    format('Dadu warna: ~w, Dadu angka: ~d~n', [Warna, Angka]),
    unta(Warna, Posisi, Tumpuk),
    PosisiBaru is Posisi + Angka, 
    retract(unta(Warna, Posisi, Tumpuk)), 
    findall(UntaDiPetak, unta(_, PosisiBaru, UntaDiPetak), TumpukanBaru),
    (TumpukanBaru = [] ->
        asserta(unta(Warna, PosisiBaru, Tumpuk)) 
    ;
        TumpukanBaru = [TumpukanPetakBaru],
        append(TumpukanPetakBaru, [Warna|Tumpuk], TumpukanFinal),
        asserta(unta(Warna, PosisiBaru, TumpukanFinal)) 
    ),
    NewPoin is Poin + 10,
    retract(pemain(NamaPemain, Poin, Trap, _)),
    asserta(pemain(NamaPemain, NewPoin, Trap, jalankan_unta)),
    format('Unta ~w berpindah ke petak ~d~n', [Warna, PosisiBaru]),
    nextTurn. 

/* Tukar Unta */
tukarUnta :-
    kocokDadu(Warna1, _), % Gunakan kocokDadu untuk memilih warna pertama
    kocokDadu(Warna2, _), % Gunakan kocokDadu untuk memilih warna kedua
    Warna1 \= Warna2, % Pastikan dua warna tidak sama
    unta(Warna1, Posisi1, Tumpuk1),
    unta(Warna2, Posisi2, Tumpuk2),
    format('Kocok dadu...\nWarna unta 1: ~w\nWarna unta 2: ~w\n', [Warna1, Warna2]),
    format('Posisi sebelum unta ~w: ~d\n', [Warna1, Posisi1]),
    format('Posisi sebelum unta ~w: ~d\n', [Warna2, Posisi2]),

    % Tukar posisi dan tumpukan unta
    retract(unta(Warna1, Posisi1, Tumpuk1)),
    retract(unta(Warna2, Posisi2, Tumpuk2)),
    asserta(unta(Warna1, Posisi2, Tumpuk1)),
    asserta(unta(Warna2, Posisi1, Tumpuk2)),

    format('Unta ~w dan ~w bertukar posisi...\n', [Warna1, Warna2]),
    format('Posisi sesudah unta ~w: ~d\n', [Warna1, Posisi2]),
    format('Posisi sesudah unta ~w: ~d\n', [Warna2, Posisi1]),
    nextTurn.

/* Fungsi untuk melanjutkan ke giliran berikutnya */
nextTurn :-
    jumlahPemain(Jumlah),
    currentPemain(Current),
    Next is (Current mod Jumlah) + 1,
    retract(currentPemain(Current)),
    asserta(currentPemain(Next)),
    format('Giliran pemain berikutnya: ~d~n', [Next]).
