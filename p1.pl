balancear(Entrada, S) :-
    balancear_aux(Entrada, 0, [], S).

% Caso base: lista vacía, agregamos los ')' que falten
balancear_aux([], 0, Acc, Acc).
balancear_aux([], N, Acc, S) :- N > 0,
    agregar_cierres(N, Acc, S).

% Si encontramos '(', sumamos 1 al contador
balancear_aux(['('|Resto], N, Acc, S) :-
    N1 is N + 1,
    append(Acc, ['('], NuevoAcc),
    balancear_aux(Resto, N1, NuevoAcc, S).

% Si encontramos ')', restamos 1 al contador o agregamos '(' si es necesario
balancear_aux([')'|Resto], N, Acc, S) :-
    N > 0,
    N1 is N - 1,
    append(Acc, [')'], NuevoAcc),
    balancear_aux(Resto, N1, NuevoAcc, S).

balancear_aux([')'|Resto], 0, Acc, S) :-
    append(Acc, ['(', ')'], NuevoAcc),
    balancear_aux(Resto, 0, NuevoAcc, S).

% Ignora otros caracteres
balancear_aux([_|Resto], N, Acc, S) :-
    balancear_aux(Resto, N, Acc, S).

% Agrega N paréntesis de cierre al final
agregar_cierres(0, Acc, Acc).
agregar_cierres(N, Acc, S) :-
    N > 0,
    N1 is N - 1,
    append(Acc, [')'], NuevoAcc),
    agregar_cierres(N1, NuevoAcc, S).

/*
    ['(', ]]
?- balancear(['(', '(', ')', '(', ')'], S).
    S = [’(’, ’(’, ’)’, ’(’, ’)’, ’)’].

    ?- balancear([')', '(', ')', ')'], S).
    S = [’(’, ’)’, ’(’, ’)’, ’(’, ’)’].

    ?- balancear(['(', '(', '(', ')'], S).
    S = [’(’, ’(’, ’(’, ’)’, ’)’, ’)’].
*/