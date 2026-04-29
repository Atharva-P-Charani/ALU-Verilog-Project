`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.04.2026 11:34:09
// Design Name: 
// Module Name: ALU
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
//ARTHEMETIC OPERATION
module arthmetic #(parameter N=8)(input [N-1:0]A,B,input[1:0]op,output reg[N-1:0]result,output reg carry,output reg overflow);
always@(*) begin 
  carry=0;
  overflow=0;
  case(op)
   2'b00:{carry,result}=A+B;
   2'b01:{carry,result}=A-B;
   2'b10:result=A+1;
   2'b11:result=A-1;
  endcase 
  overflow=(A[N-1]==B[N-1])&&(result[N-1]!=A[N-1]);
  end
endmodule

//LOGIC OPERATION
module logic #(parameter N=8)(input [N-1:0]A,B,input[1:0]op,output reg[N-1:0]result);
always@(*) begin 
  case(op)
    2'b00:result=A&B;
    2'b01:result=A|B;
    2'b10:result=A^B;
    2'b11:result=~A;
   endcase
   end 
endmodule  

//SHIFTING OPERATION 
module shifter #(parameter N=8)(input[N-1:0]A,input[1:0]op,output reg [N-1:0]result);
always@(*) begin
  case(op)
    2'b00:result=A<<1;
    2'b01:result=A>>1;
    2'b10:result={A[N-2:0],1'b0};
    2'b11:result={1'b0,A[N-1:1]};
    endcase
    end
 endmodule
 
//TOP MODULE ARTHMETIC and LOGICAL UNIT (ALU)    
module ALU #(parameter N=8)(
    input[N-1:0] A,B,input[3:0]opcode,
    output reg[N-1:0] result,output zero,output carry,output overflow
    );
    wire [N-1:0]arthout,logicout,shiftout;
    wire c,ov;
    arthmetic #(N) AU(A,B,opcode[1:0],arthout,c,ov);
    logic #(N) LU(A,B,opcode[1:0],logicout);
    shifter #(N) SU(A,opcode[1:0],shiftout);
    assign carry=c;
    assign overflow=ov;
    always@(*) begin
      case(opcode[3:2])
        2'b00:result=arthout;
        2'b01:result=logicout;
        2'b10:result=shiftout;
      endcase
    end
    assign zero=(result==0);     
endmodule

//TESTBENCH for 8-bit ALU
module tb;
parameter N=8;
reg[N-1:0]A,B;
reg[3:0]opcode;
wire [N-1:0]result;
wire carry,zero,overflow;
ALU #(N) DUT(.A(A),.B(B),.opcode(opcode),.result(result),.carry(carry),.overflow(overflow),.zero(zero));
initial begin
  A=8'd10;B=8'd6;
 #10 opcode=4'b0000;
 #10 opcode=4'b0001;
 #10 opcode=4'b0010;
 #10 opcode=4'b0011;
 #10 opcode=4'b0100;
 #10 opcode=4'b0101;
 #10 opcode=4'b0110;
 #10 opcode=4'b0111;
 #10 opcode=4'b1000;
 #10 opcode=4'b1001;
 
 #10 A=8'd5;B=8'd5;
 #10 opcode=4'b0001;
 
 #10 A=8'd127;B=8'd1;
 #10 opcode=4'b0000;
 
 #10 $finish;
 end
 endmodule
  


