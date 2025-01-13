`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//
// Create Date: 13.01.2025 15:19:40
// Design Name: 
// Module Name: ControlUnit
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

module ControlUnit (
    //http://netwinder.oregonstate.edu/pub/netwinder/docs/arm/ARM8vC.pdf
    input [3:0] cond,
    input [1:0] op,
    input [5:0] funct,
    input [3:0] rd,
    // maybe aslo get flags?
    // flags are required for the conditional
    // ADD CONDITIONS TODO
    output logic [1:0] PCSrc,
    output logic MemToReg,
    output logic MemWrite,
    output logic ALUControl,
    output logic ALUSrc,
    output logic [1:0] ImmSrc,
    output logic [1:0] RegSrc,
    output logic RegWrite
);

  always @(*) begin
    RegDst = 0;
    ALUControl = 0;
    MemRead = 0;
    MemWrite = 0;
    MemToReg = 0;
    RegWrite = 0;
    RegSrc = 0;
    PCSrc = 0;

    case (op)
      //Data Processing
      2'b00: begin
        PCSrc = 1'b0;
        MemToReg = 1'b0;
        MemWrite = 1'b0;
        RegDst = 1'b1;
        RegWrite = 1'b1;
        RegSrc = 2'b00;
        //ALU OPRATION TODO
        case (funct[5])
          //Data Processing Imm or Reg
          1'b0: begin
            ALUSrc = 1'b0;
          end
          1'b1: begin
            ALUSrc = 1'b1;
            ImmSrc = 2'b00;
            //TODO figure out ALUSrc
          end
          //          5'b00000: ALUControl = 2'b00;
          //          5'b00001: ALUControl = 2'b00;
          //          5'b00010: ALUControl = 2'b00;
          //          default:  ALUControl = 0;
        endcase
      end
      //STR OR LDR
      2'b01: begin
        //STR
        PCSrc = 1'b0;
        RegDst = 1'b1;
        RegWrite = 1'b1;
        ImmSrc = 2'b01;
        ALUSrc = 1'b1;
        ALUControl = 2'b00;
        case (funct[0])
          1'b0: begin
            MemToReg = 1'bX;
            MemWrite = 1'b1;
            RegWrite = 1'b0;
            RegSrc   = 2'b10;
          end
          //LDR
          1'b1: begin
            MemToReg = 1'b1;
            MemWrite = 1'b0;
            RegWrite = 1'b1;
            RegSrc   = 2'bX0;
            //ALUOP 0
          end
        endcase
      end
      //BRANCH
      2'b10: begin
        PCSrc = 1'b1;
        MemToReg = 0;
        MemWrite = 0;
        ALUSrc = 1'b1;
        ImmSrc = 2'b10;
        RegWrite = 1'b0;
        RegSrc = 2'bX1;
        ALUControl = 2'b00;
      end
    endcase
  end
endmodule
