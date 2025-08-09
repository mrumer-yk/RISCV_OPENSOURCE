module  hazardunit(
    rst, RegWriteM, RegWriteW, RD_M, RD_W, Rs1_E, Rs2_E, ForwardAE, ForwardBE
);

// Declaration of I/Os
input rst, RegWriteM, RegWriteW;
input [4:0] RD_M, RD_W, Rs1_E, Rs2_E;
output reg [1:0] ForwardAE, ForwardBE;

always @(*) begin
    if (rst == 1'b0) begin
        ForwardAE = 2'b00;
    end else if ((RegWriteM == 1'b1) && (RD_M != 5'h00) && (RD_M == Rs1_E)) begin
        ForwardAE = 2'b10;
    end else if ((RegWriteW == 1'b1) && (RD_W != 5'h00) && (RD_W == Rs1_E)) begin
        ForwardAE = 2'b01;
    end else begin
        ForwardAE = 2'b00;
    end
end

always @(*) begin
    if (rst == 1'b0) begin
        ForwardBE = 2'b00;
    end else if ((RegWriteM == 1'b1) && (RD_M != 5'h00) && (RD_M == Rs2_E)) begin
        ForwardBE = 2'b10;
    end else if ((RegWriteW == 1'b1) && (RD_W != 5'h00) && (RD_W == Rs2_E)) begin
        ForwardBE = 2'b01;
    end else begin
        ForwardBE = 2'b00;
    end
end

endmodule