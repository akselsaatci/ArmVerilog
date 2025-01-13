`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.01.2025 13:09:24
// Design Name: 
// Module Name: ExtendUnit
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


module ExtendUnit (
    input  logic [23:0] inst,
    input  logic [ 1:0] immSrc,
    output logic [31:0] ExtImm
);
  always_comb begin
    case (immSrc)
      2'b00: begin
        ExtImm = {24'b0, inst[7:0]};
      end
      2'b01: begin
        ExtImm = {20'b0, inst[11:0]};
      end
      2'b10: begin
        ExtImm = {{6{inst[23]}}, inst[23:0], 2'b00};
      end
      default: begin
        //Not supported
      end
    endcase
  end
endmodule
