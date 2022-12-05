`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.26 - 2022.7.26
//@function : 3输入32bit多路选择器
module MUX3IN(
    input [1:0]Order,
    input [31:0]DataIn0,
    input [31:0]DataIn1,
    input [31:0]DataIn2,
    output [31:0]DataOut
    );
parameter [1:0] SIGN0=2'b00,SIGN1=2'b01,SIGN2=2'b10;
assign DataOut = (Order==SIGN0)?DataIn0:
                 ((Order==SIGN1)?DataIn1:
                 ((Order==SIGN2)?DataIn2:
                 32'bz));

endmodule
