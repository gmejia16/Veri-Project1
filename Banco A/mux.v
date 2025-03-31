//////////////////////////////////////////////////////////
//
// mux.v 
//  
// Implementa un multiplexor de 14 entradas de 16 bits cada una. 
// Selecciona una de las entradas en función de la señal de selección.
//
//////////////////////////////////////////////////////////

module mux (in0, in1, in2, in3, in4, in5, in6, in7, in8, 
            in9, in10, in11, in12, in13, sel, out_data);

    input [15:0] in0, in1, in2, in3, in4, in5, in6, in7;
    input [15:0] in8, in9, in10, in11, in12, in13;
    input [3:0] sel;               // Señal de selección
    output reg [15:0] out_data;   // Salida del multiplexor

    always @(*) begin
        case (sel)
            4'b0000: out_data = in0;
            4'b0001: out_data = in1;
            4'b0010: out_data = in2;
            4'b0011: out_data = in3;
            4'b0100: out_data = in4;
            4'b0101: out_data = in5;
            4'b0110: out_data = in6;
            4'b0111: out_data = in7;
            4'b1000: out_data = in8;
            4'b1001: out_data = in9;
            4'b1010: out_data = in10;
            4'b1011: out_data = in11;
            4'b1100: out_data = in12;
            4'b1101: out_data = in13;
            default: out_data = 16'h0000; // Valor por defecto
        endcase
        
    end

endmodule
