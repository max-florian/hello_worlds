// SPDX-Licence-Identifier: UNLICENCED (Licencia)

pragma solidity >=0.7.0 <0.9.0; // Versión (o rango de versiones) del contrato

contract Contrato { // Nombre del contrato. Siempre comenzar con esta keyword.
    
    /**
         Se utiliza public para poder visualizar el tipo y valor de la variable
         luego de ejecutarse el contrato.

         Entre mas codigo tenga, mas poder de procesamiento es necesario y eso
         implica mayor calculo.
     */


    int cantidad;   // Numero con signo ENTERO.
    uint cantidadSinSigno;  // Numero sin signo ENTERO.
    address private owner;  // Dirección de Etherum. Relaciona cuentas y contratos.
    bool firmado;
    string public resultado;
    uint [] public numeros;

    /** 
        Variables globales:
        msg: Valores relacionados con la configuración del mensaje.
        tx: Valores relacionados con la transacción actual.
        block: Valores relacionados con el bloque actual.
    */

    struct Alumno { // Similar a un objeto.
        string nombre;
        uint documento;
    }

    Alumno[] public alumnos;   // Arreglo dinamico de alumnos.

    /**
        Mapping:
        Tipo de almacenamiento clave valor. Se puede acceder a un valor directamente
        desde su clave sin tener que iterar sobre todos los valores, como en el array.

        Enum:
        Serie de valores creados por los usuarios.
        Representados externamente por nombre e internamente por un valor entero.
        Sirven para manejar estados.
    */

    mapping( address => uint ) public balance; // Clave es un adress y el valor un uint

    enum Estado { Iniciado, Finalizado} // Estado de una transación

    Estado public estadoDelContrato;   // Variable que indica el estado actual de contrato.

    /**
        Eventos:
        No tienen una función en especial.
        Su objetivo es que se integren a componentes externos para poder
        ejecutar acciones externas.
        Ej: Enviar alerta a un usuario.
        Cada llamada a los eventos tienen un costo asociado.
        Solo usar cuando sea necesario.
    */

    event NotificacionDeCondicion(bool condicion);
    
    constructor(bool estaFirmado) { // Constructor del contrato (opcional)
        
        owner = msg.sender; // El que está enviando la transacción.
        firmado = estaFirmado;

        alumnos.push(Alumno({ nombre: "Max", documento: 12345 }));  // Nuevo struct = Nombre_struct();

        estadoDelContrato = Estado.Iniciado;

        balance[msg.sender] = 1000; // Settear un balance inicial;

        estadoDelContrato = Estado.Finalizado;

        /**
            Se debe ser cuidadoso al usar sentencias de control para no entrar en bucle
            y entrar en gastos exagerados.
         */

        if (estaFirmado) {
            resultado = "Esta firmadisimo!";
        } else {
            resultado = "No esta firmadisimo!";
        }

        emit NotificacionDeCondicion(estaFirmado);

        for (uint i = 0; i < 10; i++) {
            numeros.push(i);
        }
    }

    /**
        Funciones:
        Piezas de codigo que pueden invocarse dentro del contrato o fuera
        del mismo para realizar una acción.

        pure: Cuando no se modifica o se hace uso de una variable del contrato
              en una funcion.

        view: Se hace uso de una variable del contrato pero NO se modifica.

        Tipos de función
            public: son accesibles desde todo ámbito posible.
            private: solo son accesibles desde el mismo contrato.
            internal: solo son accesibles desde el mismo contrato y sus contratos derivados.
            external: solo accesibles desde fuera del contrato.
     */

    function Suma(uint numero1, uint numero2) public view EsOwner() returns (uint) {
        return numero1 + numero2;
    }

    uint private resultado2;

    function ObtenerResultado() public view returns (uint) {
        return resultado2;
    }

    /**
        Los modificadores son funciones especiales por el usuario y 
        que se añaden a otra función para envolver su funcionamiento
     */

    modifier EsOwner() {
        /**
            La función revert() se utiliza para arrojar una excepción en nuestro smart contract y 
            revertir la función que la llama. 
            Se puede agregar un mensaje como parámetro describiendo el error.
         */
        if (msg.sender != owner) revert("Solo el dueño del contrato puede modificarlo.");
        _;
    }
    
}