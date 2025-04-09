module scoreboard (
    input logic clk,
    input logic rst,
    input logic we,                  // Señal de habilitación de escritura
    input logic [3:0] addr_wr,       // Dirección de escritura
    input logic [15:0] data_in,      // Datos a escribir
    input logic [3:0] addr_rd1,      // Dirección de lectura 1
    input logic [3:0] addr_rd2,      // Dirección de lectura 2
    input logic [15:0] data_out1,    // Salida del DUT 1
    input logic [15:0] data_out2     // Salida del DUT 2
);
    logic [15:0] registers [0:13];
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            foreach (registers[i]) begin
                registers[i] <= 16'h0000;
            end
        end else begin
            if (we) begin
                registers[addr_wr] <= data_in;
            end
        end
    end
    always_ff @(posedge clk) begin
        if (data_out1 !== registers[addr_rd1]) begin
            $display("Error: Lectura incorrecta en addr_rd1 (esperado: %h, recibido: %h)", registers[addr_rd1], data_out1);
        end
        if (data_out2 !== registers[addr_rd2]) begin
            $display("Error: Lectura incorrecta en addr_rd2 (esperado: %h, recibido: %h)", registers[addr_rd2], data_out2);
        end
    end
endmodule
