module MUX (
  input  [31:0] in0,    // 32-bit input 0
  input  [31:0] in1,    // 32-bit input 1
  input sel,           // Select input
  output reg [31:0] out     // 32-bit output
);

  always @(*) begin
    case (sel)
      1'b0: out = in0;
      1'b1: out = in1;
      default: out = 32'b0; // Optional default for safety
    endcase
  end

endmodule