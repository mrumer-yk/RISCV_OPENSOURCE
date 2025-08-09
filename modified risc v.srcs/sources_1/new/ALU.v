module ALU(
    A, B, Result, ALUControl, OverFlow, Carry, Zero, Negative, brancht
);

    input [31:0] A, B;
    input [3:0] ALUControl; // Increased ALUControl to 4 bits to accommodate more instructions
    output Carry, OverFlow, Zero, Negative;
    output [31:0] Result;
    output brancht;

    reg Carry;
    reg OverFlow;
    reg Zero;
    reg Negative;
    reg [31:0] Result;
    reg brancht;

    reg [32:0] Sum; // Extended to 33 bits to capture carry out
    reg Cout;

    always @(*) begin
        // Initialize outputs to default values to avoid latches
        Carry = 1'b0;
        OverFlow = 1'b0;
        Zero = 1'b0;
        Negative = 1'b0;
        brancht = 1'b0;
        Result = 32'b0;

        // Determine Sum for addition or subtraction with carry out
        if (ALUControl[0] == 1'b0) begin
            Sum = {1'b0, A} + {1'b0, B}; // Addition
        end else begin
            Sum = {1'b0, A} + {1'b0, (~B) + 1}; // Subtraction
        end

        // Determine Cout for addition or subtraction
        if (ALUControl == 4'b0000 || ALUControl == 4'b0001) begin
            Cout = Sum[32];
        end else begin
            Cout = 1'b0;
        end

        // Main ALU operations based on ALUControl
        case (ALUControl)
            4'b0000: begin // Addition
                Result = Sum[31:0];
                Carry = Cout;
                OverFlow = (A[31] == B[31]) && (Result[31] != A[31]);
            end
            4'b0001: begin // Subtraction
                Result = Sum[31:0];
                Carry = Cout;
                OverFlow = (A[31] != B[31]) && (Result[31] != A[31]);
            end
            4'b0010: begin // Bitwise AND
                Result = A & B;
            end
            4'b0011: begin // Bitwise OR
                Result = A | B;
            end
            4'b0100: begin // Bitwise XOR
                Result = A ^ B;
            end
            4'b0101: begin // Set on Less Than (signed)
                Result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
            end
            4'b0110: begin // Set Less Than Unsigned
                Result = (A < B) ? 32'b1 : 32'b0;
            end
            4'b0111: begin // Shift Left Logical (SLL)
                Result = A << B[4:0];
            end
            4'b1000: begin // Shift Right Logical (SRL)
                Result = A >> B[4:0];
            end
            4'b1001: begin // Shift Right Arithmetic (SRA)
                Result = $signed(A) >>> B[4:0];
            end
            4'b1010: begin // Multiplication
                Result = A * B;
            end
            4'b1011: begin // Division
                if (B != 0) begin
                    Result = A / B;
                end else begin
                    Result = 32'b0; // Division by zero, return 0 (or handle differently)
                end
            end
            4'b1100: begin  // beq (Branch if Equal)
                if (A == B) begin 
                    brancht = 1'b1;
                end
            end
            4'b1101: begin  // bne (Branch if Not Equal)
                if (A != B) begin 
                    brancht = 1'b1;
                end
            end
            4'b1110: begin  // blt (Branch if Less Than)
                if ($signed(A) < $signed(B)) begin 
                    brancht = 1'b1;
                end
            end
            4'b1111: begin  // bge (Branch if Greater or Equal)
                if ($signed(A) >= $signed(B)) begin 
                    brancht = 1'b1;
                end
            end
            default: begin
                Result = 32'b0; // Default case, undefined operation
            end
        endcase

        // Determine the Zero and Negative flags
        Zero = (Result == 32'b0) ? 1'b1 : 1'b0;
        Negative = Result[31]; 
    end

endmodule