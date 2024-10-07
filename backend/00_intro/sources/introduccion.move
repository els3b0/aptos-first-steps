module introduccion::practica_aptos {

    //Imports
    use std::debug::print;
    use std::string::utf8;
//codigo a ejecutar

<<<<<<< HEAD

=======
>>>>>>> 0322eebf6b426b02edfbb9843ae9cdf9d9e46ef0
        const CONSTANTE: u64 = 200;
    fun practica() {
        let variable : u64 = 100; 
        
<<<<<<< HEAD
        let variable2 : vector<u8> = b"Nuevo mensaje";
       
=======
        //let variable2 : vector<u8> = b"Hola hola";
        let igualdad = CONSTANTE == variable;
        let comparacion = CONSTANTE > variable;
       let final = igualdad && comparacion == true;

        //print(&utf8(variable2));
        print(&variable);
        print(&CONSTANTE);
        print(&igualdad);
        print(&comparacion);
        print(&final);
    }
>>>>>>> 0322eebf6b426b02edfbb9843ae9cdf9d9e46ef0

        print(&utf8(variable2));
       
        
    }
      
    #[test]
    fun prueba() {
        practica();
    }
}
