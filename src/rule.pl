

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
/* Reset Semua Data */
resetGameData :-
    /* Reset fakta dadu */
    retractall(dadu(_)),
    asserta(dadu("Merah")),
    asserta(dadu("Kuning")),
    asserta(dadu("Hijau")),
    asserta(dadu("Biru")),
    asserta(dadu("Putih")),

    /* Reset ronde */
    retractall(ronde(_)),
    asserta(ronde(1)),

    /* Reset kartu */
    retractall(kartu(_, _)),

    /* Reset unta */
    retractall(unta(_, _, _)),
    asserta(unta("Merah", 0, [])),
    asserta(unta("Kuning", 0, [])),
    asserta(unta("Hijau", 0, [])),
    asserta(unta("Biru", 0, [])),
    asserta(unta("Putih", 16, [])),

    /* Reset pemain dan urutan */
    retractall(jumlahPemain(_)),
    retractall(pemain(_, _, _, _)),
    retractall(urutanPemain(_)),

    /* Reset investasi dan trap */
    retractall(urutanInvestasi(_, _)),
    asserta(urutanInvestasi(merah, [])),
    asserta(urutanInvestasi(kuning, [])),
    asserta(urutanInvestasi(hijau, [])),
    asserta(urutanInvestasi(biru, [])),
    retractall(urutanUnta(_, _, _, _, _)),
    retractall(trap(_, _, _)),
    
    retractall(currentPemain(_)).

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

mySelect(Elem, [Elem|Tail], Tail).
mySelect(Elem, [Head|Tail], [Head|Result]) :-
    Elem \= Head,
    mySelect(Elem, Tail, Result).

random_permutation([], []).
random_permutation(List, [Elmt|Rest]) :-
    length(List, Len),
    random(0, Len, Index),
    getElmt(List, Index, Elmt),
    mySelect(Elmt, List, NewList),
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
    assertz(kartu(merah, Head)),
    assertz(kartu(kuning, Head)),
    assertz(kartu(hijau, Head)),
    assertz(kartu(biru, Head)),
    inputKartuPemain(Tail).

generateKartuPemain :-
    findall(Nama, pemain(Nama, _, _, _), ListNama),
    inputKartuPemain(ListNama).

displayKartuPemain :-
    findall(Nama, pemain(Nama, _, _, _), ListNama),
    displayKartuPemain(ListNama).

displayKartuPemain([]).
displayKartuPemain([Head|Tail]) :-
    format('Kartu ~w: ', [Head]),
    findall(Warna, kartu(Warna, Head), ListKartu),
    displayKartu(ListKartu), nl,
    displayKartuPemain(Tail).

displayKartu([]).
displayKartu([Card]) :-
    format('~w.', [Card]), !.
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
    resetGameData,
    inputJumlahPemain, nl,
    inputNamaPemain, nl,
    generateUrutanPemain,
    displayUrutanPemain, nl,
    nl, write('Setiap pemain mendapatkan 4 kartu, 30 poin dan 1 trap.'), nl,
    generateKartuPemain, nl,
    displayKartuPemain, nl,
    displayPoinPemain, nl,
    displayTrapPemain,
    asserta(currentPemain(1)).
