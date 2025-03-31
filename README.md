# Veri-Project1

En este apartado vamos a ir describiendo los detalles del proyecto 1

**En cuanto el banco de registros:**
Si se está ejecutando el código por primera vez en icarus, se debe: 
* Sintetizar el archivo para verificar que no hayan errores, para eso ejecute: \
  `iverilog -o nombredelarchivo.vvp nombredelarchivo.v` esto va a crear un archivo .vvp que va a ser necesario luego. \
  Ejemplo: \
  `iverilog -o mux.vvp mux.v` Así debe hacer con todos los archivos excepto con el testbench
* Una vez se han compilado todos los archivos, es necesario crear el archivo para la simulación, para ello:\
  `iverilog -o simulation.vvp *.v` Esto va a compilar todos los archivos `.v` y va a generar el archivo `simulation.vpp` que es el ejecutable de la simulación.
* Luego, se ejecuta la simulación con el comando\
  `vvp simulation.vvp`

* Para visualizar las señales en GTKWAVE \
  `gtkwave simulation.vcd`
