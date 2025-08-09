module reg1(
    input clk,
    input rst,              // Active-low reset
    input [4:0] a1, a2, a3, // Address inputs
    input w,                // Write enable
    output fft_s,           // FFT start signal
    input fft_e,            // FFT end signal
    input [31:0] wd,        // Write data
    output reg [31:0] rd1,  // Read data output 1
    output reg [31:0] rd2,  // Read data output 2
    input spi_finish        // SPI finish signal (added)
);

    reg [31:0] regfile[31:0]; // 32 general-purpose registers
    integer i;

    // Write and Reset Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Clear all registers on reset
            for (i = 0; i < 32; i = i + 1)
                regfile[i] <= 32'b0;
        end else begin
            // SPI finish condition: write 1 to register x30 (R30)
            if (spi_finish) begin
                regfile[30] <= 32'd1;  // Write 1 to register 30 when SPI finishes
            end
            
            // Regular write operation (normal memory write)
            if (w && a3 != 5'd0)
                regfile[a3] <= wd;

            // FFT end condition: set R2 = 1 when fft_e is high
            if (fft_e)
                regfile[2] <= 32'd1;
        end
    end

    // Keep register 0 as 0
    always @(posedge clk) begin
        regfile[0] <= 32'b0;
    end

    // Combinational Read Logic with Forwarding
    always @(*) begin
        rd1 = (w && a3 == a1) ? wd : regfile[a1];
        rd2 = (w && a3 == a2) ? wd : regfile[a2];
    end

    // FFT start signal: regfile[1] == 1
  //  assign fft_s = (regfile[1] == 32'd1) ? 1'b1 : 1'b0;

endmodule
