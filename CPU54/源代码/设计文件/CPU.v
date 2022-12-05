`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.27 - 2022.7.27
//@function : 哈弗结构中CPU集成模块
module CPU(
    input clk,
    input rst,
    input ena,

    input [31:0] IM_instruction,
    input [31:0] DM_data_out,
    output [31:0] IM_addr,
    output DM_ENA,
    output DM_WENA,
    output [1:0] DM_SIZE,
    output [31:0] DM_data_in,
    output [31:0] DM_addr_in

    // for test
    /*,output [31:0] ALU_r_test,
    output [31:0] ALU_a_test,
    output [31:0] ALU_b_test,
    output ALU_Zero_test,
    output ALU_Negative_test,

    output T1,
    output T2,
    output T3,
    output T4,
    output T5,
    output Busy_Div_test,
    output Busy_Divu_test,
    output Start_Div_test,
    output Start_Divu_test,
    output mfc0_test,
    output HI_EN_test,
    output LO_EN_test,

    output [4:0] RF_rsc_test,
    output [4:0] RF_rtc_test,
    output [31:0]RF_rdata1_test,
    output [31:0]RF_rdata2_test,
    output [31:0]IR_instruction_test*/



    );


//ALU
wire [31:0]ALU_a, ALU_b, ALU_r;
wire [3:0]ALU_aluc;
wire ALU_Zero, ALU_Negative, ALU_Carry, ALU_Overflow;

//RegFiles
wire [31:0]RF_wdata, RF_rdata1, RF_rdata2;
wire [4:0]RF_waddr, RF_rsc, RF_rtc;
wire RF_we;

//CP0
wire [31:0] cp0_out, epc_out, CP0_Pc, CP0_Wdata, status;
wire mfc0, mtc0, exception, eret;
wire [4:0] cause, CP0_Addr;




//------controller------
CONTROLLER cpu_ctrl(.clk(clk),.rst(rst),.ena(ena),
                    .IM_instruction(IM_instruction),.IM_addr(IM_addr),
                    .ALU_a(ALU_a),.ALU_b(ALU_b),.ALU_r(ALU_r),.ALU_Zero(ALU_Zero),.ALU_Negative(ALU_Negative),.ALU_aluc(ALU_aluc),
                    .RF_waddr(RF_waddr),.RF_wdata(RF_wdata),.RF_rsc(RF_rsc),.RF_rtc(RF_rtc),.RF_rdata1(RF_rdata1),.RF_rdata2(RF_rdata2),.RF_we(RF_we),
                    .DM_data_out(DM_data_out),.DM_SIZE(DM_SIZE),.DM_ENA(DM_ENA),.DM_WENA(DM_WENA),.DM_data_in(DM_data_in),.DM_addr_in(DM_addr_in),
                    .cp0_out(cp0_out),.epc_out(epc_out),.CP0_Pc(CP0_Pc),.CP0_Addr(CP0_Addr),.CP0_Wdata(CP0_Wdata),
                    .mfc0(mfc0),.mtc0(mtc0),.exception(exception),.eret(eret),.cause(cause)
                    // for test
                    /*,.T1(T1),.T2(T2),.T3(T3),.T4(T4),.T5(T5),
                    .Busy_Div_test(Busy_Div_test),.Busy_Divu_test(Busy_Divu_test),
                    .Start_Div_test(Start_Div_test),.Start_Divu_test(Start_Divu_test),
                    .HI_EN_test(HI_EN_test),.LO_EN_test(LO_EN_test),
                    .IR_instruction_test(IR_instruction_test)*/

                    );


//----------ALU---------
ALU cpu_alu(.a(ALU_a),.b(ALU_b),.aluc(ALU_aluc),
            .r(ALU_r),.zero(ALU_Zero),.negative(ALU_Negative),.carry(ALU_Carry),.overflow(ALU_Overflow));


//-------RegFiles-------
REGFILES cpu_ref(.clk(clk),.we(RF_we),.rst(rst),.raddr1(RF_rsc),.raddr2(RF_rtc),.waddr(RF_waddr),.wdata(RF_wdata),
                 .rdata1(RF_rdata1),.rdata2(RF_rdata2));


//---------cp0----------
CP0 cpu_cp0(.clk(clk),.rst(rst),.mfc0(mfc0),.mtc0(mtc0),.exception(exception),.eret(eret),
            .pc(CP0_Pc),.Addr(CP0_Addr),.Wdata(CP0_Wdata),.cause(cause),
            .cp0_out(cp0_out),.epc_out(epc_out),.status(status));



// for test
/*assign ALU_r_test = ALU_r;
assign ALU_a_test = ALU_a;
assign ALU_b_test = ALU_b;
assign ALU_Zero_test = ALU_Zero;
assign ALU_Negative_test = ALU_Negative;
assign mfc0_test = mfc0;

assign RF_rdata1_test = RF_rdata1;
assign RF_rdata2_test = RF_rdata2;
assign RF_rsc_test = RF_rsc;
assign RF_rtc_test = RF_rtc;*/



endmodule
