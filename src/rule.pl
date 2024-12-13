:- include('./facts.pl').

/* Fungsi/Prosedur */
/* ======================================================================= */

inputJumlahPemain :-
    repeat,
    write('Masukkan jumlah pemain: '), read(Jumlah),
    (   Jumlah >= 2, Jumlah =< 4 ->
        asserta(jumlahPemain(Jumlah)), !
    ;
        write('Mohon masukkan angka antara 2 - 4.'), nl, fail
    ).

/* ======================================================================= */

isNamaUsed(Nama) :- pemain(Nama, _, _, _).

inputNamaPemain(Counter, JumlahPemain) :- Counter > JumlahPemain, !.
inputNamaPemain(Counter, JumlahPemain) :-
    format('Masukkan nama pemain ~d: ', [Counter]), read(Nama),
    (
    \+ isNamaUsed(Nama) ->
        asserta(pemain(Nama, 30, 1, belum)),
        CounterInc is Counter + 1,
        inputNamaPemain(CounterInc, JumlahPemain)
    ;
        write('Nama sudah terpakai.'), nl,
        inputNamaPemain(Counter, JumlahPemain)
    ).

inputNamaPemain :- 
    jumlahPemain(JumlahPemain),
    inputNamaPemain(1, JumlahPemain).

/* ======================================================================= */

getElmt([Head|_], 0, Head).
getElmt([_|Tail], Idx, Elmt) :-
    Idx1 is Idx-1,
    getElmt(Tail, Idx1, Elmt).

random_permutation([], []).
random_permutation(List, [Elmt|Rest]) :-
    length(List, Len),
    random(0, Len, Index),
    getElmt(List, Index, Elmt),
    select(Elmt, List, NewList),
    random_permutation(NewList, Rest).

generateUrutanPemain :-
    findall(Nama, pemain(Nama, _, _, _), ListNama),
    random_permutation(ListNama, RandomizedListNama),
    asserta(urutanPemain(RandomizedListNama)).

displayUrutanPemain([]).
displayUrutanPemain([Head]) :-
    write(Head), !.
displayUrutanPemain([Head|Tail]) :-
    write(Head), write(' - '),
    displayUrutanPemain(Tail).

displayUrutanPemain :- 
    urutanPemain(Urutan), 
    write('Urutan pemain: '),
    displayUrutanPemain(Urutan).

/* ======================================================================= */

inputKartuPemain([]).
inputKartuPemain([Head|Tail]) :-
    asserta(kartu(merah, Head)),
    asserta(kartu(kuning, Head)),
    asserta(kartu(hijau, Head)),
    asserta(kartu(biru, Head)),
    inputKartuPemain(Tail).

generateKartuPemain :-
    findall(Nama, pemain(Nama, _, _, _), ListNama),
    inputKartuPemain(ListNama).

displayKartuPemain :-
    findall(Nama, pemain(Nama, _, _, _), ListNama),
    displayKartuPemain(ListNama).

displayKartuPemain([]).
displayKartuPemain([Head|Tail]) :-
    format('Kartu ~w: .', [Head]),
    findall(Warna, kartu(Warna, Head), ListKartu),
    displayKartu(ListKartu), nl,
    displayKartuPemain(Tail).

displayKartu([]).
displayKartu([Card]) :-
    write(Card), !.
displayKartu([Card|Rest]) :-
    write(Card), write(', '),
    displayKartu(Rest).

/* ======================================================================= */

displayPoinPemain :-
    findall(Nama, pemain(Nama, _, _, _), ListNama),
    displayPoinPemain(ListNama).

displayPoinPemain([]).
displayPoinPemain([Head|Tail]) :-
    pemain(Head, Poin, _, _),
    format('Poin ~w: ~d.~n', [Head, Poin]),
    displayPoinPemain(Tail).

/* ======================================================================= */

displayTrapPemain :-
    findall(Nama, pemain(Nama, _, _, _), ListNama),
    displayTrapPemain(ListNama).

displayTrapPemain([]).
displayTrapPemain([Head|Tail]) :-
    pemain(Head, _, Trap, _),
    format('Trap ~w: ~d.~n', [Head, Trap]),
    displayTrapPemain(Tail).

/* ======================================================================= */

startGame :-
    inputJumlahPemain, nl,
    inputNamaPemain, nl,
    generateUrutanPemain,
    displayUrutanPemain, nl,
    nl, write('Setiap pemain mendapatkan 4 kartu, 30 poin dan 1 trap.'), nl,
    generateKartuPemain, nl,
    displayKartuPemain, nl,
    displayPoinPemain, nl,
    displayTrapPemain.