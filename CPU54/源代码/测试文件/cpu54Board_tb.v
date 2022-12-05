`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.29 - 2022.7.29
//@function : 下板测试文件
module cpu54Board_tb();  
    reg clk;
    reg rst;
    wire [7:0] o_seg;
    wire [7:0] o_sel;

    // 参数初始化
    initial begin
        clk = 1'b1;
        rst = 1'b1;
        #225 rst =1'b0;
    end

    // 时钟
    always begin
        #50 clk = !clk;
    end

    // CPU54实例化
    cpu54Board board(
       .clk_in(clk),
       .reset(rst),
       .o_seg(o_seg),
       .o_sel(o_sel)
    );
endmodule

