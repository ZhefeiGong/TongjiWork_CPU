`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.26 - 2022.7.26
//@function : 32bit多周期寄存器
module DATAREG(
    input clk, //上升沿有效
    input rst,
    input ena,
    input [31:0]data_in,
    output [31:0]data_out
    );
reg [31:0]DReg;

always@(posedge clk or posedge rst)begin
    if(rst)begin
        DReg <= 32'b0;
    end
    else if(ena)begin
        DReg <= data_in;
    end
end

assign data_out = DReg;

endmodule