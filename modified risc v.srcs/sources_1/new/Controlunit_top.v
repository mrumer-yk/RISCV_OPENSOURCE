module Control_Unit_Top (
    input [6:0] Op, funct7,
    input [2:0] funct3,
    input [4:0] funct5,  // Added funct5 for floating-point operations
    output RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, float_signal, isItype,
    output [1:0] ImmSrc,
    output [3:0] ALUControl_out
);

    wire [1:0] ALUOp_wire;
    wire isItype_wire; // Internal wire for isItype

    // Instantiating Main Decoder
    Main_Decoder main_decoder (
        .Op(Op),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .float_signal(float_signal),
        .isItype(isItype_wire), // Connect isItype
        .ALUOp(ALUOp_wire)
    );

    // Instantiating ALU Decoder Integrated
    ALU_Decoder_Integrated alu_decoder (
        .ALUOp(ALUOp_wire),
        .funct3(funct3),
        .funct7(funct7),
        .funct5(funct5),        // Added funct5 for floating-point
        .float_signal(float_signal),
        .isItype(isItype_wire), // Pass isItype to ALU_Decoder_Integrated
        .ALUControl(ALUControl_out)
    );

    // Assign isItype output
    assign isItype = isItype_wire;

endmodule