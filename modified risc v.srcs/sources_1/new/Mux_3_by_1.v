module Mux_3_by_1 (a, b, c, s, d);
    input [31:0] a, b, c;
    input [1:0] s;
    output reg [31:0] d;

    always @(*) begin
        if (s == 2'b00) begin
            d = a;
        end else if (s == 2'b01) begin
            d = b;
        end else if (s == 2'b10) begin
            d = c;
        end else begin
            d = 32'h00000000;
        end
    end

endmodule