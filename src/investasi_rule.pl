['src/facts.pl', 'src/rule.pl'].

/* Validate Input From User */
validasi_warna_kartu(Warna) :-
    kartu(Warna, _), !.  
validasi_warna_kartu(_) :-
    write('Silakan pilih warna yang valid (merah, kuning, hijau, biru).'), nl,
    fail. 

/* Validate Existence of User Kartu */
cek_kartu(Warna, Nama) :-
    kartu(Warna, Nama).

/* Use Kartu if exist */
pakai_kartu(Nama, Warna) :-
    format('Investasi berhasil! ~w telah berinvestasi pada unta ~w.~n', [Nama, Warna]),
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
papan_investasi:-
    tampilkan_investasi_table("Merah"),
    write('~n~n'),
    tampilkan_investasi_table("Kuning"),
    write('~n~n'),
    tampilkan_investasi_table("Hijau"),
    write('~n~n'),
    tampilkan_investasi_table("Biru"),
    write('~n~n').

/* Investation rule */
investasi:-
    currentPemain(Nama),
    write('Pilih warna unta untuk investasi (merah, kuning, hijau, biru): '),
    read(Warna),
    (   validasi_warna_kartu(Warna) ->
        (   cek_kartu(Warna, Nama) ->
            pakai_kartu(Nama, Warna),
            !, 
            tampilkan_investasi_table(Warna) 
        ;   gagal_pakai_kartu(Nama, Warna),
            !, 
            tampilkan_investasi_table(Warna)
        )
    ;   fail  
    ).





