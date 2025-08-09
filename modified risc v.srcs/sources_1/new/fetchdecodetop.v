module fetch_decode_top(
    input clk,
    input rst,
    input RegWriteW,
    input [31:0] ResultW1,
    input [4:0] RDW,
    input PCSrcE,
    input [31:0] PCTargetE,
    input spifinish,
    output [31:0] RD1,
    output [31:0] RD2,
    output [31:0] Imm_Ext,
    output RegWriteE,
    output ALUSrcE,
    output ResultSrcE,
    output MemwriteE,
    output BranchE,
    output float_signalE,
    output [4:0] RD,
    output [31:0] PCD,
    output [31:0] PCPlus4D,
    output [3:0] ALUControl_E,
    output [31:0] InstrD_E,
    output [4:0] RS1_E,
    output [4:0] RS2_E
);

    // Internal Signals
    wire [31:0] InstrD_wire;
    wire [31:0] PCD_wire;         // From fetchunit
    wire [31:0] PCPlus4D_wire;    // From fetchunit
    wire [31:0] PCD_out_wire;     // From decode_top
    wire [31:0] PCPlus4D_out_wire;// From decode_top
    wire [31:0] RD1_w;
    wire [31:0] RD2_w;
    wire [31:0] Imm_Ext_w;
    wire RegWriteE_w;
    wire ALUSrcE_w;
    wire ResultSrcE_w;
    wire BranchE_w;
    wire MemwriteE_w;
    wire isItype;
    wire float_signalE_w;
    wire [4:0] RD_w, RS1_D_w1, RS2_D_w2;
    wire [3:0] ALUControl_w;

    // Instantiate Fetch Unit
    fetchunit fetch_stage (
        .clk(clk),
        .rst(rst),
       .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD_wire),
        .PCD(PCD_wire),
        .PCPlus4D(PCPlus4D_wire)
    );

    // Instantiate Decode Unit
    decode_top decode_stage (
        .clk(clk),
        .rst(rst),
        .RegWriteW(RegWriteW),
        .InstrD(InstrD_wire),
        .PCD(PCD_wire),
        .PCPlus4D(PCPlus4D_wire),
        .ResultW(ResultW1),
        .RDW(RDW),
      //  .PCSrcE(PCSrcE),
        .RD1(RD1_w),
        .RD2(RD2_w),
        .Imm_Ext(Imm_Ext_w),
        .RegWriteE(RegWriteE_w),
        .ALUSrcE(ALUSrcE_w),
        .ResultSrcE(ResultSrcE_w),
        .BranchE(BranchE_w),
        .MemwriteE(MemwriteE_w),
        .float_signalE(float_signalE_w),
        .RD(RD_w),
        .ALUControl_d(ALUControl_w),
        .RS1_out(RS1_D_w1),
        .RS2_out(RS2_D_w2),
        .PCD_out(PCD_out_wire),       // Use separate wire
        .PCPlus4D_out(PCPlus4D_out_wire), // Use separate wire
        .spifinish(spifinish)
    );

    // Output Assignments
    assign RD1 = RD1_w;
    assign RD2 = RD2_w;
    assign Imm_Ext = Imm_Ext_w;
    assign RegWriteE = RegWriteE_w;
    assign ALUSrcE = ALUSrcE_w;
    assign ResultSrcE = ResultSrcE_w;
    assign BranchE = BranchE_w;
    assign MemwriteE = MemwriteE_w;
    assign float_signalE = float_signalE_w;
    assign RD = RD_w;
    assign PCD = PCD_out_wire;         // Use decode output
    assign PCPlus4D = PCPlus4D_out_wire; // Use decode output
    assign ALUControl_E = ALUControl_w;
    assign InstrD_E = InstrD_wire;
    assign RS1_E = RS1_D_w1;
    assign RS2_E = RS2_D_w2;

endmodule