//////////////////////////////////////////////////////////
//
// control_unit.v 
//  
// Implementa la unidad de control, que genera la señal de 
// escritura y selecciona el registro destino.
//
//////////////////////////////////////////////////////////

module control_unit (clk, rst, read_en, write_en, addr, we, 
                    reg_sel);

    input logic clk, rst;       // Reloj y Reset
    input logic read_en;        // Habilitación de lectura
    input logic write_en;       // Habilitación de escritura
    input logic [3:0] addr;     // Dirección del registro
    output logic we;            // Señal de escritura
    output logic [3:0] reg_sel; // Registro seleccionado

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            we <= 0;
            reg_sel <= 4'b0000;
        end else begin
            if (write_en) begin
                we <= 1;
                reg_sel <= addr;
            end else begin
                we <= 0;
            end
        end
    end

endmodule

