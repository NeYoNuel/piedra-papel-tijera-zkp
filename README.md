# piedra-papel-tijera-zkp
Implementación de un simple juego de piedra papel tijera en el que podemos usar ZKP

Aplicación de Python
Etapas de juego:

- El jugador 1 comienza una ronda presentando una prueba zk de que ha lanzado un 2 (piedra), 3 (papel) o 5 (tijera) sin revelar qué jugada fue.
- El jugador 2 responde realizando un tiro libre.
- El jugador 1 envía una segunda prueba zk que revela cuál fue su lanzamiento original y se calcula un ganador (o empate) y se almacena en la cadena
# ZKP (Circuito, Pruebas y Contrato de Solidity) 
Para un mejor desarrollo nuestro circuito nos apoyamos en la librería de plantillas de circuitos circomlib. En caso de no haberla instalado preciamente, la agregamos al proyecto en la carpeta `cicuits` con el comando `npm add circolib`, para hacer uso de templates `IsZero()`, `IsEqual()`, del circuito `comparators.circom`

```circom
pragma circom 2.1.6;

include "node_modules/circomlib/circuits/comparators.circom";
```

Para este circuito tenemos 2 señales privadas de entradas y una de salida que es el resultado que luego podemos enviar a slolidity.

## Fase 1

Luego compilamos el circuito `ppt_circuit.circom` de la siguiente forma:

```bash
circom ppt_circuit.circom --r1cs --wasm --sym --c --json
```

#### Generar testigo (witness)

La entrada de compilación `input.json` es:

```json
{"player1": 2, "player2": 5}
```

Luego accedemos a la ruta `bet_even_or_odd_js` llamamos al archivo `Wasm` para generar el `witness`como:
```bash
$ node generate_witness.js ppt_circuit.wasm input.json witness.wtns
```

El testigo nos permite generar la ceremonia de los poderes de Tau para reducir datos críticos cuando se considera el hecho de una configuración confiable, en la que podemos hacer una ceremonia de múltiples partes, que usamos para poder generar las claves que luego se usarán en etapas posteriores de la generación de prueba 
#### Primera Contribución

```bash
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="Primera Contribucion" -v
```
 podemos realizar mas contribuciones.
## Fase 2

La fase 2 depende del circuito y se puede iniciar con el siguiente comando:

```bash
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
```

Luego genere `.zkey`un archivo que contenga el certificado y la clave de verificación y ejecute el siguiente comando:

```bash
snarkjs groth16 setup ppt_circuit.r1cs pot12_final.ptau ppt_circuit_0000.zkey
```

Se genera el hash del circuito y la clave, luego contribuir a la ceremonia de la fase 2, para el cual se necesita un nuevo texto como fuente de entropía.

```bash
snarkjs zkey contribute ppt_circuit_0000.zkey ppt_circuit_0001.zkey --name="1st Contributor Name" -v
```

`--name` podría tener un nombre diferente.

Clave de verificación de exportación que podemos usar según el protocolo groth16 y la curva bn128 usada:

```bash
snarkjs zkey export verificationkey ppt_circuit_0001.zkey verification_key.json
```

#### Generar prueba

```bash
snarkjs groth16 prove ppt_circuit_0001.zkey ppt_circuit_js\witness.wtns proof.json public.json
```

#### Generar contrato de verificación

Un contrato de verificación de Solidity se puede generar de la siguiente manera la cual depende de la clave generada:

```bash
snarkjs zkey export solidityverifier ppt_circuit_0001.zkey verifier_ppt.sol
```

Generar parámetros de llamada del contrato:

```bash
snarkjs generatecall
```

