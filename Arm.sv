
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.01.2025 15:35:54
// Design Name: 
// Module Name: Arm 
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
module Arm (
    input clk
);

  wire [31:0] pc;
  wire [31:0] nextPc;
  wire [31:0] Instruction;
  wire [31:0] ExtImm;
  wire [31:0] PCPlusFour;
  wire [31:0] PCPlusEight;
  wire [31:0] AluResult;
  wire [31:0] WriteData;
  wire [31:0] ReadData;
  wire [31:0] Result;
  wire [31:0] SrcA;
  wire [31:0] SrcB;
  wire [31:0] SrcBN;
  wire [1:0] pcSrc;
  wire memToReg;
  wire memWrite;
  wire v;
  wire c;
  wire n;
  wire z;
  wire [1:0] aluControl;
  wire aluSrc;
  wire [1:0] immSrc;
  wire [1:0] regSrc;
  wire regWrite;
  wire voidWire;
  wire [3:0] RA1;
  wire [3:0] RA2;


  mux32bitCtrl MuxForPC(
      .d0(PCPlusFour),
      .d1(Result),
      .s (pcSrc),
      .y (nextPc)
  );


  ProgramCounter PC (
      .clock(clk),
      .pcIn (nextPc),
      .PcOut(pc)
  );


  fulladder_b fullAdderForPcPlusFour (
      .a(pc),
      .b(32'b00000000000000000000000000000001),
      .cin(1'b0),
      .s(PCPlusFour),
      .cout(voidWire)
  );


  fulladder_b fullAdderForPcPlusEight (
      .a(pc),
      .b(32'b00000000000000000000000000000010),
      .cin(1'b0),
      .s(PCPlusEight),
      .cout(voidWire)
  );

  InstructionMemory IM (
      .instructionAdress(pc),
      .result(Instruction)
  );

  ControlUnit ControlUnit (
      .cond(Instruction[31:28]),
      .op(Instruction[27:26]),
      .funct(Instruction[25:20]),
      .rd(Instruction[15:12]),
      .PCSrc(pcSrc),
      .MemToReg(memToReg),
      .MemWrite(memWrite),
      .ALUControl(aluControl),
      .ALUSrc(aluSrc),
      .ImmSrc(immSrc),
      .RegSrc(regSrc),
      .RegWrite(regWrite),
      .v(v),
      .c(c),
      .n(n),
      .z(z)
  );

  mux4bitCtrl MuxForRA1 (
      .d0(Instruction[19:16]),
      .d1(4'b1111),
      .s (regSrc[0]),
      .y (RA1)
  );

  mux4bitCtrl MuxForRA2 (
      .d0(Instruction[3:0]),
      .d1(Instruction[15:12]),
      .s (regSrc[1]),
      .y (RA2)
  );

  RegisterFile RegFile (
      .clk(clk),
      .RegWrite(regWrite),
      .a1(RA1),
      .a2(RA2),
      .a3(Instruction[15:12]),
      .wd3(Result),
      .iR15(PCPlusEight),
      .RD1(SrcA),
      .RD2(SrcB)
  );

  ExtendUnit ExUnit (
      .inst  (Instruction[23:0]),
      .immSrc(immSrc),
      .ExtImm(ExtImm)
  );

  mux32bitCtrl MuxForSrcB (
      .d0(SrcB),
      .d1(ExtImm),
      .s (aluSrc),
      .y (SrcBN)
  );

  ALUflags Alu (
      .A(SrcA),
      .B(SrcBN),
      .ALUControl(aluControl),
      .result(AluResult),
      .V(v),
      .C(c),
      .N(n),
      .Z(z)
  );



  DataMemory DMemory (
      .clk(clk),
      .writeEnable(memWrite),
      .adress(AluResult),
      .writeData(SrcB),
      .rd(ReadData)
  );

  mux32bitCtrl MuxForResult (
      .d0(AluResult),
      .d1(ReadData),
      .s (memToReg),
      .y (Result)
  );


endmodule


module mux4bitCtrl (
    input logic [3:0] d0,
    input logic [3:0] d1,
    input logic s,
    output logic [3:0] y
);

  assign y = s ? d1 : d0;
endmodule

module mux32bitCtrl (
    input logic [31:0] d0,
    input logic [31:0] d1,
    input logic s,
    output logic [31:0] y
);

  assign y = s ? d1 : d0;
endmodule

