module signbitextension (
    input [31:0] In,
    input [1:0] ImmSrc,  
    input float_signal,  // Indicates if instruction is floating-point
    output reg [31:0] Imm_Ext
);
    always @(*) begin
        if (float_signal) begin
            // Floating-Point Instructions
            case (ImmSrc)
                2'b11:  // Load-FP Instruction
                    Imm_Ext = {{20{In[31]}}, In[31:20]};
                2'b01:  // Store-FP Instruction
                    Imm_Ext = {{20{In[31]}}, In[31:25], In[11:7]};
                default:  
                    Imm_Ext = 32'b0;
            endcase
        end else begin
            // Fixed-Point Instructions
            case (ImmSrc)
                2'b00:  // I-type
                    Imm_Ext = {{20{In[31]}}, In[31:20]};
                2'b01:  // S-type
                    Imm_Ext = {{20{In[31]}}, In[31:25], In[11:7]};
                2'b10:  // B-type
                    Imm_Ext = {{19{In[31]}}, In[31], In[7], In[30:25], In[11:8], 1'b0};
                default:
                    Imm_Ext = 32'b0;
            endcase
        end
    end
endmodule
