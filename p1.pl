balancear(Lista, Balanceada) :-
    balancear_aux(Lista, 0, [], Balanceada).

% Caso base: lista vacía, agregamos los ')' que falten
balancear_aux([], 0, Acc, Acc).
balancear_aux([], N, Acc, Balanceada) :- N > 0,
    agregar_cierres(N, Acc, Balanceada).

% Si encontramos '(', sumamos 1 al contador
balancear_aux(['('|Resto], N, Acc, Balanceada) :-
    N1 is N + 1,
    append(Acc, ['('], NuevoAcc),
    balancear_aux(Resto, N1, NuevoAcc, Balanceada).

% Si encontramos ')', restamos 1 al contador o agregamos '(' si es necesario
balancear_aux([')'|Resto], N, Acc, Balanceada) :-
    N > 0,
    N1 is N - 1,
    append(Acc, [')'], NuevoAcc),
    balancear_aux(Resto, N1, NuevoAcc, Balanceada).

balancear_aux([')'|Resto], 0, Acc, Balanceada) :-
    append(Acc, ['(', ')'], NuevoAcc),
    balancear_aux(Resto, 0, NuevoAcc, Balanceada).

% Ignora otros caracteres
balancear_aux([_|Resto], N, Acc, Balanceada) :-
    balancear_aux(Resto, N, Acc, Balanceada).

% Agrega N paréntesis de cierre al final
agregar_cierres(0, Acc, Acc).
agregar_cierres(N, Acc, Balanceada) :-
    N > 0,
    N1 is N - 1,
    append(Acc, [')'], NuevoAcc),
    agregar_cierres(N1, NuevoAcc, Balanceada).

/*
    ['(', ]]
?- balancear(['(', '(', ')', '(', ')'], S).
    S = [’(’, ’(’, ’)’, ’(’, ’)’, ’)’].

    ?- balancear([')', '(', ')', ')'], S).
    S = [’(’, ’)’, ’(’, ’)’, ’(’, ’)’].

    ?- balancear(['(', '(', '(', ')'], S).
    S = [’(’, ’(’, ’(’, ’)’, ’)’, ’)’].
*/