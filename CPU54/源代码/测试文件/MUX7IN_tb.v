`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.28 - 2022.7.28
//@function : 测试多路选择器

module MUX7IN_tb();
    reg [2:0]Order;
    reg [31:0]DataIn0;
    reg [31:0]DataIn1;
    reg [31:0]DataIn2;
    reg [31:0]DataIn3;
    reg [31:0]DataIn4;
    reg [31:0]DataIn5;
    reg [31:0]DataIn6;
    wire [31:0]DataOut;

//时钟赋值
initial begin
    Order <= 3'b000;
    DataIn0 <= 0;
    DataIn1 <= 1;
    DataIn2 <= 2;
    DataIn3 <= 3;
    DataIn4 <= 4;
    DataIn5 <= 5;
    DataIn6 <= 6;
end


MUX7IN test(
.Order(Order),
.DataIn0(DataIn0),
.DataIn1(DataIn1),
.DataIn2(DataIn2),
.DataIn3(DataIn3),
.DataIn4(DataIn4),
.DataIn5(DataIn5),
.DataIn6(DataIn6),
.DataOut(DataOut));



endmodule
