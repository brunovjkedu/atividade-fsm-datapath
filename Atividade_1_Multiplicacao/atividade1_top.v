// Topo simples para a placa DE1.
//
// Controles usados:
// SW[9:0] = valor a carregar
// KEY[0]  = clock manual da FSM
// KEY[1]  = carrega SW em A
// KEY[2]  = carrega SW em B
// KEY[3]  = inicio
//
// Observacao: os botoes KEY da DE1 sao ativos em nivel baixo.
module atividade1_top (
    input  wire [9:0] SW,
    input  wire [3:0] KEY,
    output wire [9:0] LEDR,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3
);

    wire [9:0] resultado;
    wire       concluido;
    wire       overflow;
    wire [3:0] estado;

    wire [3:0] milhar;
    wire [3:0] centena;
    wire [3:0] dezena;
    wire [3:0] unidade;

    multiplicador_somas_deslocamentos mult (
        .clk           (~KEY[0]),
        .inicio        (~KEY[3]),
        .load_a        (~KEY[1]),
        .load_b        (~KEY[2]),
        .valor_entrada (SW),
        .resultado     (resultado),
        .concluido     (concluido),
        .overflow      (overflow),
        .estado_atual  (estado)
    );

    bin10_para_bcd conv (
        .bin     (resultado),
        .milhar  (milhar),
        .centena (centena),
        .dezena  (dezena),
        .unidade (unidade)
    );

    hex7seg h0 (.digito(unidade), .hex(HEX0));
    hex7seg h1 (.digito(dezena),  .hex(HEX1));
    hex7seg h2 (.digito(centena), .hex(HEX2));
    hex7seg h3 (.digito(milhar),  .hex(HEX3));

    assign LEDR[0] = concluido;
    assign LEDR[1] = overflow;
    assign LEDR[5:2] = estado;
    assign LEDR[9:6] = 4'b0000;

endmodule
