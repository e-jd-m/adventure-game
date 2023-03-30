:- dynamic player_at/1, place/2, alive/1.

%xonnections
con(room1, sever, room2).
con(room1, jih, room4).
con(room1, vychod, room3).
con(room1, zapad, room5).
con(room2, vychod, room6).
con(room2, zapad, room7).
con(room3, vychod, room10).
con(room3, sever, room8).
con(room8, vychod, room9).
con(room7, sever, room11).
con(room11, vychod, room12).
con(room12, jih, room16).
con(room12, vychod, room13).
con(room16, vychod, room15).
con(room13, jih, room15).
con(room13, vychod, room14).
con(room14, sever, room17).
con(room14, jih, room18).
con(room18, vychod, room19).
con(room19, vychod, room20).
con(room5, sever, room7).
con(room4, vychod, room21).
con(room21, sever, room3).

%reversed connections
con(room2, jih, room1).
con(room4, sever, room1).
con(room3, zapad, room1).
con(room5, vychod, room1).
con(room6, zapad, room2).
con(room7, vychod, room2).
con(room10, zapad, room3).
con(room8, jih, room3).
con(room9, zapad, room8).
con(room11, jih, room7).
con(room12, zapad, room11).
con(room16, sever, room12).
con(room13, zapad, room12).
con(room15, zapad, room16).
con(room15, sever, room13).
con(room14, zapad, room13).
con(room17, jih, room14).
con(room18, sever, room14).
con(room19, zapad, room18).
con(room20, zapad, room19).
con(room7, jih, room5).
con(room21, zapad, room4).
con(room3, jih, room21).




detail(Room) :- 
  win_room_at(Room), place(drahokam, player_inv), writeln('Nasel jsi drahokam i cestu ven, vyhravas'), halt.

detail(Room) :-
  win_room_at(Room), writeln('Nasel jsi vychod ven, ale stale nemas drahokam. Pokracuj v hledani a pak se vrat.').

detail(room1) :- write('Temna mistnost, okolo slysis tajemne zvuky'), nl.
detail(room2) :- write('V mistnosti je malo svetla, matne vidis stary nabytek.'), nl.
detail(room3) :- write('Na stenach jsou stare malby.'), nl.
detail(room4) :- write('Chladna mistnost, nic zajimaveho.'), nl.
detail(room5) :- write('Tato mistnost zrejme slouzila jako zbrojnice, mozna tady bude neco uzitecneho'), nl.
detail(room6) :- write('Pokoj, lezi zde postel a par skrini.'), nl.
detail(room7) :- write('Stara knihovna, vsude okolo jsou police plne knih'), nl.
detail(room8) :- write('Prazdna mistnost, nic zvlastniho.'), nl.
detail(room9) :- write('Stara jidelna, vidis lavice a stoly.'), nl.
detail(room10) :- write('Nachazis se v kuchyni. Okolo vids panvicky a vseljake pomucky na vareni.'), nl.
detail(room11) :- write('Tajemna mistnost.'), nl.
detail(room12) :- write('Prazdna mistnost, akorat v koute stoji stara socha'), nl.
detail(room13) :- write('Opusteny pokoj, vsude je plno prachu a pavucin'), nl.
detail(room14) :- write('Obycejna chodba.'), nl.
detail(room15) :- write('Nachazis se v pokladnici.'), nl.
detail(room16) :- write('Dalsi zbrojnice.'), nl.
% detail(room17) :- write('room17'), nl.
detail(room18) :- write('Velka slavnostni sin. Na stejnach jsou obrazy. Jsou zde ruzne sochy.'), nl.
detail(room19) :- write('Mensi komora, nic specialniho.'), nl.
detail(room20) :- write('Malicka komurka, zde uz opravdu nic neni.'), nl.
detail(room21) :- write('Velka mistnost, ale nic zde neni.'), nl.

place(dyka, room2).
place(mec, room16).
place(kniha, room7).
place(mec, room5).

