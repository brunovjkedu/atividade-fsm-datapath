`timescale 1ns/1ps

module tb_atividade2;

    reg clk;
    reg inicio;
    reg load_a;
    reg load_b;
    reg load_c;
    reg [9:0] valor_entrada;
    reg [9:0] quantidade;

    wire [9:0] valor_saida;
    wire valor_pronto;
    wire concluido;
    wire overflow;
    wire [3:0] estado_atual;
    wire [9:0] indice_atual;

    integer pass_count;
    integer fail_count;
    integer ciclos;

    diferencas_finitas_grau2 dut (
        .clk           (clk),
        .inicio        (inicio),
        .load_a        (load_a),
        .load_b        (load_b),
        .load_c        (load_c),
        .valor_entrada (valor_entrada),
        .quantidade    (quantidade),
        .valor_saida   (valor_saida),
        .valor_pronto  (valor_pronto),
        .concluido     (concluido),
        .overflow      (overflow),
        .estado_atual  (estado_atual),
        .indice_atual  (indice_atual)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task pulso;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task carregar;
        input [1:0] qual;
        input [9:0] valor;
        begin
            valor_entrada = valor;
            load_a = (qual == 2'd0);
            load_b = (qual == 2'd1);
            load_c = (qual == 2'd2);
            #2;
            load_a = 1'b0;
            load_b = 1'b0;
            load_c = 1'b0;
            #2;
        end
    endtask

    task espera_valor;
        input [9:0] esperado;
        input [9:0] indice_esperado;
        begin
            ciclos = 0;
            while (!valor_pronto && !concluido && ciclos < 50) begin
                pulso;
                ciclos = ciclos + 1;
            end

            #2;
            if (valor_pronto && valor_saida === esperado && indice_atual === indice_esperado) begin
                $display("[PASS] n=%0d valor=%0d", indice_atual, valor_saida);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] n=%0d valor=%0d esperado=%0d pronto=%b fim=%b",
                         indice_atual, valor_saida, esperado, valor_pronto, concluido);
                fail_count = fail_count + 1;
            end

            pulso;
        end
    endtask

    initial begin
        $dumpfile("tb_atividade2.vcd");
        $dumpvars(0, tb_atividade2);

        inicio = 1'b0;
        load_a = 1'b0;
        load_b = 1'b0;
        load_c = 1'b0;
        valor_entrada = 10'd0;
        quantidade = 10'd0;
        pass_count = 0;
        fail_count = 0;

        #10;

        // p(n) = 2n^2 + 3n + 1
        // valores: 1, 6, 15, 28, 45
        carregar(2'd0, 10'd2);
        carregar(2'd1, 10'd3);
        carregar(2'd2, 10'd1);
        quantidade = 10'd5;
        inicio = 1'b1;

        espera_valor(10'd1,  10'd0);
        espera_valor(10'd6,  10'd1);
        espera_valor(10'd15, 10'd2);
        espera_valor(10'd28, 10'd3);
        espera_valor(10'd45, 10'd4);

        while (!concluido && ciclos < 50)
            pulso;

        if (concluido) begin
            $display("[PASS] concluido");
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] nao concluiu");
            fail_count = fail_count + 1;
        end

        inicio = 1'b0;
        pulso;

        $display("Resultado final: %0d PASS, %0d FAIL", pass_count, fail_count);
        $finish;
    end

endmodule
