balancear(Entrada, Salida) :-
    balancear_aux(Entrada, 0, Salida).

balancear_aux([], 0, Salida).
balancear_aux(['('|C], N, Salida) :-
    N1 is N + 1,
    balancear_aux([C], N1, Salida).

balancear_aux([')'|C], N, Salida) :-
    balancear_aux([C], N, Salida).


contar([], Salida)
contar(['('|C], Salida) :-
    S1 is Salida + 1,
    contar(C, S1).
contar([')'|C], Salida) :-
    contar(C, Salida)

    

/*
    ['(', ]]
?- balancear(['(', '(', ')', '(', ')'], S).
    S = [’(’, ’(’, ’)’, ’(’, ’)’, ’)’].

    ?- balancear([')', '(', ')', ')'], S).
    S = [’(’, ’)’, ’(’, ’)’, ’(’, ’)’].

    ?- balancear([’(’, ’(’, ’(’, ’)’], S).
    S = [’(’, ’(’, ’(’, ’)’, ’)’, ’)’].
*/