place(drahokam, room15).

place(talir, room9).
place(nuz, room10).

enemy(strazce, room7).
enemy(hlidac, room15).

alive(strazce).
alive(hlidac).

attack_on_sight(strazce).
attack_on_sight(hlidac).

beat_with(strazce, mec).
beat_with(strazce, dyka).
beat_with(strazce, nuz).
beat_with(hlidac, mec).


win_room_at(room17).


%initial player pos
player_at(room1).

go(Dir) :- 
  player_at(Pos),
  con(Pos, Dir, NewPos),
  retract(player_at(Pos)),
  assert(player_at(NewPos)),
  check_pos(), !.

go(_) :-
  write('Tudy cesta nevede'), nl,
  check_pos().


sever() :- go(sever).
jih() :- go(jih).
vychod() :- go(vychod).
zapad() :- go(zapad).



vezmi(Item) :-
  place(Item, player_inv),
  writeln('Tento predmet uz mas.'), !.

vezmi(Item) :-
  player_at(Pos),
  place(Item, Pos),
  retract(place(Item, Pos)),
  assert(place(Item, player_inv)),
  check_pos(), !.

vezmi(_) :-
  writeln('Neplatna volba'), !.

poloz(Item) :-
  player_at(Pos),
  place(Item, player_inv),
  retract(place(Item, player_inv)),
  assert(place(Item, Pos)),
  check_pos(), !.

poloz(_) :- writeln('Neplatna volba'), !.

print_list_str(_, []) :- !.
print_list_str(Str, [H|T]) :- 
  write(Str), write(H), nl,
  print_list_str(Str, T).

list_cons(Pos) :-
  findall(Dir, con(Pos, Dir, _), L), print_list_str('Cesta vede na ', L).

check_items(Pos) :-
  findall(Item, place(Item, Pos), L), print_list_str('V mistnosti lezi ', L).

check_inv() :- 
  findall(Item, place(Item, player_inv), L), print_list_str('V inventari mas ', L).

check_enemies(Pos) :-
  findall(Enemy, enemy(Enemy, Pos), L),include(alive, L, Alive) , print_list_str('Potkal jsi ', Alive).


attack_player([]).
attack_player([E|T]) :- 
  %writeln('Zautocil na tebe '), write(E), write(' ale nastesti jsi mel '), write(W), write('a souboj jsi vyhral')
  beat_with(E, W), place(W, player_inv), format('Zautocil na tebe ~w, ale nastesti jsi mel ~w a souboj jsi vyhral', [E, W]), nl,
  retract(alive(E)),
  attack_player(T).

attack_player([E|_]) :- 
  % writeln('Zautocil na tebe '), write(E), write(' nemas se cim branit a umiras'), halt.
  format('Zautocil na tebe ~w, nemas se jak branit a umiras', [E]), nl, halt.
  
  
attaceked(Pos) :- 
  findall(Enemy, enemy(Enemy, Pos), L),include(alive, L, Alive) , include(attack_on_sight, Alive, Attacking), attack_player(Attacking).


check_pos() :-
  player_at(Pos),
  attaceked(Pos),
  detail(Pos),
  check_items(Pos),
  % check_enemies(Pos),
  check_inv(), !,
  list_cons(Pos).

  
help_game() :- 
  write('Pouzij server(), jih(), vychod(), zapad() pro pohyb'), nl,
  write('Vezmi(item). a poloz(item). pro praci s inventarem.'),
  writeln('help_game pro napovedu.'), nl.

start() :-
  help_game(),

  writeln('Jsi lupic a prisel jsi do zdanlive opusteneho hradu najit bajny drahokam'),
  writeln('Behem prohledavani jsi se ale ztratil a navic se zda ze hrad neni asi tak opusteny jak se nejdriv zdalo'),
  writeln('Najdi poklad pro ktery jsi prisel a pokus se objevit cestu ven'), nl,
  check_pos().