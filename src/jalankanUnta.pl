get_element_unta([Element|_], 0, Element).
get_element_unta([_|Tail], Index, Element) :- 
    Index > 0,
    NewIndex is Index - 1,
    get_element_unta(Tail, NewIndex, Element).

random_member(Element, List):-
    length(List, Len),
    random(0, Len, Chosen),
    get_element_unta(List, Chosen, Element).

/* Mengocok Dadu */
kocokDadu(Warna, Angka) :-
    findall(W, dadu(W), DaduWarna), 
    random_member(Warna, DaduWarna), 
    random(1, 7, Angka), 
    retract(dadu(Warna)), 
    (DaduWarna == [Warna] -> 
        forall(member(W, ["Merah", "Kuning", "Hijau", "Biru", "Putih"]), asserta(dadu(W)))
    ;
        true).

getNameFromUrutan([Head|_], 1, Head) :- !.
getNameFromUrutan([_|Tail], Idx, Name) :-
    Idx1 is Idx-1,
    getNameFromUrutan(Tail, Idx1, Name).

/* Jalankan Unta */
jalankanUnta :-
    write('Jalankan unta\n'),
    currentPemain(NomorPemain),
    urutanPemain(UrutanPemain),
    getNameFromUrutan(UrutanPemain, NomorPemain, NamaPemain),
    pemain(NamaPemain, Poin, Trap, Action),
    ( Action == belum ->
        kocokDadu(Warna, Angka),
        format('Dadu warna: ~w, Dadu angka: ~d~n', [Warna, Angka]),
        unta(Warna, Posisi, Tumpuk),
        findPosisiMove(Warna, Posisi, Angka, PosisiBaru), 
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
        retract(pemain(NamaPemain, Poin, Trap, Action)),
        asserta(pemain(NamaPemain, NewPoin, Trap, jalankan_unta)),
        format('Unta ~w berpindah ke petak ~d~n', [Warna, PosisiBaru])
    ;
        write('Gagal! Anda sudah melakukan aksi.'), nl
    ).

/* Helper Function */
findPosisiMove(Warna, Posisi, Angka, PosisiBaru) :-
    (Warna == "Putih" -> 
        PosisiBaruTemp is Posisi - Angka,
        (PosisiBaruTemp < 1 ->
            PosisiBaru = 1
        ; PosisiBaru = PosisiBaruTemp)
    ; PosisiBaruTemp is Posisi + Angka,
        (PosisiBaruTemp > 16 ->
            PosisiBaru = 16
        ; PosisiBaru = PosisiBaruTemp)).

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
    format('Posisi sesudah unta ~w: ~d\n', [Warna2, Posisi1]).

