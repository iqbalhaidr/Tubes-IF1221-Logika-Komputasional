display_kartu_pemain(Nama) :-
    findall(Warna, kartu(Warna, Nama), ListKartu),
    display_kartu_pemain_list(ListKartu).

display_kartu_pemain_list([]) :-
    write('Tidak ada kartu.'), nl.
display_kartu_pemain_list([Card]) :-
    write(Card), nl.
display_kartu_pemain_list([Head|Tail]) :-
    write(Head), write(', '),
    display_kartu_pemain_list(Tail).



cek_info :-
    write('Masukkan nama pemain: '),
    read(Nama),
    ( pemain(Nama, Poin, Trap, Action) ->
        write('Pemain '), write(Nama), nl,
        write('Poin  : '), write(Poin), nl,
        write('Kartu : '), display_kartu_pemain(Nama),
        write('Trap  : '), write(Trap), nl
    ;
        write('Nama pemain tidak ditemukan.'), 
        nl
    ).