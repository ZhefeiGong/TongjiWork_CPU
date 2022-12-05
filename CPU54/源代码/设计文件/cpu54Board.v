`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.29 - 2022.7.29
//@function : 实现下板综合操作
module cpu54Board(
    input clk_in,
    input reset,
    output [7:0] o_seg,
    output [7:0] o_sel
    );
    parameter cutSites = 18;     //cpu主频分频自定义--> 便于可视化 故采用26分频
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
    
    //54多周期cpu实例化
    sccomp_dataflow gonzalez(
           .clk_in(signClk),
           .reset(reset),
           .inst(inst),
           .pc(pc)
    );
    
    //数码管实例化
    wire cs = 1'b1;// need to change
    seg7x16 show(
         .clk(clk_in),
         .reset(reset),//上升沿有效
         .cs(cs),
         .i_data(pc),
         .o_seg(o_seg),
         .o_sel(o_sel)
        );
       
endmodule
