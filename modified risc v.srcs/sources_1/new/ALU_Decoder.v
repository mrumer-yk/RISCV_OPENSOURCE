module  ALU_Decoder_Fixed(ALUOp, funct3, funct7, isItype, ALUControl);

    input [1:0] ALUOp;
    input [2:0] funct3;
    input [6:0] funct7;
    input isItype;
    output reg [3:0] ALUControl; // 4-bit ALUControl

    always @(*) begin
        // Default ALUControl value
        ALUControl = 4'b0000;
        if(isItype == 1'b1) begin 
        ALUControl = 4'b0000; 
        end

        case (ALUOp)
            2'b00: begin
                ALUControl = 4'b0000; // Default addition for load/store
            end

            2'b01: begin
                // Branch instructions based on funct3
                case (funct3)
                    3'b000: ALUControl = 4'b1100; // BEQ
                    3'b001: ALUControl = 4'b1101; // BNE
                    3'b100: ALUControl = 4'b1110; // BLT
                    3'b101: ALUControl = 4'b1111; // BGE
                    default: ALUControl = 4'b0001; // Default for branches
                endcase
            end

            2'b10: begin
                // R-type instructions based on funct3 and funct7
                case (funct3)
                    3'b000: begin
                        case (funct7)
                            7'b0000000: ALUControl = 4'b0000; // ADD
                            7'b0100000: ALUControl = 4'b0001; // SUB
                            7'b0000001: ALUControl = 4'b1010; // MUL
                            default: ALUControl = 4'b0000; // Default ADD
                        endcase
                    end
                    3'b001: ALUControl = 4'b0111; // SLL
                    3'b010: ALUControl = 4'b0101; // SLT
                    3'b011: ALUControl = 4'b0110; // SLTU
                    3'b100: begin
                        if (funct7 == 7'b0000001) begin
                            ALUControl = 4'b1011; // DIV
                        end else begin
                            ALUControl = 4'b0100; // XOR
                        end
                    end
                    3'b101: begin
                        case (funct7)
                            7'b0000000: ALUControl = 4'b1000; // SRL
                            7'b0100000: ALUControl = 4'b1001; // SRA
                            default: ALUControl = 4'b0000; // Default ADD
                        endcase
                    end
                    3'b110: ALUControl = 4'b0011; // OR
                    3'b111: ALUControl = 4'b0010; // AND
                    default: ALUControl = 4'b0000; // Default ADD
                endcase
            end

            default: begin
                ALUControl = 4'b0000; // Default for unsupported ALUOp
            end
        endcase
    end
endmodule