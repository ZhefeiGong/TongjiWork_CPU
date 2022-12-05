`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.27 - 2022.7.27
//@function : 7输入32bit多路选择器


module MUX7IN(
    input [2:0]Order,
    input [31:0]DataIn0,
    input [31:0]DataIn1,
    input [31:0]DataIn2,
    input [31:0]DataIn3,
    input [31:0]DataIn4,
    input [31:0]DataIn5,
    input [31:0]DataIn6,
    output [31:0]DataOut
    );
parameter [2:0]SIGN0 = 3'b000,SIGN1 = 3'b001,SIGN2 = 3'b010,SIGN3 = 3'b011,SIGN4 = 3'b100,SIGN5 = 3'b101,SIGN6 = 3'b110;
assign DataOut = (Order==SIGN0)?DataIn0:
                 ((Order==SIGN1)?DataIn1:
                 ((Order==SIGN2)?DataIn2:
                 ((Order==SIGN3)?DataIn3:
                 ((Order==SIGN4)?DataIn4:
                 ((Order==SIGN5)?DataIn5:
                 ((Order==SIGN6)?DataIn6:
                 32'bz))))));
endmodule