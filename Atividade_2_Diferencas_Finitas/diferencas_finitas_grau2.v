// Atividade 2 - Diferencas finitas para polinomio de grau 2.
//
// Polinomio: p(n) = a*n*n + b*n + c
//
// Valores iniciais:
// y  = p(0) = c
// d1 = p(1) - p(0) = a + b
// d2 = segunda diferenca = 2*a
//
// Para cada novo valor:
// y  = y + d1
// d1 = d1 + d2
module diferencas_finitas_grau2 (
    input  wire        clk,
    input  wire        inicio,
    input  wire        load_a,
    input  wire        load_b,
    input  wire        load_c,
    input  wire [9:0]  valor_entrada,
    input  wire [9:0]  quantidade,

    output wire [9:0]  valor_saida,
    output wire        valor_pronto,
    output wire        concluido,
    output wire        overflow,
    output wire [3:0]  estado_atual,
    output wire [9:0]  indice_atual
);

    localparam R_A   = 3'd0;
    localparam R_B   = 3'd1;
    localparam R_Y   = 3'd2;
    localparam R_D1  = 3'd3;
    localparam R_D2  = 3'd4;

    localparam OP_ADD = 3'b011;

    localparam S_IDLE         = 4'd0;
    localparam S_PREP_D2      = 4'd1;
    localparam S_WRITE_D2     = 4'd2;
    localparam S_PREP_D1      = 4'd3;
    localparam S_WRITE_D1     = 4'd4;
    localparam S_MOSTRA       = 4'd5;
    localparam S_PREP_Y       = 4'd6;
    localparam S_WRITE_Y      = 4'd7;
    localparam S_PREP_PROX_D1 = 4'd8;
    localparam S_WRITE_PROX_D1 = 4'd9;
    localparam S_INC          = 4'd10;
    localparam S_FIM          = 4'd11;

    reg [3:0] estado;
    reg [3:0] proximo_estado;
    reg [9:0] contador;
    reg [9:0] qtd_reg;
    reg       overflow_reg;

    reg       write_enable;
    reg [2:0] sel_ra;
    reg [2:0] sel_rb;
    reg [2:0] sel_rw;
    reg [2:0] sel_op;
    reg       mux_w_sel;
    reg [9:0] ext_w;

    wire [9:0] va;
    wire [9:0] vb;
    wire [9:0] s;
    wire       z;
    wire       c;
    wire       escreve_dp;

    assign escreve_dp = (estado == S_IDLE) ? (load_a | load_b | load_c) : (write_enable & ~clk);

    initial begin
        estado = S_IDLE;
        contador = 10'd0;
        qtd_reg = 10'd0;
        overflow_reg = 1'b0;
    end

    datapath dp (
        .clk       (clk),
        .escreve   (escreve_dp),
        .sel_ra    (sel_ra),
        .sel_rb    (sel_rb),
        .sel_rw    (sel_rw),
        .sel_op    (sel_op),
        .mux_w_sel (mux_w_sel),
        .ext_w     (ext_w),
        .va        (va),
        .vb        (vb),
        .s         (s),
        .z         (z),
        .c         (c)
    );

    assign valor_saida = va;
    assign valor_pronto = (estado == S_MOSTRA);
    assign concluido = (estado == S_FIM);
    assign overflow = overflow_reg;
    assign estado_atual = estado;
    assign indice_atual = contador;

    always @(*) begin
        proximo_estado = estado;

        case (estado)
            S_IDLE: begin
                if (inicio)
                    proximo_estado = S_PREP_D2;
            end

            S_PREP_D2: proximo_estado = S_WRITE_D2;
            S_WRITE_D2: proximo_estado = S_PREP_D1;
            S_PREP_D1: proximo_estado = S_WRITE_D1;

            S_WRITE_D1: begin
                if (qtd_reg == 10'd0)
                    proximo_estado = S_FIM;
                else
                    proximo_estado = S_MOSTRA;
            end

            S_MOSTRA: begin
                if (contador + 10'd1 >= qtd_reg)
                    proximo_estado = S_FIM;
                else
                    proximo_estado = S_PREP_Y;
            end

            S_PREP_Y: proximo_estado = S_WRITE_Y;
            S_WRITE_Y: proximo_estado = S_PREP_PROX_D1;
            S_PREP_PROX_D1: proximo_estado = S_WRITE_PROX_D1;
            S_WRITE_PROX_D1: proximo_estado = S_INC;
            S_INC: proximo_estado = S_MOSTRA;

            S_FIM: begin
                if (!inicio)
                    proximo_estado = S_IDLE;
            end

            default: proximo_estado = S_IDLE;
        endcase
    end

    always @(posedge clk) begin
        estado <= proximo_estado;

        if (estado == S_IDLE && inicio) begin
            contador <= 10'd0;
            qtd_reg <= quantidade;
            overflow_reg <= 1'b0;
        end else begin
            if (estado == S_PREP_D2 || estado == S_PREP_D1 || estado == S_PREP_Y || estado == S_PREP_PROX_D1)
                overflow_reg <= overflow_reg | c;

            if (estado == S_INC)
                contador <= contador + 10'd1;
        end
    end

    always @(*) begin
        write_enable = 1'b0;
        sel_ra = R_Y;
        sel_rb = R_Y;
        sel_rw = R_Y;
        sel_op = OP_ADD;
        mux_w_sel = 1'b0;
        ext_w = valor_entrada;

        case (estado)
            S_IDLE: begin
                mux_w_sel = 1'b1;
                ext_w = valor_entrada;

                if (load_a) begin
                    write_enable = 1'b1;
                    sel_rw = R_A;
                end else if (load_b) begin
                    write_enable = 1'b1;
                    sel_rw = R_B;
                end else if (load_c) begin
                    write_enable = 1'b1;
                    sel_rw = R_Y;
                end
            end

            S_PREP_D2: begin
                sel_ra = R_A;
                sel_rb = R_A;
                sel_rw = R_D2;
                sel_op = OP_ADD;
            end

            S_WRITE_D2: begin
                write_enable = 1'b1;
                sel_ra = R_A;
                sel_rb = R_A;
                sel_rw = R_D2;
                sel_op = OP_ADD;
            end

            S_PREP_D1: begin
                sel_ra = R_A;
                sel_rb = R_B;
                sel_rw = R_D1;
                sel_op = OP_ADD;
            end

            S_WRITE_D1: begin
                write_enable = 1'b1;
                sel_ra = R_A;
                sel_rb = R_B;
                sel_rw = R_D1;
                sel_op = OP_ADD;
            end

            S_MOSTRA: begin
                sel_ra = R_Y;
            end

            S_PREP_Y: begin
                sel_ra = R_Y;
                sel_rb = R_D1;
                sel_rw = R_Y;
                sel_op = OP_ADD;
            end

            S_WRITE_Y: begin
                write_enable = 1'b1;
                sel_ra = R_Y;
                sel_rb = R_D1;
                sel_rw = R_Y;
                sel_op = OP_ADD;
            end

            S_PREP_PROX_D1: begin
                sel_ra = R_D1;
                sel_rb = R_D2;
                sel_rw = R_D1;
                sel_op = OP_ADD;
            end

            S_WRITE_PROX_D1: begin
                write_enable = 1'b1;
                sel_ra = R_D1;
                sel_rb = R_D2;
                sel_rw = R_D1;
                sel_op = OP_ADD;
            end

            S_FIM: begin
                sel_ra = R_Y;
            end
        endcase
    end

endmodule
