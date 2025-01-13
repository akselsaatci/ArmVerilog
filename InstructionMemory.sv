`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12.01.2025 15:20:07
// Design Name: 
// Module Name: InstructionMemory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//
// Dependencies: 
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module InstructionMemory (
    input [31:0] instructionAdress,
    output [31:0] result

);

  reg [31:0] InsturctionMem[31:0];
  assign result = InsturctionMem[instructionAdress];


 initial begin
      
       
        
        for (int i = 0; i < 32; i = i + 1) begin
            InsturctionMem[i] = 32'hE1A00000;  // NOP instruction
        end
        
        
        // 1110 010 1100 0 0011 0111 0000 0000 0100
        //add r7, r0, #5 ---> r7 is 5
        InsturctionMem[0] = 32'b11100010100000000111000000000101;
        
        //str r7, [r3, #4] --> 4th memory is 5
        InsturctionMem[1] = 32'b11100101100000110111000000000100;
        
        //Branch to 7th instruction
        InsturctionMem[2] = 32'b11101010000000000000000000000001;
        
        //LDR R2 [R0,#4] r2 --> is 5
        InsturctionMem[7] = 32'b11100101100100000010000000000100;
        
        // AND R2,r0
        InsturctionMem[8] = 32'b11100000000000000001001011100000;
        
    end

endmodule
