// Atividade 1 - Multiplicacao por somas e deslocamentos.
//
// Uso dos registradores do datapath:
// R0 = operando A carregado externamente
// R1 = operando B carregado externamente
// R2 = acumulador / resultado
// R3 = multiplicando deslocado
// R4 = multiplicador deslocado
// R5 = constante 1
module multiplicador_somas_deslocamentos (
    input  wire        clk,
    input  wire        inicio,
    input  wire        load_a,
    input  wire        load_b,
    input  wire [9:0]  valor_entrada,

    output wire [9:0]  resultado,
    output wire        concluido,
    output wire        overflow,
    output wire [3:0]  estado_atual
);

    localparam R_A     = 3'd0;
    localparam R_B     = 3'd1;
    localparam R_RES   = 3'd2;
    localparam R_MCDO  = 3'd3;
    localparam R_MDOR  = 3'd4;
    localparam R_UM    = 3'd5;

    localparam OP_SLL  = 3'b001;
    localparam OP_SRL  = 3'b010;
    localparam OP_ADD  = 3'b011;
    localparam OP_AND  = 3'b100;

    localparam S_IDLE        = 4'd0;
    localparam S_INIT_RES    = 4'd1;
    localparam S_INIT_UM     = 4'd2;
    localparam S_COPIA_A     = 4'd3;
    localparam S_COPIA_B     = 4'd4;
    localparam S_TESTA       = 4'd5;
    localparam S_PREP_SOMA   = 4'd6;
    localparam S_SOMA        = 4'd7;
    localparam S_PREP_DESL_A = 4'd8;
    localparam S_DESL_A      = 4'd9;
    localparam S_DESL_B      = 4'd10;
    localparam S_INC         = 4'd11;
    localparam S_FIM         = 4'd12;

    reg [3:0] estado;
    reg [3:0] proximo_estado;
    reg [3:0] contador;
    reg       overflow_reg;
    reg       termo_maior_10bits;
    reg       tem_mais_bits;

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

    assign escreve_dp = (estado == S_IDLE) ? (load_a | load_b) : (write_enable & ~clk);

    initial begin
        estado = S_IDLE;
        contador = 4'd0;
        overflow_reg = 1'b0;
        termo_maior_10bits = 1'b0;
        tem_mais_bits = 1'b0;
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

    assign resultado = va;
    assign concluido = (estado == S_FIM);
    assign overflow = overflow_reg;
    assign estado_atual = estado;

    always @(*) begin
        proximo_estado = estado;

        case (estado)
            S_IDLE: begin
                if (inicio)
                    proximo_estado = S_INIT_RES;
            end

            S_INIT_RES: proximo_estado = S_INIT_UM;
            S_INIT_UM:  proximo_estado = S_COPIA_A;
            S_COPIA_A:  proximo_estado = S_COPIA_B;
            S_COPIA_B:  proximo_estado = S_TESTA;

            S_TESTA: begin
                if (va == 10'd0) begin
                    proximo_estado = S_FIM;
                end else if (s == 10'd0) begin
                    if (contador == 4'd9)
                        proximo_estado = S_FIM;
                    else
                        proximo_estado = S_PREP_DESL_A;
                end else begin
                    proximo_estado = S_PREP_SOMA;
                end
            end

            S_PREP_SOMA: proximo_estado = S_SOMA;

            S_SOMA: begin
                if (contador == 4'd9 || !tem_mais_bits)
                    proximo_estado = S_FIM;
                else
                    proximo_estado = S_PREP_DESL_A;
            end

            S_PREP_DESL_A: proximo_estado = S_DESL_A;
            S_DESL_A: proximo_estado = S_DESL_B;
            S_DESL_B: proximo_estado = S_INC;
            S_INC:    proximo_estado = S_TESTA;

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
            contador <= 4'd0;
            overflow_reg <= 1'b0;
            termo_maior_10bits <= 1'b0;
            tem_mais_bits <= 1'b0;
        end else begin
            if (estado == S_TESTA)
                tem_mais_bits <= (va > 10'd1);

            if (estado == S_PREP_SOMA)
                overflow_reg <= overflow_reg | c | termo_maior_10bits;

            if (estado == S_PREP_DESL_A && tem_mais_bits)
                termo_maior_10bits <= termo_maior_10bits | c;

            if (estado == S_INC)
                contador <= contador + 4'd1;
        end
    end

    always @(*) begin
        write_enable = 1'b0;
        sel_ra = R_RES;
        sel_rb = R_RES;
        sel_rw = R_RES;
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
                end
            end

            S_INIT_RES: begin
                write_enable = 1'b1;
                sel_rw = R_RES;
                mux_w_sel = 1'b1;
                ext_w = 10'd0;
            end

            S_INIT_UM: begin
                write_enable = 1'b1;
                sel_rw = R_UM;
                mux_w_sel = 1'b1;
                ext_w = 10'd1;
            end

            S_COPIA_A: begin
                write_enable = 1'b1;
                sel_ra = R_A;
                sel_rb = R_RES;
                sel_rw = R_MCDO;
                sel_op = OP_ADD;
            end

            S_COPIA_B: begin
                write_enable = 1'b1;
                sel_ra = R_B;
                sel_rb = R_RES;
                sel_rw = R_MDOR;
                sel_op = OP_ADD;
            end

            S_TESTA: begin
                sel_ra = R_MDOR;
                sel_rb = R_UM;
                sel_op = OP_AND;
            end

            S_PREP_SOMA: begin
                sel_ra = R_RES;
                sel_rb = R_MCDO;
                sel_rw = R_RES;
                sel_op = OP_ADD;
            end

            S_SOMA: begin
                write_enable = 1'b1;
                sel_ra = R_RES;
                sel_rb = R_MCDO;
                sel_rw = R_RES;
                sel_op = OP_ADD;
            end

            S_PREP_DESL_A: begin
                sel_ra = R_MCDO;
                sel_rb = R_UM;
                sel_rw = R_MCDO;
                sel_op = OP_SLL;
            end

            S_DESL_A: begin
                write_enable = 1'b1;
                sel_ra = R_MCDO;
                sel_rb = R_UM;
                sel_rw = R_MCDO;
                sel_op = OP_SLL;
            end

            S_DESL_B: begin
                write_enable = 1'b1;
                sel_ra = R_MDOR;
                sel_rb = R_UM;
                sel_rw = R_MDOR;
                sel_op = OP_SRL;
            end

            S_FIM: begin
                sel_ra = R_RES;
            end
        endcase
    end

endmodule
