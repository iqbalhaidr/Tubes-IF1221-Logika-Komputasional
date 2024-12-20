godhand :-
    random(1, 101, Roll), % Generate angka acak 1-100
    (   Roll =< 30 -> 
        write('TUHAN TELAH BERSABDA BERSIAPLAH KALIAN!!'), nl,
        pilih_asal(Asal), 
        (   ada_unta_di_petak(Asal, DaftarUnta), length(DaftarUnta, L), L \= 0 -> 
            random_tujuan(Asal, 16, Tujuan),
            intToStrGod(Asal, HAsal), intToStrGod(Tujuan, HTujuan),
            (Tujuan == 0 -> 
                format('Tuhan memindahkan unta dari petak ~w ke ~s.~n', [HAsal, HTujuan])
            ; format('Tuhan memindahkan unta dari petak ~w ke ~w.~n', [HAsal, HTujuan])),
            pindahkan_unta(Asal, Tujuan),
            cek_map
        ;
            write('Tuhan mengurungkan niatnya karena tidak ada unta di petak '), write(Asal), nl
        )
    ;
        write('God\'s Hand tidak terjadi kali ini.'), nl
    )
    .

intToStrGod(Angka, Huruf) :-
    (Angka == 0 -> Huruf = "Start"
    ; HurufCode is Angka + 64, char_code(Huruf, HurufCode)).

pilih_asal(Asal) :-
    random(0, 16, Asal). 


random_tujuan(Asal,Max, Tujuan) :-
    repeat,
    random(0, Max , Kandidat),
    Kandidat \= Asal,             
    Tujuan = Kandidat, !.


ada_unta_di_petak(Asal, DaftarUnta) :-
    findall(Warna, unta(Warna,Asal,_),DaftarUnta).


delete_element([_|Tail], 0, Tail).
delete_element([Head|Tail], Index, [Head|UpdatedTail]) :-
    Index > 0,
    NewIndex is Index - 1,
    delete_element(Tail, NewIndex, UpdatedTail).

append_element(List, Element, NewList) :- 
    append(List, [Element], NewList).

get_length(List, Length) :-
    length(List, Length).

delete_last([], []).
delete_last(List, UpdatedList) :-
    get_length(List, Length),                
    Index is Length - 1,                   
    delete_element(List, Index, UpdatedList).

get_last([X], X).  
get_last([_|Tail], Last) :- 
    get_last(Tail, Last).

get_deleted_unta([],[]).
get_deleted_unta([Head | Tail], Deleted) :-
    unta(Head, _, DaftarTumpuk),
    (   length(DaftarTumpuk, L), L == 0 ->  
        Deleted = Head
    ;
        get_deleted_unta(Tail, Deleted)  
    ).

helper_hapus_unta_teratas([], _).
helper_hapus_unta_teratas([Head | Tail], Asal) :-
    unta(Head, _, DaftarTumpuk),
    delete_last(DaftarTumpuk, UpdatedTumpukan), 
    retract(unta(Head, _, DaftarTumpuk)),       
    assertz(unta(Head, Asal, UpdatedTumpukan)),
    helper_hapus_unta_teratas(Tail, Asal).


hapus_unta_teratas(Asal, Deleted_unta) :-
    ada_unta_di_petak(Asal, DaftarUnta),
    get_deleted_unta(DaftarUnta, Deleted_unta),
    helper_hapus_unta_teratas(DaftarUnta, Asal).


update_unta_in_dest(_, [], _).
update_unta_in_dest(Tujuan, [Head | Tail], Deleted_unta) :-
    unta(Head, _, DaftarTumpuk),
    append(DaftarTumpuk, [Deleted_unta], UpdatedTumpukan), 
    retract(unta(Head, _, DaftarTumpuk)),       
    assertz(unta(Head, Tujuan, UpdatedTumpukan)), 
    update_unta_in_dest(Tujuan, Tail, Deleted_unta).


pindahkan_unta(Asal, Tujuan) :-
    hapus_unta_teratas(Asal, Deleted_unta), 
    retract(unta(Deleted_unta, _, _)),       
    (   ada_unta_di_petak(Tujuan, DaftarUnta),
        length(DaftarUnta, L),
        L \= 0 ->  
        update_unta_in_dest(Tujuan, DaftarUnta, Deleted_unta),
        assertz(unta(Deleted_unta, Tujuan, []))
    ;
        assertz(unta(Deleted_unta, Tujuan, []))
    ).




    
