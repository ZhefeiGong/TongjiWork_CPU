`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/08 18:08:53
// Design Name: 
// Module Name: cpu31Board
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


module cpu31Board(
    input clk_in,
    input reset,
    output [7:0] o_seg,
    output [7:0] o_sel
    );
    parameter cutSites = 26;   //cpu主频分频自定义--> 便于可视化 故采用26分频
    wire [31:0] inst;           //cpu指令
    wire [31:0] pc;             //pc位置
    
    //cpu时钟分频
    reg  [cutSites:0] cnt;
    always @(posedge clk_in or posedge reset)begin
        if(reset)
            cnt<= 0;
        else
            cnt<=cnt+1'b1;
    end
    wire signClk = cnt[cutSites];
    
    //cpu实例化
    sccomp_dataflow gonzalez(
           .clk_in(signClk),
           .reset(reset),
           .inst(inst),
           .pc(pc)
    );
    
    //数码管实例化
    wire cs = 1'b1;
    seg7x16 show(
         .clk(clk_in),
         .reset(reset),//上升沿有效
         .cs(cs),
         .i_data(inst),
         .o_seg(o_seg),
         .o_sel(o_sel)
        );
       
endmodule
