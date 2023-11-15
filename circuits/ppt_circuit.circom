pragma circom 2.1.6;
include "node_modules/circomlib/circuits/comparators.circom";

template PPT2() {
  signal input player1;
  signal input player2;

  // (parametro que podemos enviar luego a solidity) 
  // winner === 0 - empate, winner === 1 - player1, winner === 2 - player1
  signal output winner;
 
  // restricciones de expresiones algebraicas (cuadraticas o lineales) que luego podemos confirmar 
  // restricciones que indican que la entrada de player1 solo puede ser 2, 3, 5.
  signal p1check; // signal intermedia
  p1check <== (player1 - 2) * (player1 - 3);
  p1check * (player1 - 5) === 0;

  // restricciones que indican que la entrada de player2 solo puede ser 2, 3, 5.
  signal p2check; // signal intermedia
  p2check <== (player2 - 2) * (player2 - 3);
  p2check * (player2 - 5) === 0;

  var piedra = 2;
  var papel = 3; 
  var tijera = 5;

  var piedra_tijera = piedra * tijera;
  
  signal player1x2;
  player1x2 <== player1 * player2;

  component esPiedraTijeraComp = IsZero();
  
  esPiedraTijeraComp.in <== player1x2 - piedra_tijera;

  // signal intermedia para indicar si estamos en el caso piedra_tijera o no
  signal es_piedra_tijera;
  es_piedra_tijera <== esPiedraTijeraComp.out;
  
  component esEmpateComp = IsEqual();
  
  esEmpateComp.in[0] <== player1;
  esEmpateComp.in[1] <== player2;

  signal es_empate;
  es_empate <== esEmpateComp.out;

  component esP1MenorComp = LessThan(3); // solo se necesitan bits para 2,3,5
  esP1MenorComp.in[0] <== player1;
  esP1MenorComp.in[1] <== player2;

  // signal intermedia para indicar si player1 es estrictamenete menor que player2
  signal es_p1_menor;
  es_p1_menor <== esP1MenorComp.out;

  // signal para indicar el ganador correcto suponiendo que no exista empate
  signal winner_no_empate;
  // forma de calcular el valor de la signal winner_no_empate.
  var aux;
  if (es_piedra_tijera) {
      aux = es_p1_menor ? 1 : 2;
  } else {
      aux = es_p1_menor ? 2 : 1;
  }
  winner_no_empate <-- aux;
  
  // definimos las restricciones que describen el calculo anterior.
  es_piedra_tijera * (winner_no_empate - (2 - es_p1_menor)) === 0;
  (1 - es_piedra_tijera) * (winner_no_empate - (es_p1_menor + 1)) === 0;

  // forma de calcular el resultado en todos los casos.
  var res;
  if (es_empate) {
     res = 0;
  } else {
    res = winner_no_empate;
  }
  winner <-- res;
  // definimos las restricciones que describen el calculo anterior.
  es_empate * winner === 0; // si es_empate es diferente de 0 entonces winner es 0
  (es_empate - 1) * (winner - winner_no_empate) === 0;

}

component main = PPT2();