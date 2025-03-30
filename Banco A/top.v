//////////////////////////////////////////////////////////
//
// top.v 
//  
// Instancia todos los módulos y conecta sus señales.
//
//////////////////////////////////////////////////////////

module top (clk, rst, write_en, read_en, addr, data_in, 
            data_out );

    input logic clk, rst, write_en, read_en;
    input logic [3:0] addr;
    input logic [15:0] data_in;
    output logic [15:0] data_out;

    logic we;
    logic [3:0] reg_sel;
    logic [15:0] reg_out1, reg_out2;

    control_unit CU (.clk(clk), .rst(rst), .read_en(read_en), 
                     .write_en(write_en), .addr(addr), 
                     .we(we), .reg_sel(reg_sel));

    reg_file RF (.clk(clk), .rst(rst), .we(we), .addr_wr(reg_sel), 
                 .data_in(data_in), .addr_rd1(addr), 
                 .addr_rd2(4'b0000), .data_out1(reg_out1), 
                 .data_out2(reg_out2));

    assign data_out = reg_out1;

endmodule
