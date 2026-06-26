// Gera um pulso de 1 ciclo de CLOCK_50 quando o botao e apertado.
// O botao da DE1 e ativo em nivel baixo.
module botao_pulso (
    input  wire clk,
    input  wire botao_n,
    output reg  pulso
);

    reg [19:0] contador;
    reg botao_sync0;
    reg botao_sync1;
    reg botao_estavel;
    reg botao_anterior;

    wire botao_apertado;

    assign botao_apertado = ~botao_sync1;

    initial begin
        contador = 20'd0;
        botao_sync0 = 1'b1;
        botao_sync1 = 1'b1;
        botao_estavel = 1'b0;
        botao_anterior = 1'b0;
        pulso = 1'b0;
    end

    always @(posedge clk) begin
        botao_sync0 <= botao_n;
        botao_sync1 <= botao_sync0;
        pulso <= 1'b0;

        if (botao_apertado == botao_estavel) begin
            contador <= 20'd0;
        end else begin
            contador <= contador + 20'd1;

            if (contador == 20'd500000) begin
                botao_estavel <= botao_apertado;
                contador <= 20'd0;

                if (botao_apertado && !botao_anterior)
                    pulso <= 1'b1;

                botao_anterior <= botao_apertado;
            end
        end
    end

endmodule
