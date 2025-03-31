//////////////////////////////////////////////////////////
// Testbench para el banco de registros
//////////////////////////////////////////////////////////

module tb_top;

    // Señales de entrada
    reg clk, rst, write_en, read_en;
    reg [3:0] addr;
    reg [15:0] data_in;

    // Señales de salida
    wire [15:0] data_out;

    // Instancia del módulo top
    top uut (
        .clk(clk),
        .rst(rst),
        .write_en(write_en),
        .read_en(read_en),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Generación del reloj (alternando cada 5 unidades de tiempo)
    always begin
        #5 clk = ~clk;
    end

    // Procedimiento inicial para estímulos
    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 0;
        write_en = 0;
        read_en = 0;
        addr = 4'b0000;
        data_in = 16'h0000;

        // Abrir archivo VCD
        // El archivo VCD es para el test
        $dumpfile("simulation.vcd");  // Establece el nombre del archivo VCD
        $dumpvars(0, tb_top);         // Registra todas las señales del testbench

        // Aplicar reset
        #10 rst = 1;  // Activar el reset
        #10 rst = 0;  // Desactivar el reset

        // Escribir datos en el registro 0
        write_en = 1;
        addr = 4'b0000;  // Dirección del registro 0
        data_in = 16'h1234;  // Datos a escribir
        #10 write_en = 0;

        // Leer del registro 0
        read_en = 1;
        addr = 4'b0000;  // Dirección del registro 0
        #10 read_en = 0;
        $display("Dato leído: %h", data_out); // Debe mostrar 1234

        // Escribir en otro registro (registro 1)
        write_en = 1;
        addr = 4'b0001;  // Dirección del registro 1
        data_in = 16'hABCD;  // Datos a escribir
        #10 write_en = 0;

        // Leer del registro 1
        read_en = 1;
        addr = 4'b0001;  // Dirección del registro 1
        #10 read_en = 0;
        $display("Dato leído: %h", data_out); // Debe mostrar ABCD

        // Probar la escritura en otros registros
        write_en = 1;
        addr = 4'b0010;  // Dirección del registro 2
        data_in = 16'h9876;  // Datos a escribir
        #10 write_en = 0;

        // Leer del registro 2
        read_en = 1;
        addr = 4'b0010;  // Dirección del registro 2
        #10 read_en = 0;
        $display("Dato leído: %h", data_out); // Debe mostrar 9876

        // Finalizar la simulación
        #10 $finish;
    end

endmodule
