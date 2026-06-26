// Converte um numero binario de 10 bits (0 a 1023) para BCD.
// Metodo shift-add-3, usado apenas para mostrar o resultado em decimal.
module bin10_para_bcd (
    input  wire [9:0] bin,
    output reg  [3:0] milhar,
    output reg  [3:0] centena,
    output reg  [3:0] dezena,
    output reg  [3:0] unidade
);

    integer i;
    reg [15:0] bcd;

    always @(*) begin
        bcd = 16'd0;

        for (i = 9; i >= 0; i = i - 1) begin
            if (bcd[3:0] >= 4'd5)
                bcd[3:0] = bcd[3:0] + 4'd3;
            if (bcd[7:4] >= 4'd5)
                bcd[7:4] = bcd[7:4] + 4'd3;
            if (bcd[11:8] >= 4'd5)
                bcd[11:8] = bcd[11:8] + 4'd3;
            if (bcd[15:12] >= 4'd5)
                bcd[15:12] = bcd[15:12] + 4'd3;

            bcd = {bcd[14:0], bin[i]};
        end

        unidade = bcd[3:0];
        dezena  = bcd[7:4];
        centena = bcd[11:8];
        milhar  = bcd[15:12];
    end

endmodule
