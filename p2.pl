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


% tiempoRuta(+Matriz, +Camino, -TiempoTotal)
/*
Entrada:
    Matriz: matriz de adyacencia que representa un grafo
    Camino: lista de nodos en el que se busca el tiempo total para recorrerlos
Salida:
    TiempoTotal: el tiempo que se demora recorrer el Camino 
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

% obtiene el un elemento i (indice) de una lista
obtener_elemento([Elem|_], 1, Elem).
obtener_elemento([_|Resto], I, Elem) :-
    I > 1,
    I1 is I - 1,
    obtener_elemento(Resto, I1, Elem).


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
/*
Entrada:
    Matriz: matriz de adyacencia que representa un grafo
    Origen: nodo de inicio, donde se parte la busqueda del camino mas optimo
    Destino: nodo final, donde termina el camino
Salida:
    Camino: retorna la lista de nodos del camino mas optimo
Tiempo: tiempo que se demora recorrer el camino (sumatoria del peso de las aristas)
*/
rutaOptima(M, O, D, CaminoFinal, TiempoFinal) :-
    findall(Camino, camino_simple(M, O, D, [O], Camino), Caminos),
    findall(Tiempo-CaminoR, (
        member(CaminoR, Caminos),
        tiempoRuta(M, CaminoR, Tiempo)
    ), Pares),
    sort(Pares, [TiempoFinal-CaminoFinal|_]).


% camino_simple(+Matriz, +Actual, +Destino, +Visitados, -Camino)
% ve los caminos simples existentes desde destino a actual
% me dio lata comentar el codigo como lo hice antes asi que a partir de ahora se hara de forma mas simple
camino_simple(_, Destino, Destino, Visitados, Camino) :-
    reverse(Visitados, Camino).
camino_simple(Matriz, Actual, Destino, Visitados, Camino) :-
    obtener_fila(Matriz, Actual, Fila),
    vecinos_todos(Fila, 1, Vecinos),
    member(Vecino, Vecinos),
    not_member(Vecino, Visitados), % necesitamos sabes si el elemento no es parte de la lista
    camino_simple(Matriz, Vecino, Destino, [Vecino|Visitados], Camino).

% not_member(+Elem, +Lista): verdadero si no esta en la lista
not_member(_, []).
not_member(Elem, [H|T]) :-
    Elem \= H,  % si lo hago de otra forma da warning, asi que se queda si
    not_member(Elem, T).

% vecinos_todos(+Fila, +Indice, -ListaVecinos)
% retorna una lista con todos los nodos vecinos (alcanzables/que exista un camino/ peso > 0)
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


% cerrarCalle(+Matriz, +I, +J, -MatrizNueva)
% devuelve una matriz (MatrizNueva) que tiene corado las aristas que inen el nodo I y el J.
cerrarCalle(M, I, J, MNueva) :-
    set_fila(M, I, J, MNueva).

% set_fila(+Matriz, +I, +J, -MatrizNueva)
% reemplaza el nodo de una fila I y reemplaza el valor de la columna J por 0
% devuelve una matriz con ese cambio
set_fila([Fila|T], 1, J, [FilaNueva|T]) :-
    set_columna(Fila, J, FilaNueva).
set_fila([Fila|T], I, J, [Fila|TNueva]) :-
    I > 1,
    I1 is I - 1,
    set_fila(T, I1, J, TNueva).

% set_columna(+Fila, +J, -FilaNueva)
% reemplaza el nodo de una fila I y reemplaza el valor de la columna J por 0
% la nueva fila con el cambio nuevo
set_columna([_|T], 1, [0|T]).
set_columna([X|T], J, [X|TNueva]) :-
    J > 1,
    J1 is J - 1,
    set_columna(T, J1, TNueva).


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




% impactoCorte(+M, +Origen, +Destino, -Retraso)
% retorna el impacto en tiempo que afectaria cortar una arista en un camino entre nodos Origen y Destino
impactoCorte(M, O, D, Retraso) :-
    rutaOptima(M, O, D, Camino, TiempoOriginal),
    arista_a_cortar(Camino, O, D, I, J),
    cerrarCalle(M, I, J, MCortada),
    rutaOptima(MCortada, O, D, _, TiempoNuevo),
    Retraso is TiempoNuevo - TiempoOriginal.

% arista_a_cortar(+Camino, +O, +D, -I, -J)
% en el caso que la arista de corte no sea vecina, se cortara la mas cercana del camino
% corta la arista entre los nodos I y J
arista_a_cortar([I,J|_], O, _, I, J) :- I = O.
arista_a_cortar([_|Resto], O, D, I, J) :-
    arista_a_cortar(Resto, O, D, I, J).

/*
matriz(M), impactoCorte(M, 1, 10, Retraso).
Retraso = 4.
matriz(M), impactoCorte(M, 2, 6, Retraso).
Retraso = 2.
*/