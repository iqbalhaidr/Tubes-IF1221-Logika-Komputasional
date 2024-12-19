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

/* Fungsi untuk melanjutkan ke giliran berikutnya */
nextTurn :-
    jumlahPemain(Jumlah),
    currentPemain(Current),
    Next is (Current mod Jumlah) + 1,
    retract(currentPemain(Current)),
    asserta(currentPemain(Next)),
    format('Giliran pemain berikutnya: ~d~n', [Next]).
