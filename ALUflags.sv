`timescale 1ns / 1ps

module ALUflags(input [31:0] A, B,
input [1:0] ALUControl,
output [31:0]result,
output V, C, N, Z
    );
    wire [31:0] n1,n2,n3,n4,nb;
    wire n5,n6,cout;    
    assign nb=~B + 1;
    assign n3=A&B;
    assign n4=A|B;
    assign C= (~ALUControl[1])&cout;
    assign n5=n2[31]^A[31];
    assign n6=~(ALUControl[0] ^ A[31] ^ B[31]);
    assign V= (~ALUControl[1]) & n5 & n6;
    assign Z= &(~result);
    assign N=result[31];
    mux2 first_mux (B,nb,ALUControl[0],n1);
    fulladder_b firs_adder (A,n1,ALUControl[0],n2,cout);
    mux4 secound_mux (n2,n2,n3,n4,ALUControl,result);
endmodule

module mux2(input logic [31:0] d0, d1,
input logic s,
output logic [31:0] y);

assign y = s ? d1 : d0;

endmodule
module mux4(input logic [31:0] d0, d1, d2, d3,
input logic [1:0] s,
output logic [31:0] y);

assign y = s[1] ? (s[0] ? d3: d2): (s[0] ? d1 : d0);

endmodule
