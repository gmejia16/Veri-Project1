//////////////////////////////////////////////////////////
//
// reg_file.v 
//  
// Este módulo implementa un banco de registros de 14 
// registros de 16 bits. Se encarga de la lectura y 
// escritura de los registros.
//
//////////////////////////////////////////////////////////

module reg_file (
    input clk,               // Reloj
    input rst,               // Reset
    input we,                // Habilitación de escritura
    input [3:0] addr_wr,     // Dirección de escritura
    input [15:0] data_in,    // Datos de entrada
    input [3:0] addr_rd1,    // Dirección del primer registro a leer
    input [3:0] addr_rd2,    // Dirección del segundo registro a leer
    output [15:0] data_out1, // Datos del primer registro leído
    output [15:0] data_out2  // Datos del segundo registro leído
);

    // Declaración de registros
    reg [15:0] registers [0:13];  // Banco de 14 registros de 16 bits cada uno

    // Lectura asíncrona
    assign data_out1 = registers[addr_rd1];
    assign data_out2 = registers[addr_rd2];

    // Escritura sincrónica
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Inicialización explícita de todos los registros a 0 en el reset

            registers[0] <= 16'h0000;
            registers[1] <= 16'h0000;
            registers[2] <= 16'h0000;
            registers[3] <= 16'h0000;
            registers[4] <= 16'h0000;
            registers[5] <= 16'h0000;
            registers[6] <= 16'h0000;
            registers[7] <= 16'h0000;
            registers[8] <= 16'h0000;
            registers[9] <= 16'h0000;
            registers[10] <= 16'h0000;
            registers[11] <= 16'h0000;
            registers[12] <= 16'h0000;
            registers[13] <= 16'h0000;
        end else if (we) begin
            registers[addr_wr] <= data_in;
        end
    end

endmodule
