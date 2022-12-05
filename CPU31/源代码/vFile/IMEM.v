`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 17:27:40
// Design Name: 
// Module Name: IMEM
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

//指令寄存器--调用IP核--即用即得
module IMEM(
    input [10:0] IM_addr,
    output [31:0] IM_instruction
    );
    ipcore instr_mem(
        .a(IM_addr),
        .spo(IM_instruction)
    );
endmodule
