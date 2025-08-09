module TOP_RISC_V (
    input clk,
    input rst,
    output [31:0] result_w
    

   // output [4:0] rd_w,
    //output [6:0] seg,
    // SPI Interface
   // input i_SPI_MISO,
   // output o_SPI_MOSI,
   // output o_SPI_Clk,
   // output o_SPI_CS_n
);

    // Internal wires
    wire [31:0] RD1_wire, RD2_wire, Imm_Ext_wire;
    wire [4:0] RS1_wire, RS2_wire, RD_wire;
    wire RegWriteE_wire, MemWriteE_wire, BranchE_wire, ALUSrcE_wire, ResultSrcE_wire;
    wire [3:0] ALUControlE_wire;
    wire [31:0] PCE_wire, PCPlus4E_wire, PCTargetE_wire;
    wire PCSrcE_wire;
    wire RegWriteM_wire, MemWriteM_wire, ResultSrcM_wire;
    wire [4:0] RD_M_wire;
    wire [31:0] PCPlus4M_wire, WriteDataM_wire, ALU_ResultM_wire;
    wire RegWriteW_wire, ResultSrcW_wire;
    wire [4:0] RD_W_wire;
    wire [31:0] PCPlus4W_wire, ALU_ResultW_wire, ReadDataW_wire;
    wire [31:0] ResultW_wire;
    wire [1:0] ForwardAE_wire, ForwardBE_wire;
    wire reg_w_wire;
    wire float_signalE_wire;
    
    // Declare a wire for 7-segment display output
    wire [6:0] seg_wire;
    wire spifinish_wire;
    // Fetch and Decode Cycle
    fetch_decode_top fetchcycleanddecodecycle (
        .clk(clk),
        .rst(rst),
        .RegWriteW(reg_w_wire),
        .ResultW1(ResultW_wire),
        .RDW(RD_W_wire),
        .PCSrcE(PCSrcE_wire),
        .PCTargetE(PCTargetE_wire),
        .RD1(RD1_wire),
        .RD2(RD2_wire),
        .Imm_Ext(Imm_Ext_wire),
        .RegWriteE(RegWriteE_wire),
        .spifinish(spifinish_wire),
        .ALUSrcE(ALUSrcE_wire),
        .ResultSrcE(ResultSrcE_wire),
        .MemwriteE(MemWriteE_wire),
        .BranchE(BranchE_wire),
        .RD(RD_wire),
        .PCD(PCE_wire),
        .PCPlus4D(PCPlus4E_wire),
        .ALUControl_E(ALUControlE_wire),
        .InstrD_E(),
        .RS1_E(RS1_wire),
        .RS2_E(RS2_wire),
        .float_signalE(float_signalE_wire)
    );
    
    // Execute Cycle
    execute_cycle executecycle (
        .clk(clk),  
        .rst(rst),
        .RegWriteE(RegWriteE_wire),
        .ALUSrcE(ALUSrcE_wire),
        .MemWriteE(MemWriteE_wire),
        .ResultSrcE(ResultSrcE_wire),
        .BranchE(BranchE_wire),
        .ALUControlE(ALUControlE_wire),
        .float_signal(float_signalE_wire),
        .RD1_E(RD1_wire),
        .RD2_E(RD2_wire),
        .Imm_Ext_E(Imm_Ext_wire),
        .RD_E(RD_wire),
        .PCE(PCE_wire),
        .PCPlus4E(PCPlus4E_wire),
        .PCSrcE(PCSrcE_wire),
        .PCTargetE(PCTargetE_wire),
        .RegWriteM(RegWriteM_wire),
        .MemWriteM(MemWriteM_wire),
        .ResultSrcM(ResultSrcM_wire),
        .RD_M(RD_M_wire),
        .PCPlus4M(PCPlus4M_wire),
        .WriteDataM(WriteDataM_wire),
        .ALU_ResultM(ALU_ResultM_wire),
        .ResultW(ResultW_wire),
        .ForwardA_E(ForwardAE_wire),
        .ForwardB_E(ForwardBE_wire)
    );
    
    // Memory Cycle
    memory_cycle1 memorycycle (
        .clk(clk),  
        .rst(rst),
        .RegWriteM(RegWriteM_wire),
        .MemWriteM(MemWriteM_wire),
        .ResultSrcM(ResultSrcM_wire),
        .RD_M(RD_M_wire),
        .PCPlus4M(PCPlus4M_wire),
        .WriteDataM(WriteDataM_wire),
        .ALU_ResultM(ALU_ResultM_wire),
        .RegWriteW(RegWriteW_wire),
        .ResultSrcW(ResultSrcW_wire),
        .RD_W(RD_W_wire),
        .PCPlus4W(PCPlus4W_wire),
        .ALU_ResultW(ALU_ResultW_wire),
        .ReadDataW(ReadDataW_wire),
        .seg(seg_wire),
        .i_SPI_MISO(i_SPI_MISO),
        .o_SPI_MOSI(o_SPI_MOSI),
        .o_SPI_Clk(o_SPI_Clk),
        .o_SPI_CS_n(o_SPI_CS_n), 
        .spi_finish(spifinish_wire)
    );
    
    // Writeback Cycle
    writeback_cycle1 writebackcycle (
        .clk(clk),  
        .rst(rst),
        .ResultSrcW(ResultSrcW_wire),
        .PCPlus4W(PCPlus4W_wire),
        .reg_w(RegWriteW_wire),
        .reg_w_o(reg_w_wire),
        .ALU_ResultW(ALU_ResultW_wire),
        .ReadDataW(ReadDataW_wire),
        .ResultW(ResultW_wire)
    );
    
    // Hazard Unit
    hazardunit hazard_unit (
        .rst(rst),  
        .RegWriteM(RegWriteM_wire),
        .RegWriteW(reg_w_wire),
        .RD_M(RD_M_wire),
        .RD_W(RD_W_wire),
        .Rs1_E(RS1_wire),
        .Rs2_E(RS2_wire),
        .ForwardAE(ForwardAE_wire),
        .ForwardBE(ForwardBE_wire)
    );
    
    // Assign outputs
    assign result_w = ResultW_wire;
  
   // assign rd_w = RD_W_wire;
    //assign seg = seg_wire;
    
endmodule