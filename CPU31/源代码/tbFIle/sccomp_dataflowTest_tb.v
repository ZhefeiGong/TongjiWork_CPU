`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/07 13:23:50
// Design Name: 
// Module Name: sccomp_dataflowTest_tb
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

//test for CPU31
module sccomp_dataflowTest_tb();
    reg clk_in;
    reg reset;
    wire [31:0] inst;
    wire [31:0] pc;
    reg [31:0] cnt;
    /*-------------------------------------后仿真TESTBENCH-------------------------------------
    initial begin
       clk_in = 1'b1;
       reset = 1'b1;
       #1 reset=1'b0;
       cnt = 0;
    end
    always begin
       #5 clk_in = !clk_in;
    end*/
    
    
    //-------------------------------------前仿真TESTBENCH-------------------------------------
    integer file_open;
    initial begin
        clk_in = 1'b0;
        reset = 1'b1;
        #3;
        reset=1'b0;
        cnt = 0;
        file_open = $fopen("result.txt");
    end
    //时钟赋值
    always begin
        #5;
        clk_in = ~clk_in;
    end
    //执行指令--打印结果
    always @(posedge clk_in) begin
        cnt <= cnt + 1'b1;
        if(cnt<=500)begin
        $fdisplay(file_open, "pc: %h", pc);
        $fdisplay(file_open, "instr: %h", inst);
        $fdisplay(file_open, "regfile0: %h", sc.sccpu.cpu_ref.array_reg[0]);
        $fdisplay(file_open, "regfile1: %h", sc.sccpu.cpu_ref.array_reg[1]);
        $fdisplay(file_open, "regfile2: %h", sc.sccpu.cpu_ref.array_reg[2]);
        $fdisplay(file_open, "regfile3: %h", sc.sccpu.cpu_ref.array_reg[3]);
        $fdisplay(file_open, "regfile4: %h", sc.sccpu.cpu_ref.array_reg[4]);
        $fdisplay(file_open, "regfile5: %h", sc.sccpu.cpu_ref.array_reg[5]);
        $fdisplay(file_open, "regfile6: %h", sc.sccpu.cpu_ref.array_reg[6]);
        $fdisplay(file_open, "regfile7: %h", sc.sccpu.cpu_ref.array_reg[7]);
        $fdisplay(file_open, "regfile8: %h", sc.sccpu.cpu_ref.array_reg[8]);
        $fdisplay(file_open, "regfile9: %h", sc.sccpu.cpu_ref.array_reg[9]);
        $fdisplay(file_open, "regfile10: %h", sc.sccpu.cpu_ref.array_reg[10]);
        $fdisplay(file_open, "regfile11: %h", sc.sccpu.cpu_ref.array_reg[11]);
        $fdisplay(file_open, "regfile12: %h", sc.sccpu.cpu_ref.array_reg[12]);
        $fdisplay(file_open, "regfile13: %h", sc.sccpu.cpu_ref.array_reg[13]);
        $fdisplay(file_open, "regfile14: %h", sc.sccpu.cpu_ref.array_reg[14]);
        $fdisplay(file_open, "regfile15: %h", sc.sccpu.cpu_ref.array_reg[15]);
        $fdisplay(file_open, "regfile16: %h", sc.sccpu.cpu_ref.array_reg[16]);
        $fdisplay(file_open, "regfile17: %h", sc.sccpu.cpu_ref.array_reg[17]);
        $fdisplay(file_open, "regfile18: %h", sc.sccpu.cpu_ref.array_reg[18]);
        $fdisplay(file_open, "regfile19: %h", sc.sccpu.cpu_ref.array_reg[19]);
        $fdisplay(file_open, "regfile20: %h", sc.sccpu.cpu_ref.array_reg[20]);
        $fdisplay(file_open, "regfile21: %h", sc.sccpu.cpu_ref.array_reg[21]);
        $fdisplay(file_open, "regfile22: %h", sc.sccpu.cpu_ref.array_reg[22]);
        $fdisplay(file_open, "regfile23: %h", sc.sccpu.cpu_ref.array_reg[23]);
        $fdisplay(file_open, "regfile24: %h", sc.sccpu.cpu_ref.array_reg[24]);
        $fdisplay(file_open, "regfile25: %h", sc.sccpu.cpu_ref.array_reg[25]);
        $fdisplay(file_open, "regfile26: %h", sc.sccpu.cpu_ref.array_reg[26]);
        $fdisplay(file_open, "regfile27: %h", sc.sccpu.cpu_ref.array_reg[27]);
        $fdisplay(file_open, "regfile28: %h", sc.sccpu.cpu_ref.array_reg[28]);
        $fdisplay(file_open, "regfile29: %h", sc.sccpu.cpu_ref.array_reg[29]);
        $fdisplay(file_open, "regfile30: %h", sc.sccpu.cpu_ref.array_reg[30]);
        $fdisplay(file_open, "regfile31: %h", sc.sccpu.cpu_ref.array_reg[31]);
        //$fdisplay(file_open, "ALU_zero: %h", sc.sccpu.ALU_zero);//for test
        //for test
        //$fdisplay(file_open, "store0: %h", sc.dmemory.store[0]);
        //$fdisplay(file_open, "store1: %h", sc.dmemory.store[1]);
        //$fdisplay(file_open, "store2: %h", sc.dmemory.store[2]);
        //$fdisplay(file_open, "store3: %h", sc.dmemory.store[3]);
        //$fdisplay(file_open, "store4: %h", sc.dmemory.store[4]);
        //$fdisplay(file_open, "store5: %h", sc.dmemory.store[5]);
        //$fdisplay(file_open, "store6: %h", sc.dmemory.store[6]);
        //$fdisplay(file_open, "store7: %h", sc.dmemory.store[7]);
        //$fdisplay(file_open, "store8: %h", sc.dmemory.store[8]);
        //$fdisplay(file_open, "store9: %h", sc.dmemory.store[9]);
        //$fdisplay(file_open, "store10: %h", sc.dmemory.store[10]);
        //$fdisplay(file_open, "store11: %h", sc.dmemory.store[11]);
        //$fdisplay(file_open, "store12: %h", sc.dmemory.store[12]);
        //$fdisplay(file_open, "store13: %h", sc.dmemory.store[13]);
        //$fdisplay(file_open, "store14: %h", sc.dmemory.store[14]);
        //$fdisplay(file_open, "store15: %h", sc.dmemory.store[15]);
        //$fdisplay(file_open, "store16: %h", sc.dmemory.store[16]);
        //$fdisplay(file_open, "store17: %h", sc.dmemory.store[17]);
        //$fdisplay(file_open, "store18: %h", sc.dmemory.store[18]);
        //$fdisplay(file_open, "store19: %h", sc.dmemory.store[19]);
        //$fdisplay(file_open, "store20: %h", sc.dmemory.store[20]);
        //$fdisplay(file_open, "store21: %h", sc.dmemory.store[21]);
        //$fdisplay(file_open, "store22: %h", sc.dmemory.store[22]);
        //$fdisplay(file_open, "store23: %h", sc.dmemory.store[23]);
        //$fdisplay(file_open, "store24: %h", sc.dmemory.store[24]);
        //$fdisplay(file_open, "store25: %h", sc.dmemory.store[25]);
        //$fdisplay(file_open, "store26: %h", sc.dmemory.store[26]);
        //$fdisplay(file_open, "store27: %h", sc.dmemory.store[27]);
        //$fdisplay(file_open, "store28: %h", sc.dmemory.store[28]);
        //$fdisplay(file_open, "store29: %h", sc.dmemory.store[29]);
        //$fdisplay(file_open, "store30: %h", sc.dmemory.store[30]);
        //$fdisplay(file_open, "store31: %h", sc.dmemory.store[31]);
        //$fdisplay(file_open, "DM_ena: %h", sc.DM_ena);
        //$fdisplay(file_open, "DM_wena: %h", sc.DM_wena);
        //$fdisplay(file_open, "addr: %h", sc.dmemory.addr);
        //$fdisplay(file_open, "data_in: %h", sc.dmemory.data_in);
        //$fdisplay(file_open, "data_out: %h", sc.dmemory.data_out);
        end
        else begin
        $fclose(file_open);
        end
    end
    
    //实例化
    sccomp_dataflow sc(
        .clk_in(clk_in),
        .reset(reset),
        .inst(inst),
        .pc(pc)
    );
endmodule
