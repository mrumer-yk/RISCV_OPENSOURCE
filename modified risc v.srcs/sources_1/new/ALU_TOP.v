module ALU_TOP(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUControl,
    input float_signal,
    output reg [31:0] Result,
    output reg Carry,
    output reg OverFlow,
    output reg Zero,
    output reg Negative,
    output reg brancht,
    output reg Exception,
    output reg Overflow_FP,
    output reg Underflow_FP
);

    // Outputs
    wire [31:0] Fixed_Result;
    wire Carry_Fixed, OverFlow_Fixed, Zero_Fixed, Negative_Fixed, BranchT_Fixed;
    wire [31:0] Floating_Result;
    wire Exception_FP, Overflow_FP_Internal, Underflow_FP_Internal;

    // Instantiate Fixed-Point ALU
    ALU fixed_point_alu (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Fixed_Result),
        .Carry(Carry_Fixed),
        .OverFlow(OverFlow_Fixed),
        .Zero(Zero_Fixed),
        .Negative(Negative_Fixed),
        .brancht(BranchT_Fixed)
    );

    // Instantiate Floating-Point ALU
    ALU_Floating_Point floating_point_alu (
        .operand_a(A),
        .operand_b(B),
        .ALUControl(ALUControl[2:0]),
        .result(Floating_Result),
        .Exception(Exception_FP),
        .Overflow(Overflow_FP_Internal),
        .Underflow(Underflow_FP_Internal)
    );

    // Select ALU based on float_signal
    always @(*) begin
        if (float_signal) begin
            Result = Floating_Result;
            Exception = Exception_FP;
            Overflow_FP = Overflow_FP_Internal;
            Underflow_FP = Underflow_FP_Internal;

            // Set unused fixed-point outputs to zero
            Carry = 0;
            OverFlow = 0;
            Zero = 0;
            Negative = 0;
            brancht = 0;
        end else begin
            Result = Fixed_Result;
            Carry = Carry_Fixed;
            OverFlow = OverFlow_Fixed;
            Zero = Zero_Fixed;
            Negative = Negative_Fixed;
            brancht = BranchT_Fixed;

            // Set unused floating-point outputs to zero
            Exception = 0;
            Overflow_FP = 0;
            Underflow_FP = 0;
        end
    end

endmodule
