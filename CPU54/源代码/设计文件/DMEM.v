`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.26 - 2022.7.26
//@function : 实现DMEM部件-->数据存储器--即ram
module DMEM(
    input clk,   //上升沿有效
    input ena,   //高电平有效-->始终有效
    input wena,  //高写低读
    input reset, //高电平有效
    input [31:0] addr,
    input [1:0] DM_SIZE,
    input [31:0] data_in,
    output[31:0] data_out
);

// 初始化参数
reg [31:0] store [31:0];     // 存储器含32个32位的寄存器
parameter [1:0]OP_SW = 2'b00, OP_SH = 2'b01, OP_SB = 2'b10;

wire [31:0] addr_changed = (DM_SIZE==OP_SB)?(addr):((DM_SIZE==OP_SH)?(addr/2):(addr/4));     // 进行地址映射

// 写入数据-下降沿
always@(posedge clk)        // 下降沿有效
begin
if(reset==1'b1)begin
    store[0]<=32'b0;
    store[1]<=32'b0;
    store[2]<=32'b0;
    store[3]<=32'b0;
    store[4]<=32'b0;
    store[5]<=32'b0;
    store[6]<=32'b0;
    store[7]<=32'b0;
    store[8]<=32'b0;
    store[9]<=32'b0;
    store[10]<=32'b0;
    store[11]<=32'b0;
    store[12]<=32'b0;
    store[13]<=32'b0;
    store[14]<=32'b0;
    store[15]<=32'b0;
    store[16]<=32'b0;
    store[17]<=32'b0;
    store[18]<=32'b0;
    store[19]<=32'b0;
    store[20]<=32'b0;
    store[21]<=32'b0;
    store[22]<=32'b0;
    store[23]<=32'b0;
    store[24]<=32'b0;
    store[25]<=32'b0;
    store[26]<=32'b0;
    store[27]<=32'b0;                  
    store[28]<=32'b0;
    store[29]<=32'b0;
    store[30]<=32'b0;
    store[31]<=32'b0;
    end
else if(ena==1'b1&&wena==1'b1)begin
    if(DM_SIZE==OP_SW)
        store[addr_changed[4:0]]<=data_in;   
    else if(DM_SIZE==OP_SH)
        store[addr_changed[4:0]][15:0]<=data_in[15:0];
    else if(DM_SIZE==OP_SB)
        store[addr_changed[4:0]][7:0]<=data_in[7:0];
    else
        store[addr_changed[4:0]]<=data_in;
    end
end
assign data_out = (ena==1'b1)? store[addr_changed[4:0]]:32'bz;

endmodule