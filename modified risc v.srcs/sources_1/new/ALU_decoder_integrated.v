module ALU_Decoder_Integrated (
    input [1:0] ALUOp,
    input [2:0] funct3,    // For fixed-point ALU decoder
    input [6:0] funct7,    // For fixed-point ALU decoder
    input [4:0] funct5,    // For floating-point ALU decoder
    input float_signal,    // Signal to select between fixed and floating-point
    input isItype,        // Added isItype input
    output reg [3:0] ALUControl  // Single ALUControl signal
);

    // Fixed-Point ALU Decoder Instantiation
    wire [3:0] ALUControl_FixedPoint;
    ALU_Decoder_Fixed fixed_decoder (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .isItype(isItype),
        .ALUControl(ALUControl_FixedPoint)
    );

    // Floating-Point ALU Decoder Mapping
    reg [3:0] ALUControl_FloatingPoint;
    always @(*) begin
        case (funct5)
            5'b00000: ALUControl_FloatingPoint = 4'b0000; // Floating Add
            5'b00001: ALUControl_FloatingPoint = 4'b0001; // Floating Sub
            5'b00010: ALUControl_FloatingPoint = 4'b0010; // Floating Mul
            5'b00011: ALUControl_FloatingPoint = 4'b0011; // Floating Div
            default:  ALUControl_FloatingPoint = 4'b0000; // Default
        endcase
    end

    // ALU Control Selection Logic
    always @(*) begin
        if (isItype) begin
            ALUControl = 4'b0000; // Override for I-type instructions
        end else if (float_signal) begin
            ALUControl = ALUControl_FloatingPoint; // Floating-Point Control
        end else begin
            ALUControl = ALUControl_FixedPoint;   // Fixed-Point Control
        end
    end

endmodule