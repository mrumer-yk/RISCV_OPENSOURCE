module writeback_cycle1(clk, rst, ResultSrcW, reg_w,PCPlus4W, ALU_ResultW, ReadDataW, ResultW,reg_w_o);

// Declaration of IOs
input clk, rst, ResultSrcW,reg_w;
input [31:0] PCPlus4W, ALU_ResultW, ReadDataW;
output reg_w_o;

output [31:0] ResultW;

 assign ResultW = (ResultSrcW == 1'b0) ? ALU_ResultW : ReadDataW;
 assign  reg_w_o=reg_w;
endmodule