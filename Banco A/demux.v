//////////////////////////////////////////////////////////
//
// demux.v 
//  
// Implementa un demultiplexor que dirige la entrada de datos
// al registro seleccionado según la señal de selección.
//
//////////////////////////////////////////////////////////

module demux (in_data, sel, out0, out1, out2, out3, out4, 
              out5, out6, out7, out8, out9, out10, out11, 
              out12, out13 );

    input [15:0] in_data;   // Entrada de datos
    input [3:0] sel;        // Selector del registro destino

    output reg [15:0] out0, out1, out2, out3, out4, out5, out6, out7,
                      out8, out9, out10, out11, out12, out13;


    always @(*) begin
        // Inicializa todas las salidas a 0
        out0 = 16'h0000; 
        out1 = 16'h0000; 
        out2 = 16'h0000; 
        out3 = 16'h0000;
        out4 = 16'h0000; 
        out5 = 16'h0000; 
        out6 = 16'h0000; 
        out7 = 16'h0000;
        out8 = 16'h0000; 
        out9 = 16'h0000; 
        out10 = 16'h0000; 
        out11 = 16'h0000;
        out12 = 16'h0000; 
        out13 = 16'h0000;

        // Activa la salida correspondiente según la selección
        case (sel)
            4'b0000: out0 = in_data;
            4'b0001: out1 = in_data;
            4'b0010: out2 = in_data;
            4'b0011: out3 = in_data;
            4'b0100: out4 = in_data;
            4'b0101: out5 = in_data;
            4'b0110: out6 = in_data;
            4'b0111: out7 = in_data;
            4'b1000: out8 = in_data;
            4'b1001: out9 = in_data;
            4'b1010: out10 = in_data;
            4'b1011: out11 = in_data;
            4'b1100: out12 = in_data;
            4'b1101: out13 = in_data;
        endcase
    end

endmodule
