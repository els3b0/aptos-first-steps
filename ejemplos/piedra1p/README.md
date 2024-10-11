# Piedra papel y Tijera 1P


## Interactuando con el contrato

Como interactuar con el contrato usando CLI de Aptos, asumiendo que estás utilizando la cuenta default.

Los métodos son:

* **`Inicializar juego`**

Este comando inicializa un nuevo juego entre el usuario (jugador) y la "computadora." Resetea cualquier estado de juego existente y prepara uno nuevo.

```sh
    aptos move run --function-id default::PiedraPapelyTijera1P::inicializar_juego --args
```

 **`Hacer una seleccion`**

Una vez que el juego está inicializado, el jugador debe hacer su movimiento. Usa este comando para seleccionar : Piedra (0), Papel (1) o Tijeras (2).

Utilizar el argumento correspondiente a cada opcion --args 0,1,2

0 = Piedra
1 = Papel
2 = Tijeras

Ejemplo de comando para seleccionar Piedra (0):

```sh
    aptos move run --function-id default::PiedraPapelyTijera1P::elegir --args u8:0

```

 **`Consultar resultado`**

Después de hacer tu selección, puedes ver el resultado del juego (si el jugador ganó, perdió o fue un empate). 

El contrato regresara un valor entre 0, 1 y 2:

0 = El jugador perdió (La computadora ganó)
1 = El jugador ganó
2 = Empate

Usa este comando para ver el resultado:

```sh
    aptos move view --function-id default::PiedraPapelyTijera1P::obtener_resultado --args address:default
```
 **`Reinicio Manual`**
Para reiniciar el juego y empezar de nuevo, usa este comando para restablecer el estado del juego:

```sh
    aptos move run --function-id default::PiedraPapelyTijera1P::reiniciar_juego --args

```