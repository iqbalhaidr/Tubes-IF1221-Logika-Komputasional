
/* Validate Input From User */
validasi_warna_kartu(Warna) :-
    kartu(Warna, _), !.  
validasi_warna_kartu(Warna) :-
    format('Gagal! ~w bukan warna unta yang valid.', [Warna]), nl,
    write('Silakan pilih warna yang valid (merah, kuning, hijau, biru).'), nl,
    fail. 

/* Mengambil Element berdasarkan Index */
get_element([Element|_], 0, Element).
get_element([_|Tail], Index, Element) :- 
    Index > 0,
    NewIndex is Index - 1,
    get_element(Tail, NewIndex, Element).

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
    write('Papan investasi pada unta merah'), nl,
    tampilkan_investasi_table(merah), 
    nl,                         
    write('Papan investasi pada unta kuning'), nl,       
    tampilkan_investasi_table(kuning),  
    nl,            
    write('Papan investasi pada unta hijau'), nl,                      
    tampilkan_investasi_table(hijau),  
    nl,                 
    write('Papan investasi pada unta biru'), nl,                 
    tampilkan_investasi_table(biru), 
    nl.    

/* Investation rule */
investasi:-
    currentPemain(NomorPemain),
    urutanPemain(ListOfUrutan),
    Index is NomorPemain-1,
    get_element(ListOfUrutan, Index, Nama),
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





