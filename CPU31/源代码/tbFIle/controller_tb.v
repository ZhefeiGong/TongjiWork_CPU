`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/07 16:46:23
// Design Name: 
// Module Name: controller_tb
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


module controller_tb();
reg [31:0]IM_instruction;
reg [31:0]PC_data_out;
wire [31:0]PC_data_in;    //***out***  
wire [4:0]RF_waddr;       //***out***--RF5位地址
wire [31:0] RF_wdata;     //***out***
reg [31:0]RF_rdata1;
reg [31:0]RF_rdata2;
wire RF_we;               //***out***  
wire [31:0]ALU_a;         //***out***
wire [31:0]ALU_b;         //***out***
reg [31:0] ALU_r;
reg ALU_zero;
wire [3:0]ALU_aluc;       //***out***--ALU指令  
reg [31:0]DM_data_out;
wire DM_ena;              //***out***
wire DM_wena;              //***out***

initial begin
    IM_instruction = 32'h10220001;
    PC_data_out = 32'b00000000;//初始化
    RF_rdata1= 32'h00000003;
    RF_rdata2= 32'h00000004;
    ALU_r = 32'h2000ffff;
    ALU_zero = 1'b0;
    DM_data_out=32'h0f0f0f0f0f;
end

controller ctrl(
.IM_instruction(IM_instruction),
.PC_data_out(PC_data_out),
.PC_data_in(PC_data_in),    //***out***  
.RF_waddr(RF_waddr),       //***out***--RF5位地址
.RF_wdata(RF_wdata),     //***out***
.RF_rdata1(RF_rdata1),
.RF_rdata2(RF_rdata2),
.RF_we(RF_we),               //***out***  
.ALU_a(ALU_a),         //***out***
.ALU_b(ALU_b),         //***out***
.ALU_r(ALU_r),
.ALU_zero(ALU_zero),
.ALU_aluc(ALU_aluc),       //***out***--ALU指令  
.DM_data_out(DM_data_out),
.DM_ena(DM_ena),              //***out***
.DM_wena(DM_wena)              //***out***
);


endmodule
