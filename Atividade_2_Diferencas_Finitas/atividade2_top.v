// Topo simples para demonstracao na DE1.
//
// CLOCK_50 = clock da placa, usado apenas para limpar o botao KEY0.
// SW[9:0] = valor usado para carregar coeficientes ou quantidade.
// KEY[0]  = clock manual da FSM.
// KEY[1]  = carrega coeficiente a.
// KEY[2]  = carrega coeficiente b.
// KEY[3]  = carrega coeficiente c quando SW[9] = 0.
// KEY[3]  = inicio quando SW[9] = 1.
// LEDG[0] = valor pronto.
// LEDG[1] = concluido.
// LEDG[2] = overflow ao concluir.
//
// Para a quantidade de valores, use SW[3:0] antes de apertar inicio.
module atividade2_top (
    input  wire       CLOCK_50,
    input  wire [9:0] SW,
    input  wire [3:0] KEY,
    output wire [9:0] LEDR,
    output wire [7:0] LEDG,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3
);

    wire [9:0] valor_saida;
    wire       valor_pronto;
    wire       concluido;
    wire       overflow;
    wire [3:0] estado;
    wire [9:0] indice;
    wire       pulso_key0;
    wire       inicio;
    wire [9:0] valor_display;
    reg  [9:0] ultimo_valor_carregado;

    wire [3:0] milhar;
    wire [3:0] centena;
    wire [3:0] dezena;
    wire [3:0] unidade;

    assign inicio = (~KEY[3]) & SW[9];

    botao_pulso clock_manual (
        .clk      (CLOCK_50),
        .botao_n  (KEY[0]),
        .pulso    (pulso_key0)
    );

    initial begin
        ultimo_valor_carregado = 10'd0;
    end

    always @(posedge CLOCK_50) begin
        if ((~KEY[0]) && !inicio)
            ultimo_valor_carregado <= 10'd0;
        else if ((~KEY[1]) || (~KEY[2]) || ((~KEY[3]) && (~SW[9])))
            ultimo_valor_carregado <= SW;
    end

    diferencas_finitas_grau2 fsm (
        .clk           (pulso_key0),
        .inicio        (inicio),
        .load_a        (~KEY[1]),
        .load_b        (~KEY[2]),
        .load_c        ((~KEY[3]) & (~SW[9])),
        .valor_entrada (SW),
        .quantidade    ({6'd0, SW[3:0]}),
        .valor_saida   (valor_saida),
        .valor_pronto  (valor_pronto),
        .concluido     (concluido),
        .overflow      (overflow),
        .estado_atual  (estado),
        .indice_atual  (indice)
    );

    assign valor_display = (valor_pronto || concluido || inicio) ? valor_saida : ultimo_valor_carregado;

    bin10_para_bcd conv (
        .bin     (valor_display),
        .milhar  (milhar),
        .centena (centena),
        .dezena  (dezena),
        .unidade (unidade)
    );

    hex7seg h0 (.digito(unidade), .hex(HEX0));
    hex7seg h1 (.digito(dezena),  .hex(HEX1));
    hex7seg h2 (.digito(centena), .hex(HEX2));
    hex7seg h3 (.digito(milhar),  .hex(HEX3));

    assign LEDG[0] = valor_pronto;
    assign LEDG[1] = concluido;
    assign LEDG[2] = concluido & overflow;
    assign LEDG[7:3] = 5'b00000;

    assign LEDR = 10'b0000000000;

endmodule
