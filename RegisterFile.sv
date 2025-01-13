`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.01.2025 15:35:54
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile (
    input wire clk,              
    input wire RegWrite,          
    input wire [4:0] a1,          
    input wire [4:0] a2,          
    input wire [4:0] a3,          
    input wire [31:0] wd3, 
    input wire [31:0] iR15,
    output wire [31:0] RD1,
    output wire [31:0] RD2 
);

    reg [31:0] register [31:0];

    always @(posedge clk) begin
       register[15] <= iR15;
        if (RegWrite) begin
              register[a3] <= wd3;
        end
    end
    assign RD1 = register[a1];
    assign RD2 = register[a2];

endmodule

