% Porciacaso antes habia un Dcha (Derecha) para simular un Stack pero resulto que era innecerario
% y lo deje ahi nomas, me da lata cambiarlo.

% funcion principal
balancear(E, S) :-
    % usaremos auxiliar para guardar un acumulador n para el balanceo de parentesis
    balancear_aux(E, [], 0, S).

% caso base
balancear_aux([], S, 0, S).
balancear_aux([], S, Izq, SFinal) :-
    Izq > 0,
    agregar_cierres(Izq, S, SFinal).

% para '('
balancear_aux(['('|T], S, Izq, SFinal) :-
    Izq1 is Izq + 1,
    append(S, ['('], S1),
    balancear_aux(T, S1, Izq1, SFinal).

% para ')', y es posible cerrar (Izq > 0)
balancear_aux([')'|T], S, Izq, SFinal) :-
    Izq > 0,
    Izq1 is Izq - 1,
    append(S, [')'], S1),
    balancear_aux(T, S1, Izq1, SFinal).

% para ')', pero no hay abiertos se agrega '(' antes del parentesis
balancear_aux([')'|T], S, 0, SFinal) :-
    append(S, ['('], S1),
    balancear_aux([')'|T], S1, 1, SFinal).

% caso de solo agregar parentesis al final
agregar_cierres(0, S, S).
agregar_cierres(N, S, SFinal) :-
    N > 0,
    append(S, [')'], S1),
    N1 is N - 1,
    agregar_cierres(N1, S1, SFinal).

/*
    ['(', ]]
?- balancear(['(', '(', ')', '(', ')'], S).
    S = [’(’, ’(’, ’)’, ’(’, ’)’, ’)’].

    ?- balancear([')', '(', ')', ')'], S).
    S = [’(’, ’)’, ’(’, ’)’, ’(’, ’)’].

    ?- balancear(['(', '(', '(', ')'], S).
    S = [’(’, ’(’, ’(’, ’)’, ’)’, ’)’].
*/