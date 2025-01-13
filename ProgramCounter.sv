`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.01.2025 15:29:20
// Design Name: 
// Module Name: ProgramCounter
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


module ProgramCounter (
    clock,
    pcIn,
    PcOut
);
  input clock;
  input [31:0] pcIn;
  output reg [31:0] PcOut;
  always @(posedge clock) begin
    PcOut <= pcIn;
  end
  
   initial begin
        PcOut = 32'h0;
    end
endmodule
