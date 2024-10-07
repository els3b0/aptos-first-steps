module introduccion::practica_aptos {

    //Imports
    use std::debug::print;
    use std::string::utf8;
//codigo a ejecutar


        const CONSTANTE: u64 = 200;
    fun practica() {
        let variable : u64 = 100; 
        
        let variable2 : vector<u8> = b"Nuevo mensaje";
       

        print(&utf8(variable2));
       
        
    }
      
    #[test]
    fun prueba() {
        practica();
    }
}
