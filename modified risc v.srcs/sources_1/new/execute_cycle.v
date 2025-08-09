module execute_cycle(clk, rst, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE, ALUControlE, float_signal, RD1_E, RD2_E, Imm_Ext_E, RD_E, PCE,
PCPlus4E, PCSrcE, PCTargetE, RegWriteM, MemWriteM, ResultSrcM, RD_M, PCPlus4M, WriteDataM,
     ALU_ResultM, ResultW, ForwardA_E, ForwardB_E);
     

    // Declaration I/Os
    input clk, rst, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE, float_signal;
    input [3:0] ALUControlE;
    input [31:0] RD1_E, RD2_E, Imm_Ext_E;
    input [4:0] RD_E;
    input [31:0] PCE, PCPlus4E;
    input [31:0] ResultW;
    input [1:0] ForwardA_E, ForwardB_E;

    output PCSrcE, RegWriteM, MemWriteM, ResultSrcM;
    output [4:0] RD_M; 
    output [31:0] PCPlus4M, WriteDataM, ALU_ResultM;
    output [31:0] PCTargetE;

    // Declaration of Interim Wires
    wire [31:0] Src_A, Src_B_interim, Src_B;
    wire [31:0] ResultE;
    wire ZeroE, CarryE, OverFlowE, NegativeE, BranchT_E, ExceptionE, Overflow_FP_E, Underflow_FP_E;
    wire branch_wire;

    // Register Declarations
    reg RegWriteE_r, MemWriteE_r, ResultSrcE_r;
    reg [4:0] RD_E_r;
    reg [31:0] PCPlus4E_r, RD2_E_r, ResultE_r;

    // Mux for Source A
    Mux_3_by_1 srca_mux (
        .a(RD1_E),
        .b(ResultW),
        .c(ALU_ResultM),
        .s(ForwardA_E),
        .d(Src_A)
    );

    // Mux for Source B
    Mux_3_by_1 srcb_mux (
        .a(RD2_E),
        .b(ResultW),
        .c(ALU_ResultM),
        .s(ForwardB_E),
        .d(Src_B_interim)
    );

    // ALU Src Mux
    MUX alu_src_mux (
        .in0(Src_B_interim),
        .in1(Imm_Ext_E),
        .sel(ALUSrcE),
        .out(Src_B)
    );

    // ALU_TOP Instantiation
    ALU_TOP alu_top (
        .A(Src_A),
        .B(Src_B),
        .ALUControl(ALUControlE),
        .float_signal(float_signal),
        .Result(ResultE),
        .Carry(CarryE),
        .OverFlow(OverFlowE),
        .Zero(ZeroE),
        .Negative(NegativeE),
        .brancht(BranchT_E),
        .Exception(ExceptionE),
        .Overflow_FP(Overflow_FP_E),
        .Underflow_FP(Underflow_FP_E)
    );

    // Adder for Branch Target
    pcadder branch_adder (
        .a(PCE),
        .b(Imm_Ext_E),
        .c(PCTargetE)
    );

    // Register Logic
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            RegWriteE_r <= 1'b0; 
            MemWriteE_r <= 1'b0; 
            ResultSrcE_r <= 1'b0;
            RD_E_r <= 5'h00;
            PCPlus4E_r <= 32'h00000000; 
            RD2_E_r <= 32'h00000000; 
            ResultE_r <= 32'h00000000;
        end
        else begin
            RegWriteE_r <= RegWriteE; 
            MemWriteE_r <= MemWriteE; 
            ResultSrcE_r <= ResultSrcE;
            RD_E_r <= RD_E;
            PCPlus4E_r <= PCPlus4E; 
            RD2_E_r <= Src_B_interim; 
            ResultE_r <= ResultE;
        end
    end

    // Output Assignments
    assign PCSrcE = BranchT_E & BranchE;
    assign RegWriteM = RegWriteE_r;
    assign MemWriteM = MemWriteE_r;
    assign ResultSrcM = ResultSrcE_r;
    assign RD_M = RD_E_r;
    assign PCPlus4M = PCPlus4E_r;
    assign WriteDataM = RD2_E_r;
    assign ALU_ResultM = ResultE_r;

endmodule
