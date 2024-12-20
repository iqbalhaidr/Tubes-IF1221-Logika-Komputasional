/* Define Helper */

concateList([], List2, List2).
concateList([H|T], List2, Result) :-
    append([H], R, Result),
    concateList(T, List2, R).

getLength(List, Length) :-
    length(List, Length).

deleteElem([_|Tail], 0, Tail).
deleteElem([Head|Tail], Index, [Head|UpdatedTail]) :-
    Index > 0,
    NewIndex is Index - 1,
    deleteElem(Tail, NewIndex, UpdatedTail).

deleteLastUnta([], []).
deleteLastUnta(List, UpdatedList) :-
    getLength(List, Length),
    Index is Length - 1,
    deleteElem(List, Index, UpdatedList).

lastUntaColor([X], X).
lastUntaColor([_|Tail], Last) :-
    lastUntaColor(Tail, Last).

deleteUntil(_, [], []).
deleteUntil(_, [], []).
deleteUntil(Element, List, Result) :-
    lastUntaColor(List, Color),
    deleteLastUnta(List, DeletedLastList),
    (   Color = Element ->
        Result = DeletedLastList
    ; 
        deleteUntil(Element, DeletedLastList, Result)
    ).

kocokDaduv2(Warna, Angka) :-
    findall(W, dadu(W), DaduWarna),
    randomizeMember(Warna, DaduWarna),
    length(DaduWarna, BanyakElem),
    Elem is BanyakElem + 1,
    random(1, Elem, Angka),
    retract(dadu(Warna)),
    (   DaduWarna = [Warna] ->
        forall(member(W, ["Merah", "Kuning", "Hijau", "Biru", "Putih"]), 
               asserta(dadu(W)))
    ;
        true
    ).

getUnta([Element|_], 0, Element).
getUnta([_|Tail], Index, Element) :- 
    Index > 0,
    NewIndex is Index - 1,
    getUnta(Tail, NewIndex, Element).

randomizeMember(Element, List) :-
    length(List, BanyakElem),
    random(0, BanyakElem, Chosen),
    getUnta(List, Chosen, Element).

getNameFromUrutanv2([Head|_], 1, Head) :- !.
getNameFromUrutanv2([_|Tail], Idx, Name) :-
    Idx1 is Idx-1,
    getNameFromUrutanv2(Tail, Idx1, Name).

findPosisiMovev2(Warna, Posisi, Angka, PosisiBaru) :-
    (Warna == "Putih" -> 
        PosisiBaruTemp is Posisi - Angka,
        (PosisiBaruTemp < 1 ->
            PosisiBaru = 1
        ; PosisiBaru = PosisiBaruTemp)
    ; PosisiBaruTemp is Posisi + Angka,
        (PosisiBaruTemp > 16 ->
            PosisiBaru = 16
        ; PosisiBaru = PosisiBaruTemp)).

updateChildStackMovedUnta([],_).
updateChildStackMovedUnta(StackInUntaWhoMove, Dest):-
    lastUntaColor(StackInUntaWhoMove, LastUnta),
    deleteLastUnta(StackInUntaWhoMove, DeletedLis),
    retract(unta(LastUnta,_,Stack)),
    asserta(unta(LastUnta,Dest, Stack)),
    updateChildStackMovedUnta(DeletedLis, Dest).

updateSourceStackUnta(_, _, []).
updateSourceStackUnta(UntaWhoMove, Source, ListOfUntaInSource) :-
    lastUntaColor(ListOfUntaInSource, LastUnta),
    deleteLastUnta(ListOfUntaInSource, _),
    unta(LastUnta, _, Stack),
    retract(unta(LastUnta, Source, Stack)),
    deleteUntil(UntaWhoMove, Stack, Result),
    asserta(unta(LastUnta, Source, Result)),
    (   LastUnta = UntaWhoMove ->
        true
    ; 
        updateSourceStackUnta(UntaWhoMove, Source, _)
    ).

updateStackDestination(_, _, []).
updateStackDestination(ConcatenatedUntaWhoMove, Destination, ListOfUntaInDestination) :-
    lastUntaColor(ListOfUntaInDestination, LastUnta),
    deleteLastUnta(ListOfUntaInDestination, Res),
    retract(unta(LastUnta, _, Stack)),
    concateList(Stack, ConcatenatedUntaWhoMove, NewStack),
    asserta(unta(LastUnta, Destination, NewStack)),
    updateStackDestination(ConcatenatedUntaWhoMove, Destination, Res).

moveSpesificUntaFromTile(UntaWhoMove, Source, Destination) :-
    retract(unta(UntaWhoMove, Source, Stack)),
    findall(UntaSource, unta(UntaSource, Source, _), ListUntainSource),
    findall(UntaInDestination, unta(UntaInDestination, Destination, _), ListUntainDest),
    asserta(unta(UntaWhoMove, Destination, Stack)),
    concateList([UntaWhoMove], Stack, ConcatedStack),
    updateSourceStackUnta(UntaWhoMove, Source, ListUntainSource),
    updateStackDestination(ConcatedStack, Destination, ListUntainDest),
    updateChildStackMovedUnta(Stack,Destination).

/* Helper Function */

tambahPoinJalankan(Pemain, Tambahan) :-
    pemain(Pemain, Poin, Trap, Action),
    Poin1 is Poin + Tambahan,
    retract(pemain(Pemain, Poin, Trap, Action)),
    asserta(pemain(Pemain, Poin1, Trap, Action)).

isKenaTrap(PosisiBaru, PosisiFinal) :-
    (trap(Jenis, PosisiBaru, Pemilik) -> 
        format('~nTIDAAK, unta terkena trap. Unta ~a 1 langkah~n', [Jenis]),
        tambahPoinJalankan(Pemilik, 10),
        retract(trap(Jenis, PosisiBaru, Pemilik)),
        (Jenis == maju -> 
            PosisiFinal is PosisiBaru + 1
        ; PosisiFinal is PosisiBaru - 1)
    ; PosisiFinal = PosisiBaru).

intToStrJalankan(Angka, Huruf) :-
    (Angka == 0 -> Huruf = "Start"
    ; HurufCode is Angka + 64, char_code(Huruf, HurufCode)).

jalankanUnta :- 
    write('Jalankan unta\n'),
    currentPemain(NomorPemain),
    urutanPemain(UrutanPemain),
    getNameFromUrutanv2(UrutanPemain, NomorPemain, NamaPemain),
    pemain(NamaPemain, Poin, Trap, Action),
    (   Action = belum ->
        kocokDaduv2(Warna, Angka),
        format('Dadu warna: ~s, Dadu angka: ~d', [Warna, Angka]),
        unta(Warna, Posisi, _),
        findPosisiMovev2(Warna, Posisi, Angka, PosisiBaru), nl,
        isKenaTrap(PosisiBaru, PosisiFinal),
        moveSpesificUntaFromTile(Warna,Posisi, PosisiFinal),

        NewPoin is Poin + 10,
        retract(pemain(NamaPemain, Poin, Trap, Action)),
        asserta(pemain(NamaPemain, NewPoin, Trap, jalankan_unta)),
        intToStrJalankan(PosisiFinal, HurufFinal),
        format('~nUnta ~s berpindah ke petak ~w~n', [Warna, HurufFinal])
    ;
        write('Gagal! Anda sudah melakukan aksi.'), nl
    ).
