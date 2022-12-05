`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.26 - 2022.7.26
//@function : 5输入32bit多路选择器
module MUX5IN(
    input [2:0]Order,
    input [31:0]DataIn0,
    input [31:0]DataIn1,
    input [31:0]DataIn2,
    input [31:0]DataIn3,
    input [31:0]DataIn4,
    output [31:0]DataOut
    );
parameter [2:0]SIGN0 = 3'b000,SIGN1 = 3'b001,SIGN2 = 3'b010,SIGN3 = 3'b011,SIGN4 = 3'b100;
assign DataOut = (Order==SIGN0)?DataIn0:
                 ((Order==SIGN1)?DataIn1:
                 ((Order==SIGN2)?DataIn2:
                 ((Order==SIGN3)?DataIn3:
                 ((Order==SIGN4)?DataIn4:
                 32'bz))));
endmodule
