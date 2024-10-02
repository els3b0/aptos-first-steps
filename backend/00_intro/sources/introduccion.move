module introduccion::practica_aptos {
    use std::debug::print;
    use std::string::utf8;

        const CONSTANTE: u64 = 200;
    fun practica() {
        let variable : u64 = 100; 
        
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

    #[test]
    fun prueba() {
        practica();
    }
}
