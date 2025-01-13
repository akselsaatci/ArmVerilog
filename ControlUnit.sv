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
    input v,
    input c,
    input n,
    input z,
    // maybe aslo get flags?
    // flags are required for the conditional
    // ADD CONDITIONS TODO
    output logic [1:0] PCSrc,
    output logic MemToReg,
    output logic MemWrite,
    output logic [1:0] ALUControl,
    output logic ALUSrc,
    output logic [1:0] ImmSrc,
    output logic [1:0] RegSrc,
    output logic RegWrite
);

  always @(*) begin

    //Asaigning default
    PCSrc = 2'b00;
    MemToReg = 1'b0;
    MemWrite = 1'b0;
    ALUControl = 2'b00;
    ALUSrc = 1'b0;
    ImmSrc = 2'b00;
    RegSrc = 2'b00;
    RegWrite = 1'b0;

    case (op)
      //Data Processing
      2'b00: begin
        PCSrc = 1'b0;
        MemToReg = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b1;
        RegSrc = 2'b00;
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
          //TODO currently there is no flagwrite maybe consider it later
        endcase
        // Here is basically alu decoder
        case (funct[4:1])
          //ADD
          4'b0100: begin
            ALUControl = 2'b00;
          end
          //SUB
          4'b0010: begin
            ALUControl = 2'b01;
          end
          //AND
          4'b0000: begin
            ALUControl = 2'b10;
          end
          //OR
          4'b1100: begin
            ALUControl = 2'b11;
          end
        endcase
      end
      //STR OR LDR
      2'b01: begin
        //STR
        PCSrc = 1'b0;
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
