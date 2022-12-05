`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.26 - 2022.7.26
//@function : 对DMEM传出数据进行处理
module CONV(
    input[31:0]data_in,
    input LhEn,
    input LbEn,
    input LhuEn,
    input LbuEn,
    output reg[31:0] data_out
    );

always@(*)begin
    if(LhEn==1'b1)            // 有符号拓展
        data_out = (data_in[15]==1'b1)?{16'b1111111111111111,data_in[15:0]}:{16'b0,data_in[15:0]};
    else if(LbEn==1'b1)       // 有符号拓展
        data_out = (data_in[7]==1'b1)?{24'b111111111111111111111111,data_in[7:0]}:{24'b0,data_in[7:0]};
    else if(LhuEn)            // 0拓展
        data_out = {16'b0,data_in[15:0]};
    else if(LbuEn)            // 0拓展
        data_out = {24'b0,data_in[7:0]};
    else
        data_out = data_in;
end


endmodule
