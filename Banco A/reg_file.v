//////////////////////////////////////////////////////////
//
// reg_file.v 
//  
// Este módulo implementa un banco de registros de 14 
// registros de 16 bits. Se encarga de la lectura y 
// escritura de los registros.
//
//////////////////////////////////////////////////////////

module reg_file (clk, rst, we, addr_wr, data_in, addr_rd1,
                 addr_rd2, data_out1, data_out2);

    input logic clk;             // Señal de reloj
    input logic rst;             // Señal de reset (asincrónico)
    input logic we;              // Señal de habilitación de escritura
    input logic [3:0] addr_wr;   // Dirección del registro a escribir
    input logic [15:0] data_in;  // Dato a escribir en el registro
    input logic [3:0] addr_rd1;  // Dirección del primer registro a leer
    input logic [3:0] addr_rd2;  // Dirección del segundo registro a leer
    output logic [15:0] data_out1; // Salida de datos del primer registro leído
    output logic [15:0] data_out2; // Salida de datos del segundo registro leído

    logic [15:0] registers [0:13]; // Banco de 14 registros de 16 bits cada uno

    // Lectura asíncrona de los registros
    assign data_out1 = registers[addr_rd1];
    assign data_out2 = registers[addr_rd2];

    // Escritura sincrónica en el flanco positivo del reloj o reset
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            integer i;
            // Inicializa todos los registros en 0 al activarse el reset
            for (i = 0; i < 14; i = i + 1) begin
                registers[i] <= 16'h0000;
            end
        end else if (we) begin
            // Escribe el dato en el registro indicado por addr_wr si we está activo
            registers[addr_wr] <= data_in;
        end
    end

endmodule

