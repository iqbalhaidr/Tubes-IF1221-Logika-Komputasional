isUntaWinner([_, P1, T1], [_, P2, T2]) :-
    (P1 > P2) ; 
    (P1 == P2, length(T1, Len1), length(T2, Len2), Len1 < Len2).

insertSorted(Unta, [], [Unta]).
insertSorted(Unta, [Head|Tail], [Unta, Head|Tail]) :-
    isUntaWinner(Unta, Head).
insertSorted(Unta, [Head|Tail], [Head|NewTail]) :-
    \+ isUntaWinner(Unta, Head),
    insertSorted(Unta, Tail, NewTail).

insertionSort([], []).
insertionSort([Head|Tail], Sorted) :-
    insertionSort(Tail, SortedTail),
    insertSorted(Head, SortedTail, Sorted).

extractWarna([], []).
extractWarna([[Warna, _, _]|Tail], [Warna|Tail1]) :-
    extractWarna(Tail, Tail1).

hitungUrutanKemenangan :-
    findall([Warna, Posisi, Tumpuk], unta(Warna, Posisi, Tumpuk), List),
    insertionSort(List, SortedList),
    extractWarna(SortedList, ListWarna),
    [P1, P2, P3, P4, P5] = ListWarna,
    retractall(urutanUnta(_, _, _, _, _)),
    asserta(urutanUnta(P1, P2, P3, P4, P5)).

/* ======================================================================= */

find_index_of_element([Element|_], 0, Element).
find_index_of_element([_|Tail], Index, Element) :-
    find_index_of_element(Tail, I, Element),
    Index is I + 1.

deleteElementEndgame([_|Tail], 0, Tail).
deleteElementEndgame([Head|Tail], Index, [Head|UpdatedTail]) :-
    Index > 0,
    NewIndex is Index - 1,
    deleteElementEndgame(Tail, NewIndex, UpdatedTail).

listUrutanUntaTanpaPutih(ListFinal) :-
    urutanUnta(P1, P2, P3, P4, P5),
    ListTemp = [P1, P2, P3, P4, P5],
    find_index_of_element(ListTemp, Idx, 'Putih'),
    deleteElementEndgame(ListTemp, Idx, ListFinal).

poinUtama(1, 50).
poinUtama(2, 30).
poinUtama(3, 20).
poinUtama(4, 20).

cariInvestorKe1(WarnaUnta, NamaPemain) :-
    urutanInvestasi(WarnaUnta, [NamaPemain | _]).

updatePoinInvestor1([], _) :- !.
updatePoinInvestor1([Head|Tail], Pos) :-
    poinUtama(Pos, Poin),
    (cariInvestorKe1(Head, NamaPemain) -> tambahPoinEndgame(NamaPemain, Poin)
    ; true),
    Pos1 is Pos + 1,
    updatePoinInvestor1(Tail, Pos1).

updatePoinInvestor1 :-
    listUrutanUntaTanpaPutih(List),
    updatePoinInvestor1(List, 1).


cariInvestorKe2(WarnaUnta, NamaPemain) :-
    urutanInvestasi(WarnaUnta, [_, NamaPemain | _]).

updatePoinInvestor2([]) :- !.
updatePoinInvestor2([Head|Tail]) :-
    tambahPoinEndgame(Head, 10),
    updatePoinInvestor2(Tail).

updatePoinInvestor2 :-
    findall(NamaPemain, cariInvestorKe2(_, NamaPemain), List2),
    updatePoinInvestor2(List2).


cariInvestorKe3(WarnaUnta, NamaPemain) :-
    urutanInvestasi(WarnaUnta, [_, _, NamaPemain | _]).

updatePoinInvestor3([]) :- !.
updatePoinInvestor3([Head|Tail]) :-
    tambahPoinEndgame(Head, 5),
    updatePoinInvestor3(Tail).

updatePoinInvestor3 :-
    findall(NamaPemain, cariInvestorKe3(_, NamaPemain), List3),
    updatePoinInvestor3(List3).

/* Fungsi menghitung poin hasil investasi */
updatePoinInvestor :-
    updatePoinInvestor1,
    updatePoinInvestor2,
    updatePoinInvestor3.

/* ======================================================================= */

getPemain(Info) :-
    findall((Poin, Nama), pemain(Nama, Poin, _, _), Info).

maxPoin([Head|Tail], Max) :-
    maxPoin(Tail, Head, Max).

maxPoin([], Max, Max).
maxPoin([(Poin2, Nama2)|Tail], (Poin1, Nama1), Max) :-
    (Poin2 > Poin1 ->  maxPoin(Tail, (Poin2, Nama2), Max)
    ; maxPoin(Tail, (Poin1, Nama1), Max)).

pemainTertinggi(Nama, Poin) :-
    getPemain(Info),
    maxPoin(Info, (Poin, Nama)).

/* ======================================================================= */

winningMessage :-
    pemainTertinggi(NamaPemain, Poin),
    format('~nSelamat, ~w menang dengan ~d poin!', [NamaPemain, Poin]).

resetData :- 
    retractall(dadu(_)),
    retractall(ronde(_)),
    retractall(kartu(_, _)),
    retractall(unta(_, _, _)),
    retractall(jumlahPemain(_)),
    retractall(pemain(_, _, _, _)),
    retractall(urutanPemain(_)),
    retractall(urutanInvestasi(_, _)),
    retractall(urutanUnta(_, _, _, _, _)),
    retractall(trap(_, _, _)),
    retractall(currentPemain(_)).

/* ======================================================================= */

/* Main Function */
endgame :-
    hitungUrutanKemenangan,
    updatePoinInvestor,
    winningMessage,
    resetData.

/* ======================================================================= */

/* Helper Function */

tambahPoinEndgame(Pemain, Tambahan) :-
    pemain(Pemain, Poin, Trap, Action),
    Poin1 is Poin + Tambahan,
    retract(pemain(Pemain, Poin, Trap, Action)),
    asserta(pemain(Pemain, Poin1, Trap, Action)).

/* ======================================================================= */

/* Misc */

% :- dynamic(urutanUnta/5).
% :- dynamic(urutanInvestasi/2).
% :- dynamic(pemain/4).
% :- dynamic(unta/3).

% pemain('P1', 30, 1, 'Jalan').
% pemain('P2', 30, 3, 'Jalan').
% pemain('P3', 30, 0, 'Jalan').
% pemain('P4', 30, 2, 'Jalan').

% urutanInvestasi('Merah', ['P1']).
% urutanInvestasi('Kuning', []).
% urutanInvestasi('Hijau', []).
% urutanInvestasi('Biru', []).

% unta('Merah', 12, ['Kuning']).
% unta('Kuning', 12, []).
% unta('Hijau', 12, ['Merah', 'Kuning']).
% unta('Biru', 16, []). 
% unta('Putih', 8, []).
