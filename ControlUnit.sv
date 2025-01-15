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

  logic old_v = 1'b0;
  logic old_c = 1'b0;
  logic old_n = 1'b0;
  logic old_z = 1'b0;
  logic isThisCycleGoingToExecute = 1'b0;

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
    //this is for condition
    execute = 1'b0;

    //CONDITIONAL LOGIC UNIT

    //        0000 = EQ - Z set (equal)
    //        0001 = NE - Z clear (not equal)
    //        0010 = CS - C set (unsigned higher or same)
    //        0011 = CC - C clear (unsigned lower)
    //        0100 = MI - N set (negative)
    //        0101 = PL - N clear (positive or zero)
    //        0110 = VS - V set (overflow)
    //        0111 = VC - V clear (no overflow)
    //        1000 = HI - C set and Z clear (unsigned higher)
    //        1001 = LS - C clear or Z set (unsigned lower or same)
    //        1010 = GE - N set and V set, or N clear and V clear (greater or equal)
    //        1011 = LT - N set and V clear, or N clear and V set (less than)
    //        1100 = GT - Z clear, and either N set and V set, or N clear and V clear (greater than)
    //        1101 = LE - Z set, or N set and V clear, or N clear and V set (less than or equal)
    //        1110 = AL - Always

    case (cond)
      4'b0000 && old_z: execute = 1'b1;
      4'b0001 && !old_z: execute = 1'b1;
      4'b0010 && old_c: execute = 1'b1;
      4'b0011 && !old_c: execute = 1'b1;
      4'b0100 && old_n: execute = 1'b1;
      4'b0101 && !old_n: execute = 1'b1;
      4'b0110 && old_v: execute = 1'b1;
      4'b0111 && !old_v: execute = 1'b1;
      4'b1000 && old_c && !old_z: execute = 1'b1;
      4'b1001 && !old_c && old_z: execute = 1'b1;
      4'b1010 && ((old_n && old_v) || (!old_n && !old_v)): execute = 1'b1;
      4'b1011 && ((old_n && !old_v) || (!old_n && old_v)): execute = 1'b1;
      4'b1100 && ((old_n && !old_v) || (!old_n && old_v)): execute = 1'b1;
      4'b1100 && (!old_z && ((old_n && old_v) || (!old_n && !old_v))): execute = 1'b1;
      4'b1101 && (old_z || (old_n && !old_v) || (!old_n && old_v)): execute = 1'b1;
      4'b1110: execute = 1'b1;
    endcase

    if (execute) begin
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
            end
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
          //Flag Write
          if (funct[0] == 1) begin
            old_v = v;
            old_c = c;
            old_n = n;
            old_z = z;
          end
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
  end
endmodule
