module Main_Decoder (
    input wire [6:0] Op, // Only opcode input
    output reg RegWrite, ALUSrc, MemWrite, ResultSrc, float_signal, Branch, isItype,
    output reg [1:0] ImmSrc, ALUOp
);

    // Floating-point detection logic
    always @(*) begin
        case (Op)
            7'b0000111, // Load Floating Point
            7'b1010011, // R-Type Floating Point
            7'b0100111: // Store Floating Point
                float_signal = 1; // Floating-point operation detected
            default:
                float_signal = 0; // Fixed-point operation
        endcase
    end

    // Main decoder logic
    always @(*) begin
        // Default values
        RegWrite = 0;
        ALUSrc = 0;
        MemWrite = 0;
        ResultSrc = 0;
        ImmSrc = 2'b00;
        ALUOp = 2'b00;
        Branch = 0;
        isItype = 1'b0;

        if (float_signal == 0) begin
            // Fixed-Point Decoder Logic
            case (Op)
                7'b0000011: begin // Load
                    RegWrite = 1'b1;
                    ALUSrc = 1'b1;
                    ResultSrc = 1'b1;
                    ImmSrc = 2'b00;
                end
                7'b0110011: begin // R-Type
                    RegWrite = 1'b1;
                    ALUOp = 2'b10;
                end
                7'b0010011: begin // I-Type
                    RegWrite = 1'b1;
                    ALUSrc = 1'b1;
                    ImmSrc = 2'b00;
                    ALUOp = 2'b10;
                    isItype = 1'b1;
                end
                7'b0100011: begin // Store
                    ImmSrc = 2'b01;
                    ALUSrc = 1'b1;
                    MemWrite = 1'b1;
                end
                7'b1100011: begin // Branch
                    ImmSrc = 2'b10;
                    ALUOp = 2'b01; 
                    Branch = 1'b1;
                end
            endcase
        end else begin
            // Floating-Point Decoder Logic
            case (Op)
                7'b0000111: begin // Load Floating Point
                    RegWrite = 1'b1;
                    ALUSrc = 1'b1;
                    ResultSrc = 1'b1;
                    ImmSrc = 2'b11;
                end
                7'b1010011: begin // R-Type Floating Point
                    RegWrite = 1'b1;
                    ALUOp = 2'b10;
                end
                7'b0100111: begin // Store Floating Point
                    ALUSrc = 1'b1;
                    MemWrite = 1'b1;
                    ImmSrc = 2'b01;
                end
            endcase
        end
    end

endmodule  
