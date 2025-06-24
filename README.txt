Nombre: Fabian San Martin
Rol: 202304650-7

IMPORTANTE:
    Este codigo fue hecho en Windows 11. Cualquier intento de compilar/andar este codigo
    fuera de este ambiente no se garantiza su buen funcionamiento.


    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    SE CAMBIO EL EJEMPLO DE EJECUCION DE cerrarCalle()
    
    Al inicio de cerrar calle hay que agregar matriz(M), ejemplo:
    De esto,
    '''
        cerrarCalle(M, 1, 10, M2), rutaOptima(M2, 1, 10, Camino2, Tiempo2).
    '''
    a esto,
    '''
        matriz(M), cerrarCalle(M, 1, 10, M2), rutaOptima(M2, 1, 10, Camino2, Tiempo2).
    '''
    
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    El comando no andará bien si no se agrega matriz(M), ya que la matriz se tiene que
    inicializar primero.

Requisistos:
    - Tener instalado SWI-Prolog

Intrucciones:
    1. Instalar SWI-Prolog
    2. Abrir la consola en la direccion del la capteta de la tarea. 
    3. Escribir en la consola "swipl"
    4. Para ejecutar la parte 1 o la parte 2 utilizar:
        Para parte 1 (p1.pl),
        '''
            [p1].
        '''
        aparecera de esta forma en la consola si se hizo correctamente,
        '''
            1 ?- [p1].
            true.
        '''
        para la parte 2 reemplezar el "1" por el 2.
    5. Ejemplo de "consulta":
        '''
            64 ?- matriz(M), tiempoRuta(M, [1,7], T).
            M = [[0, 3, 0, 0, 0, 0, 5, 0|...], [0, 0, 1, 0, 7, 0, 4|...], [0, 0, 0, 0, 8, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 2|...], [0, 0, 9|...], [0, 0|...], [12|...], [...|...]|...],
            T = 5
        '''
        Solo pegar " matriz(M), tiempoRuta(M, [1,7], T). " en la consola para las preguntas, sin el "?-" sino da error.

