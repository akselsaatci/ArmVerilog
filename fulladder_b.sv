`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.05.2019 12:46:00
// Design Name: 
// Module Name: fulladder_b
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


module fulladder_b(input logic [31:0] a, b,
input logic cin,
output logic [31:0] s,
output logic cout  );
wire [32:0] c;

assign c=a+b;
assign cout=c[32];
assign s=c[31:0];

endmodule
