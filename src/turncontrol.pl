revertAction :-
    pemain(Nama, Poin, Trap, Action),
    retract(pemain(Nama, Poin, Trap, Action)),
    asserta(pemain(Nama, Poin, Trap, belum)),
    fail.
revertAction.


/* Fungsi untuk melanjutkan ke giliran berikutnya */
nextTurn :-
    jumlahPemain(Jumlah),
    currentPemain(Current),
    Next is (Current mod Jumlah) + 1,
    retract(currentPemain(Current)),
    asserta(currentPemain(Next)),
    ( Next =:= 1 -> 
        retract(ronde(Round)),
        NewRound is Round + 1,
        asserta(ronde(NewRound)),

        revertAction
    ;
        nl
    ),
    ( unta(Warna, 16, _), Warna \= "Putih" -> 
        write('Ada unta yang sampai di petak terakhir! Game akan berakhir.'), nl, nl,
        endgame
    ;
        write('Giliran pemain berikutnya...'), nl
    ).