///////////////////////////////////////////////////////////////
//reg_file_tb.sv
//Modulo para establecer las diferentes pruebas que se aplicaran
//al scoreboard, de manera que tengamos una lectura, escritura
//reseteo o puebas en conjutos para determinar 
//el funcionamiento del banco de pruebas.
///////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module reg_file_tb;

    // Señales del DUT (Diseño Bajo Prueba)
    logic clk, rst, write_en, read_en;
    logic [3:0] addr;
    logic [15:0] data_in, data_out;
    // Instanciación del DUT (banco de registros)
    top dut (
        .clk(clk),
        .rst(rst),
        .write_en(write_en),
        .read_en(read_en),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out));
    scoreboard sb ( // Instanciación del scoreboard
        .clk(clk),.rst(rst),
        .we(write_en),
        .addr_wr(addr),.data_in(data_in),.addr_rd1(addr),.addr_rd2(4'b0000),
        .data_out1(data_out));
    always begin// Generación de reloj
        #5 clk = ~clk;  // 100 MHz
    end
    initial begin // Proceso de simulación
        // Inicialización de señales
        clk = 0; rst = 0;
        write_en = 0;
        read_en = 0;
        addr = 4'b0000;
        data_in = 16'h0000;
        // Resetear el sistema
        #10 rst = 1;  #10 rst = 0;
        // 1. Pruebas de Escritura y Lectura: Direcciones válidas (0-13)
        // Escritura de datos en todos los registros
        for (int i = 0; i < 14; i++) begin
            write_en = 1;
            addr = i;
            data_in = 16'hAAAA + i; // Datos diferentes para cada registro
            #10; end
        write_en = 0;// Desactivar escritura
        // Lectura de todos los registros y verificar
        for (int i = 0; i < 14; i++) begin
            addr = i; #10; // Leer de la dirección correspondiente
            if (data_out !== (16'hAAAA + i))begin
            end end

        // 2. Prueba de Lectura y Escritura Simultánea
        $display("\nPruebas de Lectura/Escritura Simultánea:");
        addr = 4'b0001; write_en = 1; data_in = 16'h1111; #10;
        addr = 4'b0010; read_en = 1; #10;
        if (data_out !== 16'h1111) begin
            $display("Error: Lectura incorrecta simultánea.");        end

        // 3. Verificación de Direcciones No Válidas
        $display("\nPruebas de direcciones no válidas:");
        addr = 4'b1101; #10; // Dirección fuera del rango de registros (14-15)
        if (data_out !== 16'h0000) begin
            $display("Error: Lectura incorrecta en addr 15 (esperado: 0000, recibido: %h)", data_out);
        end

        // 4. Verificación de Reset
        $display("\nPruebas de reset:");
        rst = 1; #10; rst = 0; #10;
        for (int i = 0; i < 14; i++) begin
            addr = i;     #10;
            if (data_out !== 16'h0000) begin
                $display("Error: Después de reset, addr %0d tiene valor incorrecto (esperado: 0000, recibido: %h)", i, data_out);
            end end

        // 5. Prueba: Solo lectura sin escritura activa
        $display("\nPrueba: Solo lectura sin escritura activa (esperado: 0000)");
        rst = 1; #10; rst = 0; #10;
        read_en = 1;
        for (int i = 0; i < 14; i++) begin
            addr = i; #10;
            if (data_out !== 16'h0000) begin
                $display("Error: Lectura en addr %0d sin escritura previa (esperado: 0000, recibido: %h)", i, data_out);
            end end
        read_en = 0;

        // 6. Prueba: Solo lectura con registros previamente escritos
        $display("\nPrueba: Solo lectura con registros previamente escritos");
        for (int i = 0; i < 14; i++) begin
            write_en = 1;
            addr = i;
            data_in = 16'hF0F0 + i;#10; end
        write_en = 0;
        read_en = 1;
        for (int i = 0; i < 14; i++) begin
            addr = i; #10;
            if (data_out !== (16'hF0F0 + i)) begin
                $display("Error: Lectura incorrecta en addr %0d (esperado: %h, recibido: %h)", i, 16'hF0F0 + i, data_out);
            end end
        read_en = 0;
        $finish;
        end end
endmodule
