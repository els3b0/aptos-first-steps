module cuenta::PiedraPapelyTijera2P {
    use std::signer;
    use std::crypto;
    use std::option::{Option, none, some};
    use std::error;

    // Enum para las opciones de "Piedra, Papel, Tijeras"
    enum Seleccion {
        Piedra,
        Papel,
        Tijeras
    }

    // Enum para el estado del juego
    enum StatusJuego {
        EsperandoCommitments,
        EsperandoRevelacion,
        Completo
    }

    // Estructura del juego
    struct Juego has key { 
        jugador1: address,
        jugador2: address,
        commitment1: Option<hash>,  // Compromiso del jugador 1
        commitment2: Option<hash>,  // Compromiso del jugador 2
        revelacion1: Option<Seleccion>,  // Elección revelada del jugador 1
        revelacion2: Option<Seleccion>,  // Elección revelada del jugador 2
        status: StatusJuego            // Estado del juego
    }

    // Inicializa un nuevo juego entre el jugador 1 y jugador 2
    public entry fun initialize_game(cuenta: &signer, jugador2: address) {
        let jugador1 = signer::address_of(cuenta);
        let juego = Juego {
            jugador1,
            jugador2,
            commitment1: none(),
            commitment2: none(),
            revelacion1: none(),
            revelacion2: none(),
            status: StatusJuego::EsperandoCommitments
        };
        move_to(cuenta, juego);
    }

    // Los jugadores envían su selección como un hash (commitment)
    public entry fun commit_seleccion(cuenta: &signer, hash_commitment: hash) acquires Juego {
        // Usar la dirección del jugador 1 como referencia
        let direccion_juego = signer::address_of(cuenta); 
        let juego_ref = borrow_global_mut<Juego>(direccion_juego);  

        // Verificar si el estado permite comprometer
        if (juego_ref.status != StatusJuego::EsperandoCommitments) {
            abort 1; // No se pueden hacer commitments en el estado actual
        }

        // Verificar si es el jugador 1 o el jugador 2
        let jugador = signer::address_of(cuenta);
        if (juego_ref.jugador1 == jugador) {
            juego_ref.commitment1 = some(hash_commitment);
        } else if (juego_ref.jugador2 == jugador) {
            juego_ref.commitment2 = some(hash_commitment);
        } else {
            abort 2; // Jugador no válido
        }

        // Si ambos commitments están hechos, cambiar el estado
        if (juego_ref.commitment1.is_some() && juego_ref.commitment2.is_some()) {
            juego_ref.status = StatusJuego::EsperandoRevelacion;
        }
    }

    // Los jugadores revelan su elección original
    public entry fun reveal_choice(cuenta: &signer, seleccion: Seleccion, salt: u64) acquires Juego {
        let jugador = signer::address_of(cuenta);
        let juego_ref = borrow_global_mut<Juego>(jugador);

        // Verificar si el estado permite revelar
        if (juego_ref.status != StatusJuego::EsperandoRevelacion) {
            abort 3; // No se pueden revelar elecciones en el estado actual
        }

        // Convertir la selección a cadena de texto
        let commitment_to_check = match seleccion {
            Seleccion::Piedra => "piedra",
            Seleccion::Papel => "papel",
            Seleccion::Tijeras => "tijeras",
        };
        
        let hash_check = crypto::sha3_256(salt.to_string() + commitment_to_check);

        // Verificar la elección revelada del jugador
        if (juego_ref.jugador1 == jugador) {
            if (juego_ref.commitment1 == some(hash_check)) {
                juego_ref.revelacion1 = some(seleccion);
            } else {
                abort 4; // El compromiso no coincide
            }
        } else if (juego_ref.jugador2 == jugador) {
            if (juego_ref.commitment2 == some(hash_check)) {
                juego_ref.revelacion2 = some(seleccion);
            } else {
                abort 5; // El compromiso no coincide
            }
        } else {
            abort 6; // Jugador no válido
        }

        // Si ambos jugadores han revelado sus elecciones, determinar el ganador
        if (juego_ref.revelacion1.is_some() && juego_ref.revelacion2.is_some()) {
            juego_ref.status = StatusJuego::Completo;
            let ganador = determine_winner(juego_ref.revelacion1.unwrap(), juego_ref.revelacion2.unwrap());
            // Lógica para premiar o anunciar al ganador
        }
    }

    // Función para determinar el ganador
    fun determine_winner(seleccion1: Seleccion, seleccion2: Seleccion): address {
        if (seleccion1 == seleccion2) {
            return address::ZERO(); // Empate
        }
        match (seleccion1, seleccion2) {
            (Seleccion::Piedra, Seleccion::Tijeras) => jugador1,
            (Seleccion::Tijeras, Seleccion::Papel) => jugador1,
            (Seleccion::Papel, Seleccion::Piedra) => jugador1,
            _ => jugador2, // El otro jugador gana
        }
    }
}


   









   
   

