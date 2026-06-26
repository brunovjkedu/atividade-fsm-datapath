// Topo simples para a placa DE1.
//
// Controles usados:
// CLOCK_50 = clock da placa, usado apenas para limpar o botao KEY0
// SW[9:0] = valor a carregar
// KEY[0]  = clock manual da FSM
// KEY[1]  = carrega SW em A
// KEY[2]  = carrega SW em B
// KEY[3]  = inicio
// LEDG[0] = concluido
// LEDG[1] = overflow
//
// Observacao: os botoes KEY da DE1 sao ativos em nivel baixo.
module atividade1_top (
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

    wire [9:0] resultado;
    wire       concluido;
    wire       overflow;
    wire [3:0] estado;
    wire       pulso_key0;
    wire [9:0] valor_display;

    wire [3:0] milhar;
    wire [3:0] centena;
    wire [3:0] dezena;
    wire [3:0] unidade;

    botao_pulso clock_manual (
        .clk      (CLOCK_50),
        .botao_n  (KEY[0]),
        .pulso    (pulso_key0)
    );

    multiplicador_somas_deslocamentos mult (
        .clk           (pulso_key0),
        .inicio        (~KEY[3]),
        .load_a        (~KEY[1]),
        .load_b        (~KEY[2]),
        .valor_entrada (SW),
        .resultado     (resultado),
        .concluido     (concluido),
        .overflow      (overflow),
        .estado_atual  (estado)
    );

    assign valor_display = ((~KEY[1]) || (~KEY[2])) ? SW : resultado;

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

    assign LEDG[0] = concluido;
    assign LEDG[1] = concluido & overflow;
    assign LEDG[7:2] = 6'b000000;

    assign LEDR = 10'b0000000000;

endmodule
