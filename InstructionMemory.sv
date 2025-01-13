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

endmodule
