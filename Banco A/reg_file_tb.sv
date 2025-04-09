`timescale 1ns / 1ps
module reg_file_tb;
    logic clk, rst, write_en, read_en;
    logic [3:0] addr;
    logic [15:0] data_in, data_out;
    top dut (
        .clk(clk),
        .rst(rst),
        .write_en(write_en),
        .read_en(read_en),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );
    scoreboard sb (
        .clk(clk),
        .rst(rst),
        .we(write_en),
        .addr_wr(addr),
        .data_in(data_in),
        .addr_rd1(addr),
        .addr_rd2(4'b0000), // Sin lectura en addr_rd2
        .data_out1(data_out),
        .data_out2() // No usamos el segundo puerto de lectura
    );
    always begin
        #5 clk = ~clk;  // 100 MHz
    end
    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 0;
        write_en = 0;
        read_en = 0;
        addr = 4'b0000;
        data_in = 16'h0000;

        // Resetear el sistema
        #10 rst = 1;
        #10 rst = 0;

        //Direcciones válidas
        $display("Iniciando pruebas de escritura y lectura...\n");

        // En todos los registros
        for (int i = 0; i < 14; i++) begin
            write_en = 1;
            addr = i;
            data_in = 16'hAAAA + i; // Datos diferentes para cada registro
            #10;
        end

        // Desactivar escritura
        write_en = 0;

        //Lectura de todos los registros
        for (int i = 0; i < 14; i++) begin
            addr = i; // Leer de la dirección correspondiente
            #10;
            if (data_out !== (16'hAAAA + i)) begin
                $display("Error: Lectura incorrecta en addr %0d (esperado: %h, recibido: %h)", i, 16'hAAAA + i, data_out);
            end
        end

        //Lectura y Escritura Simultánea
        $display("\nPruebas de Lectura/Escritura Simultánea:");
        addr = 4'b0001; write_en = 1; data_in = 16'h1111; #10;
        addr = 4'b0010; read_en = 1; #10;
        if (data_out !== 16'h1111) begin
            $display("Error: Lectura incorrecta simultánea.");
        end

        //Direcciones No Válidas
        $display("\nPruebas de direcciones no válidas:");
        addr = 4'b1111; // Dirección fuera del rango de registros (14-15)
        #10;
        if (data_out !== 16'h0000) begin
            $display("Error: Lectura incorrecta en addr 15 (esperado: 0000, recibido: %h)", data_out);
        end

        //Reset
        $display("\nPruebas de reset:");
        rst = 1; #10;
        rst = 0; #10;
        for (int i = 0; i < 14; i++) begin
            addr = i;
            #10;
            if (data_out !== 16'h0000) begin
                $display("Error: Después de reset, addr %0d tiene valor incorrecto (esperado: 0000, recibido: %h)", i, data_out);
            end
        end

        //Reseteo Múltiple
        $display("\nPruebas de múltiples resets:");
        rst = 1; #10; rst = 0; #10;
        rst = 1; #10; rst = 0; #10;
        for (int i = 0; i < 14; i++) begin
            addr = i;
            #10;
            if (data_out !== 16'h0000) begin
                $display("Error: Después de reset múltiple, addr %0d tiene valor incorrecto (esperado: 0000, recibido: %h)", i, data_out);
            end
        end
        $finish;
    end

endmodule
