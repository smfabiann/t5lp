balancear(E, S) :-
    balancear_aux(E, [], 0).

balancear_aux([], S, 0) :-
    S.

balancear_aux([H|T], S, Izq) :-
    H = '(',
    Izq1 is Izq + 1,
    append(S, ['('], S1),
    balancear_aux(T, S1, Izq1).

balancear_aux([H|T], S, Izq) :-
    H = ')',
    Izq > 0,
    Izq1 is Izq - 1,
    append(S, [')'], S1),
    balancear_aux(T, S1, Izq1).

balancear_aux([H|T], S, Izq) :-
    H = ')',
    Izq = 0,
    balancear_aux(['('|[H|T]], S, Izq).

/*
    ['(', ]]
?- balancear(['(', '(', ')', '(', ')'], S).
    S = [’(’, ’(’, ’)’, ’(’, ’)’, ’)’].

    ?- balancear([')', '(', ')', ')'], S).
    S = [’(’, ’)’, ’(’, ’)’, ’(’, ’)’].

    ?- balancear(['(', '(', '(', ')'], S).
    S = [’(’, ’(’, ’(’, ’)’, ’)’, ’)’].
*/