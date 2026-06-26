module tb_atividade1;

    // Sinais que simulam botoes, switches e saidas principais.
    reg clk;
    reg inicio;
    reg load_a;
    reg load_b;
    reg [9:0] valor_entrada;

    wire [9:0] resultado;
    wire concluido;
    wire overflow;
    wire [3:0] estado_atual;

    integer pass_count;
    integer fail_count;

    multiplicador_somas_deslocamentos dut (
        .clk           (clk),
        .inicio        (inicio),
        .load_a        (load_a),
        .load_b        (load_b),
        .valor_entrada (valor_entrada),
        .resultado     (resultado),
        .concluido     (concluido),
        .overflow      (overflow),
        .estado_atual  (estado_atual)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // Um pulso de clock da FSM.
    task pulso;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task carregar_a;
        input [9:0] valor;
        begin
            // Simula apertar KEY1 com o valor nos switches.
            valor_entrada = valor;
            load_a = 1'b1; #2;
            load_a = 1'b0; #2;
        end
    endtask

    task carregar_b;
        input [9:0] valor;
        begin
            // Simula apertar KEY2 com o valor nos switches.
            valor_entrada = valor;
            load_b = 1'b1; #2;
            load_b = 1'b0; #2;
        end
    endtask

    task testar;
        input [9:0] a;
        input [9:0] b;
        input [9:0] esperado;
        input       overflow_esperado;
        integer ciclos;
        begin
            // Carrega operandos, inicia a FSM e espera o estado final.
            inicio = 1'b0;
            carregar_a(a);
            carregar_b(b);

            inicio = 1'b1;
            ciclos = 0;

            while (!concluido && ciclos < 80) begin
                pulso;
                ciclos = ciclos + 1;
            end

            #2;
            if (resultado === esperado && overflow === overflow_esperado && concluido === 1'b1) begin
                $display("[PASS] %0d * %0d = %0d overflow=%b ciclos=%0d",
                         a, b, resultado, overflow, ciclos);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] %0d * %0d -> res=%0d esp=%0d ov=%b esp=%b fim=%b ciclos=%0d",
                         a, b, resultado, esperado, overflow, overflow_esperado,
                         concluido, ciclos);
                fail_count = fail_count + 1;
            end

            inicio = 1'b0;
            pulso;
        end
    endtask

    initial begin
        $dumpfile("tb_atividade1.vcd");
        $dumpvars(0, tb_atividade1);

        inicio = 1'b0;
        load_a = 1'b0;
        load_b = 1'b0;
        valor_entrada = 10'd0;
        pass_count = 0;
        fail_count = 0;

        #10;

        testar(10'd3,   10'd5,  10'd15,  1'b0);
        testar(10'd0,   10'd789, 10'd0,  1'b0);
        testar(10'd31,  10'd33, 10'd1023, 1'b0);
        testar(10'd32,  10'd32, 10'd0,   1'b1);
        testar(10'd600, 10'd1,  10'd600, 1'b0);
        testar(10'd512, 10'd2,  10'd0,   1'b1);

        $display("Resultado final: %0d PASS, %0d FAIL", pass_count, fail_count);
        $finish;
    end

endmodule
