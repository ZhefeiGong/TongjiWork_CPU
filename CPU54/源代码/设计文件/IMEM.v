`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.26 - 2022.7.26
//@function : 指令寄存器--调用IP核--即用即得==>组合逻辑
module IMEM(
    input [10:0] IM_addr,
    output [31:0] IM_instruction
    );
    // need to input ipcore
    ipcore instr_mem(
        .a(IM_addr),
        .spo(IM_instruction)
    );
endmodule
