
/* Validate Input From User */
validasi_warna_kartu(Warna) :-
    kartu(Warna, _), !.  
validasi_warna_kartu(_) :-
    write('Gagal! putih bukan warna unta yang valid.'), nl,
    write('Silakan pilih warna yang valid (merah, kuning, hijau, biru).'), nl,
    fail. 

/* Validate Existence of User Kartu */
cek_kartu(Warna, Nama) :-
    kartu(Warna, Nama).

/* Use Kartu if exist */
pakai_kartu(Nama, Warna) :-
    format('Investasi berhasil! ~w telah berinvestasi pada unta ~w.~n', [Nama, Warna]),
    urutanInvestasi(Warna, List),
    append(List, [Nama], ListBaru),
    retract(urutanInvestasi(Warna, List)),
    assertz(urutanInvestasi(Warna, ListBaru)),
    retract(kartu(Warna, Nama)).

gagal_pakai_kartu(Nama, Warna) :-
    format('Gagal! ~w sudah berinvestasi pada unta ~w sebelumnya.~n', [Nama, Warna]).

/* Helper Display papan_investasi */
print_investor_name([], _) :-
    write('Belum ada Investasi.'), nl.
print_investor_name([Nama], Nomor) :-
    format('~w. ~w~n', [Nomor, Nama]).
print_investor_name([Head | Tail], Nomor) :-
    format('~w. ~w~n', [Nomor, Head]), 
    NomorBaru is Nomor + 1,          
    print_investor_name(Tail, NomorBaru).

tampilkan_investasi(Warna) :-
    urutanInvestasi(Warna, ListOfNama),
    print_investor_name(ListOfNama, 1).

/* Display one papan_investasi */
tampilkan_investasi_table(Warna) :-
    write('+---------------------+'), nl,
    write('|   INVESTASI UNTA    |'), nl,
    write('+---------------------+'), nl,
    tampilkan_investasi(Warna).

/* Display All papan_investasi */
papan_investasi :-
    tampilkan_investasi_table(merah), 
    nl,                                
    tampilkan_investasi_table(kuning),  
    nl,                                  
    tampilkan_investasi_table(hijau),  
    nl,                                  
    tampilkan_investasi_table(biru), 
    nl.    

/* Investation rule */
investasi:-
    currentPemain(NomorPemain),
    urutanPemain(ListOfUrutan),
    Index is NomorPemain-1,
    nth0(Index, ListOfUrutan, Nama),
    pemain(Nama, Poin, Trap, Action),
    ( Action = belum ->
        write('Pilih warna unta untuk investasi (merah, kuning, hijau, biru): '),
        read(Warna),
        (   validasi_warna_kartu(Warna) ->
            (   cek_kartu(Warna, Nama) ->
                pakai_kartu(Nama, Warna),
                retract(pemain(Nama, Poin, Trap, Action)),
                asserta(pemain(Nama, Poin, Trap, investasi)),
                !, 
                tampilkan_investasi_table(Warna) 
            ;   
                gagal_pakai_kartu(Nama, Warna),
                !, 
                tampilkan_investasi_table(Warna)
            )
        ;   
            fail  
        )
    ;
        write('Gagal! Anda sudah melakukan aksi.'), nl
    ).





