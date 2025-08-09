module decode_top(
    input clk, 
    input rst, 
    input RegWriteW, 
    input [31:0] InstrD, 
    input [31:0] PCD,         // Current Program Counter (PC)
    input [31:0] PCPlus4D,    // Program Counter + 4
    input [31:0] ResultW, 
    input [4:0] RDW,
    input spifinish,
    
    // Outputs
    output [31:0] RD1,        // Read data output 1 from register file
    output [31:0] RD2,        // Read data output 2 from register file
    output [31:0] Imm_Ext,    // Sign-extended immediate value
    output RegWriteE, ALUSrcE, ResultSrcE, BranchE, MemwriteE, float_signalE,
    output [4:0] RD,          // Destination register
    output [3:0] ALUControl_d,  // ALU control signal
    output [31:0] PCD_out,    // Output the current PC
    output [31:0] PCPlus4D_out,// Output the PC+4
    output [4:0] RS1_out,
    output [4:0] RS2_out
);

    // Internal Signals for Control Unit
    wire [6:0] Op_wire = InstrD[6:0];    // Opcode from instruction
    wire RegWriteD, ALUSrcD, ResultSrcD, BranchD, MemwriteD, float_signalD;
    wire isItype;
    wire finish;
    wire [1:0] ImmSrc_wire;
    wire [2:0] funct3_wire = InstrD[14:12];
    wire [6:0] funct7_wire = InstrD[31:25];
    wire [4:0] funct5_wire = InstrD[31:27]; // Floating-point funct5 field
    wire [3:0] ALUControl_wire;

    // Internal Signals for Register File (reg1)
    wire [4:0] RS1_D = InstrD[19:15];    // Source register 1
    wire [4:0] RS2_D = InstrD[24:20];    // Source register 2
    wire [4:0] RD_D  = InstrD[11:7];     // Destination register
    wire [31:0] rd1_d_out, rd2_d_out, Imm_Ext_w_out;

    // Delayed Outputs
    reg [31:0] RD1_reg, RD2_reg, Imm_Ext_reg;
    reg RegWriteD_r, ALUSrcD_r, ResultSrcD_r, BranchD_r, MemwriteD_r, float_signal_r;
    reg [4:0] RS1_r, RS2_r, RD_r;
    reg [3:0] ALUControl_r;
    reg [31:0] PCD_reg, PCPlus4D_reg;

    // Instantiate Control Unit
    Control_Unit_Top control_unit (
        .Op(Op_wire),
        .funct3(funct3_wire),
        .funct7(funct7_wire),
        .funct5(funct5_wire),
        .RegWrite(RegWriteD),
        .ImmSrc(ImmSrc_wire),
        .ALUSrc(ALUSrcD),
        .ResultSrc(ResultSrcD),
        .MemWrite(MemwriteD),
        .Branch(BranchD),
        .float_signal(float_signalD),
        .isItype(isItype),
        .ALUControl_out(ALUControl_wire)
    );

    // Instantiate Register File
    reg1 register_file (
        .clk(clk),
        .rst(rst), 
        .a1(RS1_D), 
        .a2(RS2_D),
        .a3(RDW),
        .w(RegWriteW),
        .wd(ResultW),
        .rd1(rd1_d_out),
        .rd2(rd2_d_out), 
        .spi_finish(spifinish)
    );

    // Instantiate Sign Extension Unit
    signbitextension sign_extender (
        .In(InstrD),
        .ImmSrc(ImmSrc_wire),
        .float_signal(float_signalD),
        .Imm_Ext(Imm_Ext_w_out)
    );

    // Delayed Register Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            RD1_reg        <= 32'b0;
            RD2_reg        <= 32'b0;
            Imm_Ext_reg    <= 32'b0;
            RegWriteD_r    <= 1'b0;
            ALUSrcD_r      <= 1'b0;
            ResultSrcD_r   <= 1'b0;
            BranchD_r      <= 1'b0;
            MemwriteD_r    <= 1'b0;
            float_signal_r <= 1'b0;
            RD_r           <= 5'b0;
            ALUControl_r   <= 4'b0;
            RS1_r          <= 5'b0;
            RS2_r          <= 5'b0;
            PCD_reg        <= 32'b0;
            PCPlus4D_reg   <= 32'b0;
        end else begin
            // Normal operation
            RD1_reg        <= rd1_d_out;
            RD2_reg        <= rd2_d_out;
            Imm_Ext_reg    <= Imm_Ext_w_out;
            RegWriteD_r    <= RegWriteD;
            ALUSrcD_r      <= ALUSrcD;
            ResultSrcD_r   <= ResultSrcD;
            BranchD_r      <= BranchD;
            MemwriteD_r    <= MemwriteD;
            float_signal_r <= float_signalD;
            RD_r           <= RD_D;
            ALUControl_r   <= ALUControl_wire;
            RS1_r          <= RS1_D;
            RS2_r          <= RS2_D;
            PCD_reg        <= PCD;
            PCPlus4D_reg   <= PCPlus4D;
        end
    end

    // Assign Delayed Outputs
    assign RD1           = RD1_reg;
    assign RD2           = RD2_reg;
    assign Imm_Ext       = Imm_Ext_reg;
    assign RegWriteE     = RegWriteD_r;
    assign ALUSrcE       = ALUSrcD_r;
    assign ResultSrcE    = ResultSrcD_r;
    assign BranchE       = BranchD_r;
    assign MemwriteE     = MemwriteD_r;
    assign float_signalE = float_signal_r;
    assign RD            = RD_r;
    assign ALUControl_d  = ALUControl_r;
    assign RS1_out       = RS1_r;
    assign RS2_out       = RS2_r;
    assign PCD_out       = PCD_reg;
    assign PCPlus4D_out  = PCPlus4D_reg;

endmodule