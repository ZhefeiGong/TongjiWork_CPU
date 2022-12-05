`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.26 - 2022.7.26
//@function : 实现5bit无符号扩展至32bit
module EXT5_UNSIGNED(
    input [4:0] sa,
    output [31:0]data
    );
assign data={27'b0,sa};
endmodule
