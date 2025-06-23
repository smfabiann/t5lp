% filepath: d:\Github\t5lp\p2.pl

matriz([
    [0, 3, 0, 0, 0, 0, 5, 0, 0, 20],
    [0, 0, 1, 0, 7, 0, 4, 0, 0, 0],
    [0, 0, 0, 0, 8, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 12, 0, 0, 11, 12],
    [0, 0, 0, 2, 0, 3, 0, 0, 0, 0],
    [0, 0, 9, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 2, 0, 0, 0, 0, 0, 0, 0],
    [12, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [8, 0, 0, 0, 0, 0, 0, 5, 0, 0],
    [0, 10, 0, 0, 6, 0, 0, 4, 1, 0]
]).

% Predicado principal: busca el mejor camino sin findall
rutaOptima(Matriz, Origen, Destino, Camino, Tiempo) :-
    mejor_ruta(Matriz, Origen, Destino, [Origen], Camino, 0, Tiempo).

% Caso base: llegamos al destino
mejor_ruta(_, Nodo, Nodo, Visitados, Camino, Tiempo, Tiempo) :-
    reverse(Visitados, Camino).

% Caso recursivo: explora vecinos y elige el mejor
mejor_ruta(Matriz, Nodo, Destino, Visitados, MejorCamino, TiempoActual, MejorTiempo) :-
    fila_nodo(Nodo, Matriz, Vecinos),
    mejor_vecino(Vecinos, 1, Matriz, Nodo, Destino, Visitados, TiempoActual, MejorCamino, MejorTiempo).

% Obtiene la fila N (base 1) de la matriz
fila_nodo(1, [Fila|_], Fila).
fila_nodo(N, [_|Resto], Fila) :-
    N > 1,
    N1 is N - 1,
    fila_nodo(N1, Resto, Fila).

no_visitado(_, []).
no_visitado(X, [Y|Ys]) :- X \= Y, no_visitado(X, Ys).

% Explora todos los vecinos y elige el mejor
mejor_vecino([], _, _, _, _, _, _, _, _, _) :- fail.
mejor_vecino([Costo|Resto], Indice, Matriz, _, Destino, Visitados, TiempoActual, MejorCamino, MejorTiempo) :-
    Costo > 0,
    no_visitado(Indice, Visitados),
    TiempoNuevo is TiempoActual + Costo,
    mejor_ruta(Matriz, Indice, Destino, [Indice|Visitados], Camino, TiempoNuevo, TiempoVecino),
    Indice1 is Indice + 1,
    mejor_vecino(Resto, Indice1, Matriz, _, Destino, Visitados, TiempoActual, OtroCamino, OtroTiempo),
    menor_camino(Camino, TiempoVecino, OtroCamino, OtroTiempo, MejorCamino, MejorTiempo).
mejor_vecino([Costo|Resto], Indice, Matriz, _, Destino, Visitados, TiempoActual, MejorCamino, MejorTiempo) :-
    Costo > 0,
    no_visitado(Indice, Visitados),
    TiempoNuevo is TiempoActual + Costo,
    mejor_ruta(Matriz, Indice, Destino, [Indice|Visitados], MejorCamino, TiempoNuevo, MejorTiempo).
mejor_vecino([_|Resto], Indice, Matriz, _, Destino, Visitados, TiempoActual, MejorCamino, MejorTiempo) :-
    Indice1 is Indice + 1,
    mejor_vecino(Resto, Indice1, Matriz, _, Destino, Visitados, TiempoActual, MejorCamino, MejorTiempo).

menor_camino(Camino1, Tiempo1, _, Tiempo2, Camino1, Tiempo1) :- Tiempo1 < Tiempo2.
menor_camino(_, Tiempo1, Camino2, Tiempo2, Camino2, Tiempo2) :- Tiempo1 >= Tiempo2.


/*
rutaOptima(+Matriz, +Origen, +Destino, -Camino, -Tiempo)
*/

% ?- matriz(M), rutaOptima(M, 1, 10, Camino, Tiempo).
% Camino = [1,10],
% Tiempo = 20.
% ?- matriz(M), rutaOptima(M, 2, 6, C, T).
% C = [2,5,6],
% T = 10.


/*
    1  2 3 4 5 6  7 8 9  10
--------------------------
1 | 0  3 0 0 0 0  5 0 0  20
2 | 0  0 1 0 7 0  4 0 0  0
3 | 0  0 0 0 8 0  0 0 0  0
4 | 0  0 0 0 0 12 0 0 11 12
5 | 0  0 0 2 0 3  0 0 0  0
6 | 0  0 9 0 0 0  0 0 0  0
7 | 0  0 2 0 0 0  0 0 0  0
8 | 12 0 0 0 0 0  0 0 0  0
9 | 8  0 0 0 0 0  0 5 0  0
10| 0 10 0 0 6 0  0 4 1  0
*/





% tiempo ruta
tiempoRuta(_, [], 0).
tiempoRuta(_, [_], 0).
tiempoRuta(M, [A,B|Resto], T) :-
    fila_nodo(A, M, Fila),
    obtener_elemento(B, Fila, Costo),
    Costo > 0,
    tiempoRuta(M, [B|Resto], T1),
    T is Costo + T1.

obtener_elemento(1, [X|_], X).
obtener_elemento(N, [_|R], X) :-
    N > 1,
    N1 is N - 1,
    obtener_elemento(N1, R, X).



% ?- matriz(M), tiempoRuta(M, [1,7], T).
% % 1→7 = 5
% T = 5.
% ?- matriz(M), tiempoRuta(M, [1,2,5,6], T).
% % 1→2 = 3, 2→5 = 7, 5→6 = 3; suma = 13
% T = 13.
% ?- matriz(M), tiempoRuta(M, [1,4], T).
% % 1→4 = 0 → arista inexistente → falla
% false.



cerrarCalle(M, I, J, MatrizNueva) :-
    var(M), !,
    matriz(MatrizBase),
    cerrarCalle(MatrizBase, I, J, MatrizNueva).
cerrarCalle(Matriz, I, J, MatrizNueva) :-
    set_fila(Matriz, I, J, MatrizNueva).

cerrarCalle(I, J, MatrizNueva) :-
    matriz(M), cerrarCalle(M, I, J, MatrizNueva).

set_fila([Fila|Resto], 1, J, [FilaNueva|Resto]) :-
    set_columna(Fila, J, FilaNueva).
set_fila([Fila|Resto], I, J, [Fila|RestoNueva]) :-
    I > 1,
    I1 is I - 1,
    set_fila(Resto, I1, J, RestoNueva).

set_columna([_|Resto], 1, [0|Resto]) :- length(Resto, L), L >= 0.
set_columna([X|Resto], J, [X|RestoNueva]) :-
    J > 1,
    J1 is J - 1,
    set_columna(Resto, J1, RestoNueva).


/*
    ?- matriz(M), rutaOptima(M, 1, 10, Camino1, Tiempo1).
    Camino1 = [1,10],
    Tiempo1 = 20.
    ?- cerrarCalle(M, 1, 10, M2),
    rutaOptima(M2, 1, 10, Camino2, Tiempo2).
    Camino2 = [1,2,5,4,10],
    Tiempo2 = 24.
    % Otro ejemplo:
    ?- matriz(M), rutaOptima(M, 2, 6, Camino3, Tiempo3).
    Camino3 = [2,5,6],
    Tiempo3 = 10.
    ?- cerrarCalle(M, 2, 5, M3),
    rutaOptima(M3, 2, 6, Camino4, Tiempo4).
    Camino4 = [2,3,5,6],
    Tiempo4 = 12.
*/