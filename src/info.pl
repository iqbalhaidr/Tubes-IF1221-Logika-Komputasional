/* ======================================================================= */
/*                                 Info                                    */
/* ======================================================================= */
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
    ( pemain(Nama, Poin, Trap, _) ->
        write('Pemain '), write(Nama), nl,
        write('Poin  : '), write(Poin), nl,
        write('Kartu : '), display_kartu_pemain(Nama),
        write('Trap  : '), write(Trap), nl
    ;
        write('Nama pemain tidak ditemukan.'), 
        nl
    ).

/* ======================================================================= */
/*                                  Map                                    */
/* ======================================================================= */
/* write formatter */


write_centered(Text, Width) :-
    atom_length(Text, TextLength),
    Padding is (Width - TextLength) // 2,
    write_padding(Padding),
    write(Text),
    write_padding(Padding),
    % If the total width is odd, add one more space to the right
    ( (Width - TextLength) mod 2 =:= 1 -> write(' ') ; true ).

write_padding(0).
write_padding(N) :-
    N > 0,
    write(' '),
    NextN is N - 1,
    write_padding(NextN).

display_map_horizontal_edge(0) :-
    write('+').
display_map_horizontal_edge(TileNumber) :-
    TileNumber > 0,
    write('+-------------------------'),
    NextTileNumber is TileNumber - 1,
    display_map_horizontal_edge(NextTileNumber).


display_line_tile([Head]) :-
    write('|'),
    write_centered(Head, 25),
    write('|').
display_line_tile([Head|Tail]) :-
    write('|'),
    write_centered(Head, 25),
    display_line_tile(Tail).

/* ======================================================================= */
/* Unta per tile */

parse_unta(String, Res) :-
    (String = "Merah" ->
        Res = 'UM'
    ; String = "Kuning" ->
        Res = 'UK'
    ; String = "Hijau" ->
        Res = 'UH'
    ; String = "Biru" ->
        Res = 'UB'
    ; String = "Putih" -> 
        Res = 'UP'
    ).

format_tumpukan([], ['[ ]']) :- !.
format_tumpukan([Head], [HeadRes]) :-
    parse_unta(Head, HeadRes), !.
format_tumpukan([Head|Tail], [HeadRes|TailRes]) :-
    parse_unta(Head, HeadRes),
    format_tumpukan(Tail, TailRes).

stringify_tumpukan([], ['[ ]']) :- !.
stringify_tumpukan([Head], Res) :-
    atom_concat(Head, '', Res), !.
stringify_tumpukan([Head|Tail], Res) :-
    stringify_tumpukan(Tail, TailRes),
    atom_concat(Head, ' ', ResTemp),
    atom_concat(ResTemp, TailRes, Res).

get_unta_in_tile(Pos, Res) :-
    ( once(unta(_, Pos, Tumpukan)) -> 
        format_tumpukan(Tumpukan, TumpukanRes),
        stringify_tumpukan(TumpukanRes, Res)
    ;
        Res = '[ ]'
    ), !.

get_unta([Head], [HeadRes]) :-
    get_unta_in_tile(Head, HeadRes), !.
get_unta([Head|Tail], [HeadRes|TailRes]) :-
    get_unta_in_tile(Head, HeadRes),
    get_unta(Tail, TailRes).

/* ======================================================================= */
/* Trap per tile */

find_trap_pos(Res) :-
    findall(Pos, trap(_, Pos, _), Res).

get_trap_in_tile(Pos, Res) :-
    ( trap(Dir, Pos, _) -> 
        ( (Dir = 'maju', Pos < 8) -> 
            Res = ('>>>')
        ; (Dir = 'maju', Pos >= 8) ->
            Res = ('<<<')
        ; (Dir = 'mundur', Pos < 8) ->
            Res = ('<<<')
        ; (Dir = 'mundur', Pos >= 8) ->
            Res = ('>>>')
        )
    ;
        Res = ' '
    ).

get_trap([Head], [HeadRes]) :-
    get_trap_in_tile(Head, HeadRes), !.
get_trap([Head|Tail], [HeadRes|TailRes]) :-
    get_trap_in_tile(Head, HeadRes),
    get_trap(Tail, TailRes).

/* ======================================================================= */

cek_map :-
    % Trap testing purpose
    % asserta(trap('maju', 0, 1)),
    % asserta(trap('mundur', 2, 2)),
    % asserta(trap('maju', 10, 3)),
    % asserta(trap('mundur', 12, 4)),

    get_unta([0, 1, 2, 3, 4], UntaBarisPertama),
    get_unta([12, 11, 10, 9, 8], UntaBarisTerakhir),
    get_unta([15], UntaO),
    get_unta([5], UntaE),
    get_unta([14], UntaN),
    get_unta([6], UntaF),
    get_unta([13], UntaM),
    get_unta([7], UntaG),

    get_trap([0, 1, 2, 3, 4], TrapBarisPertama),
    get_trap([12, 11, 10, 9, 8], TrapBarisTerakhir),
    get_trap([15], TrapO),
    get_trap([5], TrapE),
    get_trap([14], TrapN),
    get_trap([6], TrapF),
    get_trap([13], TrapM),
    get_trap([7], TrapG),
    (trap(_, _, _) -> 
        write('Beware of the traps!'), nl
    ; 
        write('Check it out'), nl
    ),

    display_map_horizontal_edge(5), nl,
    display_line_tile(['S/F', 'A', 'B', 'C', 'D']), nl,
    display_line_tile(UntaBarisPertama), nl,
    display_line_tile(TrapBarisPertama), nl,
    display_map_horizontal_edge(5), nl,

    display_line_tile(['O']),
    write_centered('|', 77),
    display_line_tile(['E']), nl,
    display_line_tile(UntaO),
    write_centered('|', 77),
    display_line_tile(UntaE), nl,
    display_line_tile(TrapO),
    write_centered('|', 77),
    display_line_tile(TrapE), nl,
    display_map_horizontal_edge(1),
    write_centered('|', 77),
    display_map_horizontal_edge(1), nl,
    
    display_line_tile(['N']),
    write_centered(' ', 77),
    display_line_tile(['F']), nl,
    display_line_tile(UntaN),
    write_centered('-------------------------+------ CAMEL POP! -------+-------------------------', 77),
    display_line_tile(UntaF), nl,
    display_line_tile(TrapN),
    write_centered(' ', 77),
    display_line_tile(TrapF), nl,
    display_map_horizontal_edge(1),
    write_centered('|', 77),
    display_map_horizontal_edge(1), nl,

    display_line_tile(['M']),
    write_centered('|', 77),
    display_line_tile(['G']), nl,
    display_line_tile(UntaM),
    write_centered('|', 77),
    display_line_tile(UntaG), nl,
    display_line_tile(TrapM),
    write_centered('|', 77),
    display_line_tile(TrapG), nl,
    display_map_horizontal_edge(5), nl,

    display_line_tile(['L', 'K', 'J', 'I', 'H']), nl,
    display_line_tile(UntaBarisTerakhir), nl,
    display_line_tile(TrapBarisTerakhir), nl,
    display_map_horizontal_edge(5), nl,
    !.