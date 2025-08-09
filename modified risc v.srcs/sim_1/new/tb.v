module top_pipe_line_tb;

    // Inputs
    reg clk = 0;
    reg rst;

    // Outputs
    wire [31:0] result_w;
    wire [4:0] rd_w;
    wire reg_r_w, src;
    wire [1:0] fae, fbe;
    wire [6:0] seg;

    // Instantiate the Unit Under Test (UUT)
    TOP_RISC_V uut (
        .clk(clk),
        .rst(rst),
     .result_w(result_w)
      //  .seg(seg),
     //   .rd_w(rd_w)
        //.reg_r_w(reg_r_w),
        //.src(src),
       //.fae(fae),
        //.fbe(fbe)
    );

    // Clock generation: Toggle clock every 5ns (100MHz clock)
    always begin
        clk = ~clk;
        #25; // Toggle clock every 5ns
    end

    initial begin
        // Initialize Inputs
        rst = 0;  // Start with reset de-asserted initially
        #100;
        
        rst = 1;  // Apply reset
       
        #100;
        #100;
        #100;    // Wait for 2000ns after reset is de-asserted
        #5000;    // Run for 2000ns after reset is released

     
    end

endmodule