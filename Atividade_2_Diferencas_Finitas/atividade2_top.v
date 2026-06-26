// Topo simples para demonstracao na DE1.
//
// SW[9:0] = valor usado para carregar coeficientes ou quantidade.
// KEY[0]  = clock manual da FSM.
// KEY[1]  = carrega coeficiente a.
// KEY[2]  = carrega coeficiente b.
// KEY[3]  = carrega coeficiente c quando SW[9] = 0.
// KEY[3]  = inicio quando SW[9] = 1.
//
// Para a quantidade de valores, use SW[3:0] antes de apertar inicio.
module atividade2_top (
    input  wire [9:0] SW,
    input  wire [3:0] KEY,
    output wire [9:0] LEDR,
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

    wire [3:0] milhar;
    wire [3:0] centena;
    wire [3:0] dezena;
    wire [3:0] unidade;

    diferencas_finitas_grau2 fsm (
        .clk           (~KEY[0]),
        .inicio        ((~KEY[3]) & SW[9]),
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

    bin10_para_bcd conv (
        .bin     (valor_saida),
        .milhar  (milhar),
        .centena (centena),
        .dezena  (dezena),
        .unidade (unidade)
    );

    hex7seg h0 (.digito(unidade), .hex(HEX0));
    hex7seg h1 (.digito(dezena),  .hex(HEX1));
    hex7seg h2 (.digito(centena), .hex(HEX2));
    hex7seg h3 (.digito(milhar),  .hex(HEX3));

    assign LEDR[0] = valor_pronto;
    assign LEDR[1] = concluido;
    assign LEDR[2] = overflow;
    assign LEDR[6:3] = estado;
    assign LEDR[9:7] = indice[2:0];

endmodule
