/* Validasi Trap */

/* Validasi trap != S/F/Invalid Petak/Bersebelahan/Pada lokasi sudah ada trap */
isTrapLocValid(Location, Check) :- 
    findall(Posisi, trap(_, Posisi, _), ListPosisi),
    isTrapLocValid(Location, Check, ListPosisi).

isTrapLocValid('S', false, _) :- !.
isTrapLocValid('F', false, _) :- !.
isTrapLocValid(Location, false, _) :-
    char_code(Location, Code),
    char_code('A', A),
    char_code('O', O),
    (Code < A ; Code > O), !.
isTrapLocValid(_, true, []) :- !.
isTrapLocValid(Location, Check, [Head|Tail]) :-
    converterLocToInt(Location, LOC),
    Diff is LOC - Head,
    (Diff =:= -1 -> Check = false
    ; Diff =:= 0 -> Check = false
    ; Diff =:= 1 -> Check = false
    ; isTrapLocValid(Location, Check1, Tail), Check = Check1).

/* Validasi jenis trap hanya 'maju'/'mundur' */
isJenisTrapValid(JenisTrap, Check) :-
    ((JenisTrap == 'maju' ; JenisTrap == 'mundur') -> Check = true
    ; Check = false).

/* Validasi pemain memiliki trap */
isPlayerHasTrap(NamaPemain, Check) :-
    pemain(NamaPemain, _, Trap, _),
    (Trap > 0 -> Check = true
    ; Check = false).

/* ================================================================================ */

/* Fungsi pembantu (diberi suffiks trap supaya tidak bentrok) */

failMessageTrap(NamaPemain) :-
    format('~nTrap gagal dipasang. ~nPastikan mempunyai trap, lokasi trap valid, dan jenis trap valid.~n~n', []),
    displaySisaTrap(NamaPemain).

successMessageTrap(NamaPemain) :-
    format('~nTrap berhasil dipasang. Unta yang mendarat pada petak tersebut akan maju 1 petak. ~n~w akan mendapatkan 10 poin ketika ada unta yang mendarat di petak tersebut.~n~n', [NamaPemain]),
    displaySisaTrap(NamaPemain).

displaySisaTrap(NamaPemain) :-
    pemain(NamaPemain, _, Trap, _),
    format('Sisa trap ~w: ~d.~n', [NamaPemain, Trap]).

getElmtTrap([Head|_], 0, Head).
getElmtTrap([_|Tail], Idx, Elmt) :-
    Idx1 is Idx-1,
    getElmtTrap(Tail, Idx1, Elmt).

converterLocToInt(Location, LocationInt) :-
    char_code('A', Acuan),
    char_code(Location, Temp),
    LocationInt is Temp - Acuan + 1.

/* ================================================================================ */

/* Fungsi Utama */

pasangTrap :-
    currentPemain(NomorPemain), urutanPemain(ListNomorPemain),
    Idx is NomorPemain-1,
    getElmtTrap(ListNomorPemain, Idx, NamaPemain),
    pemain(NamaPemain, Poin, Trap, Action),
    format('~nMasukkan kode petak (KAPITAL dengan kutip satu): ', []), read(Location),
    format('Masukan jenis trap (maju/mundur): ', []), read(JenisTrap),
    isTrapLocValid(Location, CheckLoc), isJenisTrapValid(JenisTrap, CheckJenis), isPlayerHasTrap(NamaPemain, CheckHas),
    
    ((CheckLoc, CheckJenis, CheckHas) -> 
        Trap1 is Trap - 1,
        converterLocToInt(Location, LocInt),
        retract(pemain(NamaPemain, Poin, Trap, Action)),
        asserta(pemain(NamaPemain, Poin, Trap1, Action)),
        asserta(trap(JenisTrap, LocInt, NamaPemain)),
        successMessageTrap(NamaPemain)
    ; failMessageTrap(NamaPemain)).

/* ================================================================================ */

/* Misc */

/* Fact for testing (error kalo dynamic nya di tulis di facts trus include ke sini) */ 
/*
pemain('iqbal1', 30, 1, 2).
pemain('iqbal2', 30, 3, 2).
pemain('iqbal3', 30, 0, 2).
pemain('iqbal4', 30, 0, 2).
trap('kiri', 1, 'iqbal1').
trap('kanan', 3, 'iqbal2').
currentPemain(1).
urutanPemain(['iqbal1', 'iqbal2', 'iqbal3', 'iqbal4']).
*/

/* Testing
isTrapLocValid('S', Check, []).
isTrapLocValid('S', Check, ['A', 'C']).
isTrapLocValid('F', Check, []).
isTrapLocValid('F', Check, ['A', 'C']).
isTrapLocValid('a', Check, ['A', 'C']).
isTrapLocValid('P', Check, ['A', 'C']).
isTrapLocValid('P', Check, []).
isTrapLocValid('D', Check, []).
isTrapLocValid('D', Check, ['C']).
isTrapLocValid('D', Check, ['A', 'F']).
isTrapLocValid('D', Check, ['D']).
isTrapLocValid('D', Check, ['A', 'O']).
isTrapLocValid(X, Check, ['A', 'C', 'E', 'G', 'I', 'K', 'M', 'O']).
isTrapLocValid('N', Check, ['A', 'C', 'E', 'G', 'I', 'K', 'M']).
isTrapLocValid('DZ', Check, ['A', 'F']). #Error

isJenisTrapValid('MAJU', Check).
isJenisTrapValid('MUNDUR', Check).
isJenisTrapValid('MaJu', Check).
isJenisTrapValid('muNDuR', Check).
isJenisTrapValid('maju', Check).
isJenisTrapValid('mundur', Check).

isPlayerHasTrap('iqbal1', Check).
isPlayerHasTrap('iqbal3', Check).

failMessageTrap('iqbal1').
successMessageTrap('iqbal1').
displaySisaTrap('iqbal1').
converterLocToInt('B', Loc).
converterLocToInt('O', Loc).
*/