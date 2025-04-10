rst,
    input logic we,                  // Señal de habilitación de escritura
    input logic [3:0] addr_wr,       // Dirección de escritura
    input logic [15:0] data_in,      // Datos a escribir
    input logic [3:0] addr_rd1,      // Dirección de lectura 1
    input logic [3:0] addr_rd2,      // Dirección de lectura 2
    input logic [15:0] data_out1,    // Salida del DUT 1
    input logic [15:0] data_out2     // Salida del DUT 2
);
    // Banco de 16 resgistros
    logic [15:0] registers [0:13];
    // Inicialización del Scoreboard
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            foreach (registers[i]) begin // Barrido por los registros
                registers[i] <= 16'h0000;
            end
        end else begin
            if (we) begin  // Seañal de escritura para el registro
                registers[addr_wr] <= data_in;
            end  end  end
   
    // Lecturas a comparar
    always_ff @(posedge clk) begin
        if (data_out1 !== registers[addr_rd1]) begin
            $display("Error: Lectura incorrecta en addr_rd1 (esperado: %h, recibido: %h)", registers[addr_rd1], data_out1);
        end
        if (data_out2 !== registers[addr_rd2]) begin
            $display("Error: Lectura incorrecta en addr_rd2 (esperado: %h, recibido: %h)", registers[addr_rd2], data_out2);
        end end
endmodule
