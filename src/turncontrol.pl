
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
        asserta(ronde(NewRound))
    ),
    ( unta(_, 16, _) -> 
        write('Ada unta yang sampai di petak terakhir! Game akan berakhir.'), nl, nl,
        endgame
    ;
        format('Giliran pemain berikutnya: ~d~n', [Next])
    ).