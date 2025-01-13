
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.01.2025 15:35:54
// Design Name: 
// Module Name: Data Memory 
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
module DataMemory (
    input logic clk,
    writeEnable,
    input logic [31:0] adress,
    writeData,
    output logic [31:0] rd

);
  logic [31:0] RAM[63:0];

  assign rd = RAM[a];

  always_ff @(posedge clk) begin
    if (writeEnable) begin
      RAM[adress] <= wd;
    end
  end

endmodule
