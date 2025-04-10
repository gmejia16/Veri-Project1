//////////////////////////////////////////////////////////
//
// tester.sv 
//  
// Testbench para banco de registros con generación de logs y reportes
//
//////////////////////////////////////////////////////////

module tester;

    // Definición de parámetros de configuración
    parameter clk_period = 10;
    parameter num_regs = 14;
    parameter num_random_tests = 100;
    parameter semilla = 12000;
    parameter log_file = "test_log.log";
    parameter report_file = "test_report.txt";

    // Señales de entrada/salida
    logic clk = 0;
    logic rst = 0;
    logic write_en = 0;
    logic read_en = 0;
    logic [3:0] addr = 0;
    logic [15:0] data_in = 0;
    logic [15:0] data_out;

    // Variables para los reportes
    integer log_file_;
    integer report_file_;
    string current_test = "None";

    // Variables para la verificación
    logic [15:0] valores_esperados [0:num_regs-1]; 
    integer error_count = 0;
    integer test_count = 0;
    integer write_count = 0;
    integer read_count = 0;
    integer reset_count = 0;

    // Instanciamiento del banco de registros
    top dut (
        .clk(clk),
        .rst(rst),
        .write_en(write_en),
        .read_en(read_en),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Generación de reloj
    always #(clk_period/2) clk = ~clk;

    // Tareas de escribir archivos log
    function void write_log(string mensaje);
        $fdisplay(log_file_, "[T=%0t] %s", $time, mensaje);
        $display("[T=%0t] %s", $time, mensaje);
    endfunction

    // Task para iniciar un bloque de pruebas
    task begin_test(input string test_name);
        current_test = test_name;
        write_log($sformatf("\n== Iniciando prueba: %s ==", test_name));
    endtask

    // Task para finalizar el bloque de pruebas actual
    task end_test();
        write_log($sformatf("=== Finalizada la prueba: %s ===", current_test));
        current_test = "None";
    endtask

    // Task para hacer un reset en el DUT
    task reset_bank();
        write_log("Realizando reset...");
        rst = 1;
        reset_count++;

        // Esperar dos ciclos para asegurar que el reset se haya realizado
        repeat(2) @(posedge clk);
        rst = 0;
        @(posedge clk);

        foreach(valores_esperados[i]) valores_esperados[i] = 16'h0000;
        write_log("Reset completado. Los registros están en 0");
    endtask

    // Tarea para escribir en registros
    task write_register(input [3:0] reg_addr, input [15:0] value);
        write_log($sformatf("Escribiendo %h en el registro %0d", value, reg_addr));
        write_en = 1;
        read_en = 0;
        addr = reg_addr;
        data_in = value;

        // Esperar un flanco positivo para completar la escritura
        @(posedge clk);
        write_en = 0;
        write_count++;

        // Actualizar el valor esperado si la dirección es válida 
        if (reg_addr < num_regs) begin
            valores_esperados[reg_addr] = value;
            write_log($sformatf("Escritura completada. Registro %0d = %h (esperado)", 
                              reg_addr, value));
        end else begin
            write_log("Intento de escritura en dirección invalida (no realizada)");
        end
    endtask

    // Tarea para leer un registro
    task read_register(input [3:0] reg_addr, output [15:0] value);
        write_en = 0;
        read_en = 1;
        addr = reg_addr;

        // Esperar un ciclo para completar la lectura
        @(posedge clk);
        read_en = 0;
        value = data_out;
        read_count++;
        write_log($sformatf("Lectura realizada. Registro %0d = %h", reg_addr, value));
    endtask

    // Tarea para verificar el valor de un registro
    task veri_register(input [3:0] reg_addr, input [15:0] esperado);
        logic [15:0] read_value;
        test_count++;

        read_register(reg_addr, read_value);

        if (read_value !== esperado) begin
            error_count++;
            write_log($sformatf("ERROR: Registro %0d - Esperado: %h, Leído: %h", 
                              reg_addr, esperado, read_value));
            $error("[T=%0t] Error en el registro %0d Esperado: %h, Leído %h", 
                  $time, reg_addr, esperado, read_value);
        end else begin
            write_log($sformatf("Registro %0d verificado correctamente: %h",
                              reg_addr, read_value));
        end
    endtask

    // Tarea para generar transacciones aleatorias
    task random_transaction();
        bit do_write;
        bit [3:0] rand_addr;
        bit [15:0] rand_data;

        // Se generan valores aleatorios 
        do_write = $urandom_range(0,1);
        rand_addr = $urandom_range(0, 15);
        rand_data = $urandom;

        if (do_write) begin
            write_register(rand_addr, rand_data);
        end else begin
            // Este es el caso de la lectura
            // Se verifica comparando con el valor esperado
            logic [15:0] esperado = (rand_addr < num_regs) ?
                                  valores_esperados[rand_addr] : 16'h0000;
            veri_register(rand_addr, esperado);
        end
    endtask

    // Función para generar el reporte final
    function void generate_report();
        string result;

        // Determinar el resultado
        if (error_count == 0) begin
            result = "HA PASADO";
            $display("Las pruebas pasaron correctamente");
        end else begin
            result = "HA FALLADO";
            $display("Han ocurrido errores en las pruebas");
        end

        // Escribir el reporte detallado
        $fdisplay(report_file_, "===================================");
        $fdisplay(report_file_, "    Reporte final de pruebas - Banco de Registros");
        $fdisplay(report_file_, "===================================");
        $fdisplay(report_file_, "Fecha de ejecución: %t", $time);
        $fdisplay(report_file_, "Resultado general: %s", result);
        $fdisplay(report_file_, "Tiempo de simulacion: %0t ns", $time);
        $fdisplay(report_file_, "===================================");
        $fdisplay(report_file_, "Metricas de la prueba");
        $fdisplay(report_file_, "- Pruebas ejecutadas: %0d", test_count);
        $fdisplay(report_file_, "- Operaciones de escritura hechas: %0d", write_count);
        $fdisplay(report_file_, "- Operaciones de lectura hechas: %0d", read_count);
        $fdisplay(report_file_, "- Resets realizados: %0d", reset_count);
        $fdisplay(report_file_, "- Errores encontrados: %0d", error_count);
        $fdisplay(report_file_, "===================================");
        $fdisplay(report_file_, "Detalles finales de los registros: ");

        // Reporte de los registros al final de la prueba
        for (int i = 0; i < num_regs; i++) begin
            $fdisplay(report_file_, "Registro %2d: %h", i, valores_esperados[i]);
        end
        $fdisplay(report_file_, "=======================");
        $fdisplay(report_file_, "FIN");

        // Imprimir resultados en la terminal
        $display("===================================");
        $display("    Reporte final de pruebas - Banco de Registros");
        $display("===================================");
        $display("Resultado general: %s", result);
        $display("===================================");
        $display("- Pruebas ejecutadas: %0d", test_count);
        $display("- Operaciones de escritura hechas: %0d", write_count);
        $display("- Operaciones de lectura hechas: %0d", read_count);
        $display("- Resets realizados: %0d", reset_count);
        $display("- Errores encontrados: %0d", error_count);
        $display("- log de simulación: %s", log_file);
        $display("- reporte final: %s", report_file);
        $display("===================================");
    endfunction

    // Procedimiento de prueba
    initial begin
        // Iniciar archivos 
        log_file_ = $fopen(log_file, "w");
        report_file_ = $fopen(report_file, "w");

        if (!log_file_) begin
            $error("No se puede abrir el archivo log: %s", log_file);
            $finish;
        end

        if (!report_file_) begin
            $error("No se puede abrir el archivo reporte: %s", report_file);
            $finish;
        end

        // Escribir encabezado en archivo de log
        $fdisplay(log_file_, "============================================");
        $fdisplay(log_file_, " LOG DE SIMULACIÓN - BANCO DE REGISTROS");
        $fdisplay(log_file_, "============================================");
        $fdisplay(log_file_, "Fecha de inicio: %t", $time);
        $fdisplay(log_file_, "Configuración:");
        $fdisplay(log_file_, " - Número de registros: %0d", num_regs);
        $fdisplay(log_file_, " - Pruebas aleatorias: %0d", num_random_tests);
        $fdisplay(log_file_, " - Semilla aleatoria: %0d", semilla);
        $fdisplay(log_file_, "============================================");

        // Configurar la semilla
        write_log($sformatf("Iniciando simulación con semilla %0d", semilla));
        $urandom(semilla);

        // Configurar archivos para la visualización en gtkwave
        $dumpfile("tester.vcd");
        $dumpvars(0, tester);

        // Prueba estructurada:

        // 1. Reset inicial y verificación
        begin_test("Reset Inicial");
        reset_bank();
        for (int i = 0; i < num_regs; i++) begin
            veri_register(i, 16'h0000);
        end
        end_test();

        // 2. Prueba de lectura y escritura básica
        begin_test("Prueba de lectura y escritura básica");
        for (int i = 0; i < num_regs; i++) begin
            logic [15:0] test_data = 16'h1234 + i;
            write_register(i, test_data);
            veri_register(i, test_data);
        end
        end_test();

        // 3. Prueba de valores extremos
        begin_test("Prueba de valores extremos");
        write_register(0, 16'h0000);
        write_register(1, 16'hFFFF);
        write_register(2, 16'hAAAA);
        write_register(3, 16'h5555);
        veri_register(0, 16'h0000);
        veri_register(1, 16'hFFFF);
        veri_register(2, 16'hAAAA);
        veri_register(3, 16'h5555);
        end_test();

        // 4. Prueba de direcciones inválidas
        begin_test("Prueba de direcciones inválidas");
        write_register(4'b1110, 16'hDEAD);
        write_register(4'b1111, 16'hBEEF);
        veri_register(4'b1110, 16'h0000);
        veri_register(4'b1111, 16'h0000);
        end_test();
        
        // 5. Prueba de condiciones de carrera
        begin_test("Prueba de condiciones de carrera");
        @(negedge clk);
        data_in = 16'hBEEF;
        write_en = 1;
        addr = 4'b0100;
        @(posedge clk);
        write_en = 0;
        veri_register(4'b0100, 16'hBEEF);
        end_test();
        
        // 6. Reset durante operación
        begin_test("Prueba de reset durante operación");
        write_en = 1;
        addr = 4'b0110;
        data_in = 16'h1234;
        @(negedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
        write_en = 0;
        veri_register(4'b0110, 16'h0000);
        end_test();
        
        // Pruebas aleatorias
        begin_test($sformatf("Pruebas aleatorias (%0d transacciones)", num_random_tests));
        for (int i = 0; i < num_random_tests; i++) begin
            write_log($sformatf("\n--- Prueba aleatoria %0d/%0d ---", i+1, num_random_tests));
            random_transaction();
            
            // Aplicar reset aleatorio con 5% de probabilidad
            if ($urandom_range(0, 99) < 5) begin
                reset_bank();
            end
        end
        end_test();
        
        // Finalización y reportes
        generate_report();
        
        // Cerrar archivos
        $fclose(log_file_);
        $fclose(report_file_);
        
        // Finalizar simulación
        #100 $finish;
    end

endmodule
