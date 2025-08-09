module Data_Memory1 (
    input clk, rst, WE,
    input [31:0] A, WD,
    output reg [31:0] RD,
    output [6:0] seg,
    // SPI Interface
    input i_SPI_MISO,
    output o_SPI_MOSI,
    output o_SPI_Clk,
    output o_SPI_CS_n,
    output spifinish
);

    // 32-word memory (each 32-bit wide)
    reg [31:0] mem [0:31];
    reg [3:0] seg_data;

    // Memory Initialization
    initial begin
        mem[0] = 32'h00000003;  // 3
mem[1] = 32'h00000004;  // 4
mem[2] = 32'h00000005;  // 5
mem[3] = 32'h00000006;  // 6
mem[4] = 32'h00000007;  // 7
mem[5] = 32'h00000009;  // 9
mem[6] = 32'h0000000A;  // 10
        // Initialize other memory locations as needed
    end

    // SPI Parameters and Signals
    parameter MAX_BYTES_PER_CS = 1;
    reg [$clog2(MAX_BYTES_PER_CS+1)-1:0] tx_count_reg;
    reg [7:0] tx_byte_reg;
    reg tx_dv_reg;
    wire o_TX_Ready;
    wire [$clog2(MAX_BYTES_PER_CS+1)-1:0] o_RX_Count;
    wire o_RX_DV;
    wire [7:0] o_RX_Byte;
   
    wire spi_finish_wire;

    // SPI Module Instantiation
    SPI_Master_With_Single_CS #(
        .SPI_MODE(0),
        .CLKS_PER_HALF_BIT(2),
        .MAX_BYTES_PER_CS(MAX_BYTES_PER_CS),
        .CS_INACTIVE_CLKS(1)
    ) spi_inst (
        .i_Rst_L(rst),
        .i_Clk(clk),
        .i_TX_Count(tx_count_reg),
        .i_TX_Byte(tx_byte_reg),
        .i_TX_DV(tx_dv_reg),
        .o_TX_Ready(o_TX_Ready),
        .o_RX_Count(o_RX_Count),
        .o_RX_DV(o_RX_DV),
        .o_RX_Byte(o_RX_Byte),
        .o_SPI_Clk(o_SPI_Clk),
        .i_SPI_MISO(i_SPI_MISO),
        .o_SPI_MOSI(o_SPI_MOSI),
        .o_SPI_CS_n(o_SPI_CS_n),
        .SPI_Finish(spi_finish_wire)
    );

    // Memory Write Logic
    always @(posedge clk) begin
        if (WE == 1'b1) begin
            mem[A] <= WD;
        end
        if (o_RX_DV) begin
            mem[0] <= {24'b0, o_RX_Byte};
        end
    end

    // SPI Transmit Control Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            tx_dv_reg <= 1'b0;
            tx_byte_reg <= 8'b0;
            tx_count_reg <= 0;
        end else begin
            tx_dv_reg <= 1'b0;
            if (WE == 1'b1 && A == 32'd1) begin
                tx_byte_reg <= WD[7:0];
                tx_count_reg <= 1;
                tx_dv_reg <= 1'b1;
            end
        end
    end

    // Memory Read Logic
    always @(*) begin
        if (rst == 1'b0) begin
            RD = 32'd0;
        end else begin
            RD = mem[A];
        end
    end

    // seg_data Update Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            seg_data <= 4'b0000;
        end else begin
            if (WE == 1'b1 && A == 32'd0) begin
                seg_data <= WD[3:0];
            end else if (o_RX_DV) begin
                seg_data <= o_RX_Byte[3:0];
            end
        end
    end

    // Seven-Segment Display Decoder
    seven_segment_display seg_inst (
        .digit(seg_data),
        .segments(seg)
    );
    assign spifinish = spi_finish_wire;

endmodule