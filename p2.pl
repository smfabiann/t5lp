% matriz mostrada en la tarea
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

% para que sea mas visual
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

% primero hacemos el tiempoRuta ya que asi sera mas facil sacar rutaOptima
tiempoRuta(_, [_], 0).
tiempoRuta(M, [A,B|Resto], TiempoTotal) :-
    obtener_fila(M, A, Fila),
    obtener_elemento(Fila, B, Peso),
    Peso > 0, % si no hay camino, falla
    tiempoRuta(M, [B|Resto], TiempoResto),
    TiempoTotal is Peso + TiempoResto.

% obtenemos la fila
obtener_fila([Fila|_], 1, Fila).
obtener_fila([_|Resto], N, Fila) :-
    N > 1,
    N1 is N - 1,
    obtener_fila(Resto, N1, Fila).

% Obtiene el elemento N (base 1) de la lista.
obtener_elemento([Elem|_], 1, Elem).
obtener_elemento([_|Resto], N, Elem) :-
    N > 1,
    N1 is N - 1,
    obtener_elemento(Resto, N1, Elem).


/*
Ejemplos tiempoRuta()

?- matriz(M), tiempoRuta(M, [1,7], T).
% 1→7 = 5
T = 5.

?- matriz(M), tiempoRuta(M, [1,2,5,6], T).
% 1→2 = 3, 2→5 = 7, 5→6 = 3; suma = 13
T = 13.

?- matriz(M), tiempoRuta(M, [1,4], T).
% 1→4 = 0 → arista inexistente → falla
false.
*/


% rutaOptima(+Matriz, +Origen, +Destino, -Camino, -Tiempo)
rutaOptima(Matriz, Origen, Destino, CaminoOptimo, TiempoOptimo) :-
    findall(Camino, camino_simple(Matriz, Origen, Destino, [Origen], Camino), Caminos),
    findall(Tiempo-CaminoR, (
        member(CaminoR, Caminos),
        tiempoRuta(Matriz, CaminoR, Tiempo)
    ), Pares),
    sort(Pares, [TiempoOptimo-CaminoOptimo|_]).

% camino_simple(+Matriz, +Actual, +Destino, +Visitados, -Camino)
% Genera caminos simples (sin ciclos) de Actual a Destino.
camino_simple(_, Destino, Destino, Visitados, Camino) :-
    reverse(Visitados, Camino).
camino_simple(Matriz, Actual, Destino, Visitados, Camino) :-
    obtener_fila(Matriz, Actual, Fila),
    vecinos_todos(Fila, 1, Vecinos),
    member(Vecino, Vecinos),
    \+ member(Vecino, Visitados),
    camino_simple(Matriz, Vecino, Destino, [Vecino|Visitados], Camino).

% vecinos_todos(+Fila, +Indice, -ListaVecinos)
% Devuelve una lista con todos los índices de vecinos alcanzables (peso > 0).
vecinos_todos([], _,
    []).
vecinos_todos([Peso|Resto], Indice, [Indice|VecinosResto]) :-
    Peso > 0,
    Indice1 is Indice + 1,
    vecinos_todos(Resto, Indice1, VecinosResto).
vecinos_todos([Peso|Resto], Indice, VecinosResto) :-
    Peso =< 0,
    Indice1 is Indice + 1,
    vecinos_todos(Resto, Indice1, VecinosResto).



/*
Ejemplos de ruta optima
?- matriz(M), rutaOptima(M, 1, 10, Camino, Tiempo).
Camino = [1,10],
Tiempo = 20.

?- matriz(M), rutaOptima(M, 2, 6, C, T).
C = [2,5,6],
T = 10.

*/



/*
matriz(M), rutaOptima(M, 1, 10, Camino1, Tiempo1).
Camino1 = [1,10],
Tiempo1 = 20.
matriz(M), cerrarCalle(M, 1, 10, M2), rutaOptima(M2, 1, 10, Camino2, Tiempo2).
Camino2 = [1, 2, 5, 4, 10],
Tiempo2 = 24.

matriz(M), rutaOptima(M, 2, 6, Camino3, Tiempo3).
Camino3 = [2,5,6],
Tiempo3 = 10.
matriz(M), cerrarCalle(M, 2, 5, M3), rutaOptima(M3, 2, 6, Camino4, Tiempo4).
Camino4 = [2,3,5,6],
Tiempo4 = 12.
*/



% Devuelve una nueva matriz con la arista (I,J) puesta en 0, el resto igual.
cerrarCalle(Matriz, I, J, MatrizNueva) :-
    set_fila(Matriz, I, J, MatrizNueva).

% set_fila(+Matriz, +I, +J, -MatrizNueva)
set_fila([Fila|Resto], 1, J, [FilaNueva|Resto]) :-
    set_columna(Fila, J, FilaNueva).
set_fila([Fila|Resto], I, J, [Fila|RestoNueva]) :-
    I > 1,
    I1 is I - 1,
    set_fila(Resto, I1, J, RestoNueva).

% set_columna(+Fila, +J, -FilaNueva)
set_columna([_|Resto], 1, [0|Resto]).
set_columna([X|Resto], J, [X|RestoNueva]) :-
    J > 1,
    J1 is J - 1,
    set_columna(Resto, J1, RestoNueva).



% impactoCorte(+Matriz, +Origen, +Destino, -Retraso)
% Calcula el incremento en el tiempo de la ruta óptima al eliminar cualquier arista usada en la ruta óptima original.
impactoCorte(Matriz, Origen, Destino, Retraso) :-
    rutaOptima(Matriz, Origen, Destino, Camino, TiempoOriginal),
    % Busca la primera arista usada en la ruta óptima que conecta Origen con Destino
    arista_a_cortar(Camino, Origen, Destino, I, J),
    cerrarCalle(Matriz, I, J, MatrizCortada),
    rutaOptima(MatrizCortada, Origen, Destino, _, TiempoNuevo),
    Retraso is TiempoNuevo - TiempoOriginal.

% arista_a_cortar(+Camino, +Origen, +Destino, -I, -J)
% Busca la primera arista (I,J) usada en el camino de Origen a Destino.
arista_a_cortar([I,J|_], Origen, _, I, J) :- I = Origen.
arista_a_cortar([_|Resto], Origen, Destino, I, J) :-
    arista_a_cortar(Resto, Origen, Destino, I, J).

/*
matriz(M), impactoCorte(M, 1, 10, Retraso).
Retraso = 4.

matriz(M), impactoCorte(M, 2, 6, Retraso).
Retraso = 2.
*/