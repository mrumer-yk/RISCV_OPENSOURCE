module ALU_Floating_Point(
    input [31:0] operand_a,
    input [31:0] operand_b,
    input [2:0] ALUControl, // ALU control signal
    output reg [31:0] result,
    output Exception,
    output Overflow,
    output Underflow
);

    // Intermediate wires for different operations
    wire [31:0] mul_result, div_result;
    wire [31:0] iter_result;
    wire [31:0] sub_add_result;
    wire exception_mul, exception_div, exception_add_sub;
    wire overflow_mul, underflow_mul;

    // Multiplication instance
    Multiplication multiplication_unit (
        .a_operand(operand_a),
        .b_operand(operand_b),
        .Exception(exception_mul),
        .Overflow(overflow_mul),
        .Underflow(underflow_mul),
        .result(mul_result)
    );

    // Division instance
    Division division_unit (
        .a_operand(operand_a),
        .b_operand(operand_b),
        .Exception(exception_div),
        .result(div_result)
    );

    // Iteration instance (for Newton-Raphson approximation)
    Iteration iteration_unit (
        .operand_1(operand_a),
        .operand_2(operand_b),
        .solution(iter_result)
    );

    // Updated Addition/Subtraction instance
    Addition_Subtraction addition_subtraction_unit (
        .a_operand(operand_a),
        .b_operand(operand_b),
        .AddBar_Sub(ALUControl[0]), // LSB decides Add/Sub (Add = 0, Sub = 1)
        .Exception(exception_add_sub),
        .result(sub_add_result)
    );

    // Determine operation based on ALUControl
    always @(*) begin
        case (ALUControl)
            3'b000: result = sub_add_result;       // Multiplication
            3'b001: result = sub_add_result;  // Addition/Subtraction
            3'b010: result = mul_result;     // Iteration (for advanced operations)
            3'b011: result = div_result;      // Division
            default: result = 32'd0;         // Default case
        endcase
    end

    // Exception, Overflow, and Underflow handling (multiplication, division, and add/subtract as examples)
    assign Exception = (ALUControl == 3'b000) ? exception_mul :
                       (ALUControl == 3'b001) ? exception_add_sub :
                       (ALUControl == 3'b011) ? exception_div : 1'b0;

    assign Overflow = (ALUControl == 3'b000) ? overflow_mul : 1'b0;
    assign Underflow = (ALUControl == 3'b000) ? underflow_mul : 1'b0;

endmodule
