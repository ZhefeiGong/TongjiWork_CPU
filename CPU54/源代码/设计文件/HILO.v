`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.26 - 2022.7.26
//@function : HILO¼Ä´æÆ÷
module HILO(
    input clk,
    input rst,
    input HI_EN,
    input LO_EN,
    input [31:0]wHi,
    input [31:0]wLo,
    output [31:0]rHi,
    output [31:0]rLo
    );
reg [31:0] HiReg;
reg [31:0] LoReg;


always @(posedge clk or posedge rst)begin
    if(rst)begin
        HiReg<=32'b0;
        LoReg<=32'b0;
    end
    else if(HI_EN&&LO_EN)begin
        HiReg<=wHi;
        LoReg<=wLo;
    end
    else if(HI_EN)begin
        HiReg<=wHi;
    end
    else if(LO_EN)begin
        LoReg<=wLo;
    end
end

assign rHi = HiReg; // µ¼³ö¼Ä´æÆ÷HIÄÚÈÝ
assign rLo = LoReg; // µ¼³ö¼Ä´æÆ÷LOÄÚÈÝ

endmodule
