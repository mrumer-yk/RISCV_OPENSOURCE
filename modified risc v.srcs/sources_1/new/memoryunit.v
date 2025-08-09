
module memoryunit(
    input [31:0] A,           // Address input (should be a multiple of 4)
    input reset,              // Reset signal
    output reg [31:0] rd      // Output instruction or value
);
    reg [31:0] memory [0:31]; // Memory array to store values (32 locations)

    // Initialize memory with specific values and instructions
    initial begin
    /*
       memory[0] = 32'h0000a307;
memory[1] = 32'h0010a387;
memory[2] = 32'h0000ab07;
memory[3] = 32'h0000ab87;
memory[4] = 32'h00737453;
memory[5] = 32'h008474d3;
memory[6] = 32'h1084f553;
memory[7] = 32'h08a3f5d3;
memory[8] = 32'h18a5f653;
*/ 
memory[0]  = 32'h00000313;
memory[1]  = 32'h00600093;
memory[2]  = 32'h00300193;
memory[3]  = 32'h00200413;
memory[4]  = 32'h00100393;
memory[5]  = 32'h0660c463;
memory[6]  = 32'h00100493;
memory[7]  = 32'h00100493;
memory[8]  = 32'h00130133;
memory[9]  = 32'h02814133;
memory[10] = 32'h00010293;
memory[11] = 32'h0002a203;

memory[12] = 32'h00000013;  // new insertion 1
memory[13] = 32'h00000013;  // new insertion 2

memory[14] = 32'h02320c63;  // original memory[12]
memory[15] = 32'h00100493;  // original memory[13]
memory[16] = 32'h00100493;  // original memory[14]
memory[17] = 32'h00324e63;  // original memory[15]
memory[18] = 32'h00100493;  // original memory[16]
memory[19] = 32'h00100493;  // original memory[17]
memory[20] = 32'h409100b3;  // original memory[18]
memory[21] = 32'hfc0000e3;  // original memory[19]
memory[22] = 32'h00000013;  // original memory[20]
memory[23] = 32'h00000013;  // original memory[21]
memory[24] = 32'h00110313;  // original memory[22]
memory[25] = 32'hfa0008e3;  // original memory[23]
memory[26] = 32'h00000013;  // original memory[24]
memory[27] = 32'h00000013;  // original memory[25]
memory[28] = 32'h00000863;  // original memory[26]
memory[29] = 32'h00000013;  // original memory[27]
memory[30] = 32'h00000013;  // original memory[28]
memory[31] = 32'hfff00113;  // original memory[29]
memory[32] = 32'h002023a3;  // original memory[30]
memory[33] = 32'h04f00a13;






        //memory[4]= 32'h00500113; 
        //memory[5] = 32'h00310263; 
        //memory[6]=32'h003102b3;
        
      //  memory[4] = 32'h00300133 ;         
      
      //  memory[5] = 32'hfff08093;
      //  memory[6] = 32'hfe1048e3;            
        
      //  memory[4]=32'h00208433; //add x8, x1, x2
       // memory[5] = 32'h002084b3; // add x9, x1, x2
       // memory[6] = 32'h02208533; // mul x10, x1, x2
        
       // memory[6] = 32'h00000013; 
        //memory[7] = 32'h00000013; 
        //memory[8] = 32'h00000013; 
        // memory[9] = 32'h00000013;  
        //memory[4]=32'h00a40493;
      //  memory[4]=32'h02110133;
       //memory[5]=32'h022082b3 ;
       //memory[6]=32'h025301b3 ;
      // memory[7]=32'hfe2098e3 ;
         //- beq x4, x5, 0x0000000c
        //memory[4]=32'h002081b3;//blt x5,x6,0X08
       // memory[3]=32'h01400113;//bge x8,x9,0Xac 
//00400093
//00100113
//00209863
//00100513
//02110133
//fff08093
//00009863
//00300093 
//00000113 
//00100193 
//0110113 
//002002b3 
//00300333 
//025301b3  

    end

    // Output assignment with reset functionality
    always @(*) begin
        if (reset == 1'b0) begin
            rd = 32'h00000000;  // Clear output if reset is active
        end else begin
            rd = memory[A[31:2]]; // Access memory at word-aligned address
        end
    end

endmodule 

