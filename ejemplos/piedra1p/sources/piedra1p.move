module cuenta::PiedraPapelyTijera1P {
    use std::signer;
    
    use AptosFramework::timestamp::now_microseconds;

    // Definir codigos de error personalizados
    const E_ESTADO_JUEGO_INVALIDO: u64 = 1; // Error cuando el estado del juego no es valido para la accion actual
    const E_SELECCION_INVALIDA: u64 = 2;   // Error cuando la seleccion del jugador es invalida
    



    // Estructura del juego
    struct Juego has key, drop {
        jugador: address,
        seleccion_jugador: u8,           // Directamente almacenamos la seleccion del jugador (0 = Piedra, 1 = Papel, 2 = Tijeras)
        seleccion_computadora: u8,       // Seleccion de la "computadora" (0 = Piedra, 1 = Papel, 2 = Tijeras)
        status: u8,                      // Estado del juego (0 = EsperandoSeleccion, 1 = Completo)
        resultado: u8                    // 0 = Jugador perdio, 1 = Jugador gano, 2 = Empate
    }

    // Funcion para Inicializar un nuevo juego entre el jugador y la "computadora"
   public entry fun inicializar_juego(cuenta: &signer) acquires Juego {
    let jugador = signer::address_of(cuenta);

    // Si ya se corrio un juego resetealo
    if (exists<Juego>(jugador)) {
        let juego_ref = borrow_global_mut<Juego>(jugador);
        
        // Resetea el status del juego
        juego_ref.seleccion_jugador = 255;  // Resetea seleccion de jugador
        juego_ref.seleccion_computadora = generar_seleccion_computadora();  // Genera nueva seleccion aleatoria
        juego_ref.status = 0;  // Regresa el status a "EsperandoSeleccion"
        juego_ref.resultado = 0;  // Resetea el resultado

    } else {
        // Si no hay un juego inicializa uno nuevo
        let seleccion_computadora = generar_seleccion_computadora();  // Seleccion aleatoria de la computadora

        // Crea una nueva instancia de Juego con valores iniciales
        let juego = Juego {
            jugador,
            seleccion_jugador: 255,  // Valor(255) para representar no seleccion
            seleccion_computadora,
            status: 0,  // 0 representa EsperandoSeleccion
            resultado: 0  // Inicializa  en 0
        };

        // Mueve el juego a la cuenta del recurso
        move_to(cuenta, juego);
    }
    }



    // Funcion para generar la seleccion aleatoria de la "computadora"
    fun generar_seleccion_computadora(): u8 {
        let timestamp = now_microseconds(); // Usa el timestamp del bloque como fuente de pseudoaleatoriedad
        (timestamp % 3) as u8 // Retorna 0, 1 o 2 (0 = Piedra, 1 = Papel, 2 = Tijeras)
    }

    // Funcion para elegir El jugador selecciona directamente su eleccion
    public entry fun elegir(cuenta: &signer, seleccion: u8) acquires Juego {
        let juego_ref = borrow_global_mut<Juego>(signer::address_of(cuenta)); 

        // Verificar que el estado permita elegir
        if (juego_ref.status != 0) { // 0 = EsperandoSeleccion
            abort E_ESTADO_JUEGO_INVALIDO  // Error status incorrecto
        };

        // Verificar que la seleccion es valida (0 = Piedra, 1 = Papel, 2 = Tijeras)
        if (seleccion > 2) {
            abort E_SELECCION_INVALIDA // Seleccion invalida
        };

        // Guardar la eleccion del jugador
        juego_ref.seleccion_jugador = seleccion;  // Guardar la seleccion directamente
        juego_ref.status = 1; // 1 = Completo

        // Determinar el ganador y actualizar el estado del resultado
        let resultado = determinar_ganador(seleccion, juego_ref.seleccion_computadora);
        juego_ref.resultado = resultado; // 0 = Jugador perdio, 1 = Jugador gano, 2 = Empate
        }
    //Funcion para determinar ganador
          fun determinar_ganador(seleccion_jugador: u8, seleccion_computadora: u8): u8 {
        // 0 = Piedra, 1 = Papel, 2 = Tijeras

        // Si las selecciones son iguales, es un empate
        if (seleccion_jugador == seleccion_computadora) {
            return 2  // 2 indica empate
        };

        // Jugador gana: Piedra (0) vence a Tijeras (2)
        if (seleccion_jugador == 0 && seleccion_computadora == 2) {
            return 1  // 1 indica que el jugador gana
        };

        // Jugador gana: Tijeras (2) vence a Papel (1)
        if (seleccion_jugador == 2 && seleccion_computadora == 1) {
            return 1  // 1 indica que el jugador gana
        };

        // Jugador gana: Papel (1) vence a Piedra (0)
        if (seleccion_jugador == 1 && seleccion_computadora == 0) {
            return 1  // 1 indica que el jugador gana
        };

        // Si ninguna de las anteriores condiciones se cumple, la computadora gana
        return 0  // 0 indica que la computadora gana
    }
    // Funcion para llamar resultado
    #[view]
    public fun obtener_resultado(cuenta: address): u8 acquires Juego {
    let juego_ref = borrow_global<Juego>(cuenta);
    let resultado = juego_ref.resultado;

                        // Imprime el resultado como numero (0, 1, or 2) 0 = Jugador perdio, 1 = Jugador gano, 2 = Empate
    std::debug::print<u8>(&resultado);

    return resultado  // regresa el resultado (0, 1, or 2)
    }


    //Funcion para resetear el juego
    public entry fun reiniciar_juego(cuenta: &signer) acquires Juego {
    let juego_ref = borrow_global_mut<Juego>(signer::address_of(cuenta));

                    // Resetea el state del juego
    juego_ref.seleccion_jugador = 255;  // Resetea seleccion de jugador, se usa 255 por ser un valor fuera de rango dentro de u8 para distinguir estados inicializados 
    juego_ref.seleccion_computadora = generar_seleccion_computadora();  // Genera una nueva seleccion aleatoria
    juego_ref.status = 0;  // Regresa el status de "EsperandoSeleccion"
    juego_ref.resultado = 0;  // Resetea el resultado
    }

    



}