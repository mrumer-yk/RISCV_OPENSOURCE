module fetchunit(
    input clk, 
    input rst,
    input PCSrcE,                    // Control signal: 1 if branch taken
    input [31:0] PCTargetE,          // Branch Target Address

    output reg [31:0] InstrD,        // Output: instruction to Decode stage
    output reg [31:0] PCD,           // Current PC value
    output reg [31:0] PCPlus4D       // PC + 4 value
);

    // Internal wires
    wire [31:0] PC_F, PCF, PCPlus4F;
    wire [31:0] InstrF;

    // Internal registers (pipeline stage holding registers)
    reg [31:0] InstrF_reg;
    reg [31:0] PCF_reg, PCPlus4F_reg;

    // PC Mux: select between PC+4 or Branch Target
    MUX PC_MUX (
        .in0(PCPlus4F),      // PC + 4
        .in1(PCTargetE),     // Branch target address
        .sel(PCSrcE),        // Control signal
        .out(PC_F)           // Next PC value
    );

    // Program Counter Unit
    pcunit Program_Counter (
        .clk(clk),
        .rst(rst),
        .PC(PCF),            // Current PC
        .PC_Next(PC_F)       // Next PC (from mux)
    );

    // Instruction Memory Unit
    memoryunit IMEM (
        .A(PCF),             // Address input (current PC)
        .reset(rst),         // Reset signal
        .rd(InstrF)          // Output: instruction at PCF
    );

    // PC + 4 Adder
    pcadder pcadder (
        .a(PCF),             
        .b(32'h00000004),    // Constant 4
        .c(PCPlus4F)         // Output: PC + 4
    );

    // Fetch Stage Pipeline Registers
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            InstrF_reg <= 32'h00000000;
            PCF_reg <= 32'h00000000;
            PCPlus4F_reg <= 32'h00000000;
        end else begin
            InstrF_reg <= InstrF;         // Normal instruction
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end

    // Outputs to Decode stage
    always @(*) begin
        if (rst == 1'b0) begin
            InstrD = 32'h00000000;
            PCD = 32'h00000000;
            PCPlus4D = 32'h00000000;
        end else begin
            InstrD = InstrF_reg;
            PCD = PCF_reg;
            PCPlus4D = PCPlus4F_reg;
        end
    end

endmodule