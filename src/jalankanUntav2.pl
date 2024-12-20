/* Define Helper */

concateList(Element, [], [Element]).
concateList(Element, List, [Element | List]).

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

deleteUntil(Element, [], []).
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
    ; PosisiBaru is Posisi + Angka).

updateSourceStackUnta(_, _, []).
updateSourceStackUnta(UntaWhoMove, Source, ListOfUntaInSource) :-
    lastUntaColor(ListOfUntaInSource, LastUnta),
    unta(LastUnta, _, Stack),
    retract(unta(LastUnta, Source, Stack)),
    deleteUntil(UntaWhoMove, Stack, Result),
    asserta(unta(LastUnta, Source, Result)),
    (   LastUnta = UntaWhoMove ->
        true
    ; 
        deleteUntil(Element, Result, _)
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
    findall(UntaSource, unta(UntaSource, Source, _), ListUntainSource),
    findall(UntaInDestination, unta(UntaInDestination, Destination, _), ListUntainDest),
    retract(unta(UntaWhoMove, Source, Stack)),
    asserta(unta(UntaWhoMove, Destination, Stack)),
    concateList(UntaWhoMove, Stack, ConcatedStack),
    updateSourceStackUnta(UntaWhoMove, Source, ListUntainSource),
    updateStackDestination(ConcatedStack, Destination, ListUntainDest).

jalankanUntav2 :- 
    write('Jalankan unta\n'),
    currentPemain(NomorPemain),
    urutanPemain(UrutanPemain),
    getNameFromUrutanv2(UrutanPemain, NomorPemain, NamaPemain),
    pemain(NamaPemain, Poin, Trap, Action),
    (   Action = belum ->
        kocokDaduv2(Warna, Angka),
        format('Dadu warna: ~w, Dadu angka: ~d~n', [Warna, Angka]),
        unta(Warna, Posisi, Tumpuk),
        findPosisiMovev2(Warna, Posisi, Angka, PosisiBaru), 
        write('Jalankan unta\n'),
        moveSpesificUntaFromTile(Warna,Posisi, PosisiBaru),

        NewPoin is Poin + 10,
        retract(pemain(NamaPemain, Poin, Trap, Action)),
        asserta(pemain(NamaPemain, NewPoin, Trap, jalankan_unta)),
        format('Unta ~w berpindah ke petak ~d~n', [Warna, PosisiBaru])
    ;
        write('Gagal! Anda sudah melakukan aksi.'), nl
    ).