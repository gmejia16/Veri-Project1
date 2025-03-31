//////////////////////////////////////////////////////////
// top.v 
// Instancia todos los módulos y conecta sus señales.
//////////////////////////////////////////////////////////

module top (clk, rst, write_en, read_en, addr, data_in, data_out);

    input clk, rst, write_en, read_en;
    input [3:0] addr;
    input [15:0] data_in;
    output [15:0] data_out;

    wire we;                    // Se declara como 'wire', ya que es una salida de control_unit
    wire [3:0] reg_sel;         // Se declara como 'wire', ya que es una salida de control_unit
    wire [15:0] reg_out1, reg_out2;

    // Instancia de la unidad de control
    control_unit cu (
        .clk(clk),
        .rst(rst),
        .read_en(read_en),
        .write_en(write_en),
        .addr(addr),
        .we(we),                 // Salida we conectada al módulo de control_unit
        .reg_sel(reg_sel)        // Salida reg_sel conectada al módulo de control_unit
    );

    // Instancia del banco de registros
    reg_file RF (
        .clk(clk), 
        .rst(rst), 
        .we(we), 
        .addr_wr(reg_sel), 
        .data_in(data_in), 
        .addr_rd1(addr), 
        .addr_rd2(4'b0000), 
        .data_out1(reg_out1), 
        .data_out2(reg_out2)
    );

    // Asignación de salida
    assign data_out = reg_out1;   // La salida es reg_out1

endmodule
