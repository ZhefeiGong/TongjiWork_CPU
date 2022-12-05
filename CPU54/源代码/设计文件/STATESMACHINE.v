`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.26 - 2022.7.29
//@function : 实现多周期CPU中状态机
module STATESMACHINE(
    input clk,      // 上升沿有效
    input RESET,    // 上升沿有效
    
    // 信号输入
    input [53:0]OP, // 54条指令独热码
    input ALU_Zero,
    input ALU_Negative,
    input Busy_Div,
    input Busy_Divu,

    // 控制信号输出
    output reg PC_EN,
    output reg IR_EN,
    output reg Z_EN,
    output reg NPC_EN,
    output reg HI_EN,
    output reg LO_EN,

    output reg LbEn,
    output reg LhEn,
    output reg LbuEn,
    output reg LhuEn,

    output reg Start_Div,
    output reg Start_Divu,
    output reg Start_MUL,
    output reg Start_MULTU,

    output reg[1:0] MUX1_ORDER,
    output reg[2:0] MUX2_ORDER,
    output reg[2:0] MUX4_ORDER,
    output reg[2:0] MUX5_ORDER,
    output reg[1:0] MUX6_ORDER,
    output reg[2:0] MUX7_ORDER,
    output reg[2:0] MUX8_ORDER,
    
    output reg[3:0] ALU_aluc,

    output reg[1:0] DM_SIZE,
    output reg DM_WENA,
    output reg RF_we,

    output reg mfc0,
    output reg mtc0,
    output reg exception,
    output reg eret,
    output reg[4:0] cause

    // for test
    /*,output T1,
    output T2,
    output T3,
    output T4,
    output T5*/

    );

// initiate
parameter [2:0]STATE_INIT=3'b000,STATE_T1=3'b001,STATE_T2=3'b010,STATE_T3=3'b011,STATE_T4=3'b100,STATE_T5=3'b101;
reg [2:0] CURSTATE;
reg [2:0] NEXRSTATE;

wire cpu_ADDI = OP[53];
wire cpu_ADDIU = OP[52];
wire cpu_ANDI = OP[51]; 
wire cpu_ORI = OP[50]; 
wire cpu_XORI = OP[49]; 
wire cpu_LUI = OP[48];

wire cpu_ADD = OP[47];
wire cpu_ADDU = OP[46];
wire cpu_SUB = OP[45];
wire cpu_SUBU = OP[44];
wire cpu_AND = OP[43];
wire cpu_OR = OP[42];
wire cpu_XOR = OP[41];
wire cpu_NOR = OP[40];

wire cpu_SLT = OP[39];
wire cpu_SLTU = OP[38];
wire cpu_SLTI = OP[37];
wire cpu_SLTIU = OP[36];

wire cpu_SLL = OP[35];
wire cpu_SRL = OP[34];
wire cpu_SRA = OP[33];
wire cpu_SLLV = OP[32];
wire cpu_SRLV = OP[31];
wire cpu_SRAV = OP[30];

wire cpu_LW = OP[29];
wire cpu_SW = OP[28];

wire cpu_BEQ = OP[27];
wire cpu_BNE = OP[26];
wire cpu_J = OP[25];
wire cpu_JR = OP[24];
wire cpu_JAL = OP[23];

wire cpu_CLZ = OP[22];
wire cpu_BGEZ = OP[21];
wire cpu_JALR = OP[20];
wire cpu_MFC0 = OP[19];
wire cpu_MTC0 = OP[18];

wire cpu_MFHI = OP[17];
wire cpu_MFLO = OP[16];
wire cpu_MTHI = OP[15];
wire cpu_MTLO = OP[14];

wire cpu_LBU = OP[13];
wire cpu_LHU = OP[12];
wire cpu_LB = OP[11];
wire cpu_LH = OP[10];
wire cpu_SB = OP[9];
wire cpu_SH = OP[8];

wire cpu_BREAK = OP[7];
wire cpu_SYSCALL = OP[6];
wire cpu_ERET = OP[5];
wire cpu_TEQ = OP[4];

wire cpu_DIV = OP[3];
wire cpu_DIVU = OP[2];
wire cpu_MUL = OP[1];
wire cpu_MULTU = OP[0];

wire OPT3 = cpu_JAL||cpu_MFC0||cpu_MTC0||cpu_MFHI||cpu_MTHI||cpu_MFLO||cpu_MTLO||cpu_BREAK||cpu_SYSCALL;
wire OPT4 = cpu_ADDI||cpu_ADDIU||cpu_ANDI||cpu_ORI||cpu_XORI||cpu_LUI||
            cpu_ADD||cpu_ADDU||cpu_SUB||cpu_SUBU||cpu_AND||cpu_OR||cpu_XOR||cpu_NOR||
            cpu_SLT||cpu_SLTU||cpu_SLTI||cpu_SLTIU||
            cpu_SLL||cpu_SRL||cpu_SRA||cpu_SLLV||cpu_SRLV||cpu_SRAV||
            cpu_SW||cpu_LW||cpu_LBU||cpu_LHU||cpu_LB||cpu_LH||cpu_SB||cpu_SH||
            cpu_CLZ||cpu_JALR||cpu_MUL||cpu_MULTU;
wire COMMON_CAL = cpu_ADDI||cpu_ADDIU||cpu_ANDI||cpu_ORI||cpu_XORI||cpu_LUI||
                  cpu_ADD||cpu_ADDU||cpu_SUB||cpu_SUBU||cpu_AND||cpu_OR||cpu_XOR||cpu_NOR||
                  cpu_SLT||cpu_SLTU||cpu_SLTI||cpu_SLTIU||
                  cpu_SLL||cpu_SRL||cpu_SRA||cpu_SLLV||cpu_SRLV||cpu_SRAV;

// 现态
always@(posedge clk or posedge RESET)begin
    if(RESET)begin
        CURSTATE<=STATE_INIT;
    end
    else begin
        CURSTATE<=NEXRSTATE;
    end
end

// 次态
always@(*)begin
    case (CURSTATE)
        //T_initial
        STATE_INIT:begin
            NEXRSTATE<=STATE_T1;
        end
        //T1
        STATE_T1:begin
            NEXRSTATE<=STATE_T2;
        end
        //T2
        STATE_T2:begin
            if(cpu_ERET||cpu_J||cpu_JR)
                NEXRSTATE<=STATE_T1;
            else
                NEXRSTATE<=STATE_T3;
        end
        //T3
        STATE_T3:begin
            if(cpu_BEQ==1)                               // beq
                if(ALU_Zero==1)
                    NEXRSTATE<=STATE_T4;
                else
                    NEXRSTATE<=STATE_T1;
            else if(cpu_BNE==1)                          // bne
                if(ALU_Zero==0)
                    NEXRSTATE<=STATE_T4;
                else
                    NEXRSTATE<=STATE_T1;
            else if(cpu_BGEZ==1)                         // BGEZ
                if((ALU_Zero==1||ALU_Negative==0))
                    NEXRSTATE<=STATE_T4;
                else
                    NEXRSTATE<=STATE_T1;
            else if(cpu_TEQ==1)                          // teq
                if(ALU_Zero==1)
                    NEXRSTATE<=STATE_T4;
                else
                    NEXRSTATE<=STATE_T1;
            else if(OPT3==1)                             // 三周期指令
                NEXRSTATE<=STATE_T1;
            else if(Busy_Div==1||Busy_Divu==1)           // Div & Divu
                NEXRSTATE<=STATE_T3;
            else                                         // ERROR STATE
                NEXRSTATE<=STATE_T4;
        end
        //T4
        STATE_T4:begin
            if (OPT4==1)
                NEXRSTATE<=STATE_T1;
            else 
                NEXRSTATE<=STATE_T5;
        end
        //T5
        STATE_T5:begin
            NEXRSTATE<=STATE_T1;
        end
        //ERROR STATE
        default:begin
            NEXRSTATE<=STATE_T1;
        end
    endcase
end   

// 控制信号（组合逻辑）
always@(*)begin
    case (CURSTATE)
//--------------------------------T1--------------------------------
    STATE_T1:begin
        PC_EN <= 1'b0;
        IR_EN <= 1'b1;  //IR更新
        Z_EN <= 1'b0;
        NPC_EN <= 1'b1; //NPC更新
        HI_EN <= 1'b0;
        LO_EN <= 1'b0;

        LbEn <= 1'b0;
        LhEn <= 1'b0;
        LbuEn <= 1'b0;
        LhuEn <= 1'b0;

        Start_Div <= 1'b0;
        Start_Divu <= 1'b0;
        Start_MUL <= 1'b0;
        Start_MULTU <= 1'b0;

        MUX1_ORDER <= 2'b00;
        MUX2_ORDER <= 3'b100; //PC+4
        MUX4_ORDER <= 3'b000;
        MUX5_ORDER <= 3'b000;
        MUX6_ORDER <= 2'b00;
        MUX7_ORDER <= 3'b000;
        MUX8_ORDER <= 3'b000;
    
        ALU_aluc <= 4'b0010; //PC+4

        DM_SIZE <= 2'b0;
        DM_WENA <= 1'b0;
        RF_we <= 1'b0;

        mfc0 <= 1'b0;
        mtc0 <= 1'b0;
        exception <= 1'b0;
        eret <= 1'b0;
        cause <= 5'b00000;

    end
//--------------------------------T2--------------------------------
    STATE_T2:begin

        // PC_EN
        if(cpu_J||cpu_JR||cpu_ERET)
            PC_EN <=1'b1;
        else
            PC_EN <= 1'b0;

        IR_EN <= 1'b0;
        
        // Z_EN
        if(COMMON_CAL||
           cpu_CLZ||cpu_BGEZ||cpu_TEQ||
           cpu_LBU||cpu_LHU||cpu_LB||cpu_LH||cpu_SB||cpu_SH||
           cpu_LW||cpu_SW)
            Z_EN <= 1'b1;
        else
            Z_EN <=1'b0;
        
        NPC_EN <= 1'b0;

        // HI_EN
        if(cpu_MTHI)
            HI_EN <= 1'b1;
        else
            HI_EN <= 1'b0;
        
        // LO_EN
        if(cpu_MTLO)
            LO_EN <= 1'b1;
        else
            LO_EN <= 1'b0;
            
        LbEn <= 1'b0;
        LhEn <= 1'b0;
        LbuEn <= 1'b0;
        LhuEn <= 1'b0;
        
        // DIV & DIVU & MUL & MULTU EN
        if(cpu_DIV)// Start_Div
            Start_Div <= 1'b1;
        else
            Start_Div <= 1'b0;
        if(cpu_DIVU)// Start_Divu
            Start_Divu <= 1'b1;
        else
            Start_Divu <= 1'b0;
        if(cpu_MUL)// Start_MUL
            Start_MUL <= 1'b1;
        else
            Start_MUL <= 1'b0;
        if(cpu_MULTU)// Start_Divu
            Start_MULTU <= 1'b1;
        else
            Start_MULTU <= 1'b0;
        
        // MUX1_ORDER
        if(cpu_ADDI||cpu_ADDIU||cpu_ANDI||cpu_ORI||cpu_XORI||
           cpu_ADD||cpu_ADDU||cpu_SUB||cpu_SUBU||cpu_AND||cpu_OR||cpu_XOR||cpu_NOR||
           cpu_SLT||cpu_SLTU||cpu_SLTI||cpu_SLTIU||
           cpu_SLLV||cpu_SRLV||cpu_SRAV||
           cpu_LW||cpu_SW||
           cpu_BEQ||cpu_BNE||
           cpu_CLZ||cpu_BGEZ||
           cpu_LBU||cpu_LB||cpu_LHU||cpu_LH||
           cpu_SB||cpu_SH||
           cpu_TEQ)
            MUX1_ORDER <= 2'b01; //rs
        else if(cpu_SLL||cpu_SRL||cpu_SRA)
            MUX1_ORDER <= 2'b10; //sa
        else
            MUX1_ORDER <= 2'b00; //pc
        
        // MUX2_ORDER
        if(cpu_ADDI||cpu_ADDIU||
           cpu_SLTI||
           cpu_LW||cpu_SW||
           cpu_LBU||cpu_LB||cpu_LHU||cpu_LH||
           cpu_SB||cpu_SH)
            MUX2_ORDER <= 3'b001; //signed imm16
        else if(cpu_ANDI||cpu_ORI||cpu_XORI||cpu_LUI||cpu_SLTIU)
            MUX2_ORDER <= 3'b010; //unsigned imm16
        else if(cpu_ADD||cpu_ADDU||cpu_SUB||cpu_SUBU||cpu_AND||cpu_OR||cpu_XOR||cpu_NOR||
                cpu_SLT||cpu_SLTU||
                cpu_SLL||cpu_SRL||cpu_SRA||cpu_SLLV||cpu_SRLV||cpu_SRAV||
                cpu_BEQ||cpu_BNE||
                cpu_TEQ)
            MUX2_ORDER <= 3'b000; //rt
        else if(cpu_BGEZ)
            MUX2_ORDER <= 3'b101; //0
        else
            MUX2_ORDER <= 3'b000;
        
        // MUX4
        if(cpu_JAL||cpu_JALR)
            MUX4_ORDER <= 3'b110; // NPC
        else if(cpu_MFC0)
            MUX4_ORDER <= 3'b011; // cp0_out
        else if(cpu_MFHI)
            MUX4_ORDER <= 3'b010;
        else if(cpu_MFLO)
            MUX4_ORDER <= 3'b001;
        else
            MUX4_ORDER <= 3'b000;

        // MUX5
        if(cpu_J)
            MUX5_ORDER <= 3'b010; // joint
        else if(cpu_JR)
            MUX5_ORDER <= 3'b001; // rs
        else if(cpu_ERET)
            MUX5_ORDER <= 3'b000; // epc_out
        else
            MUX5_ORDER <= 3'b000;

        // MUX6
        if(cpu_JAL)
            MUX6_ORDER <= 2'b00; //register $31
        else if(cpu_JALR||cpu_MFHI||cpu_MFLO)
            MUX6_ORDER <= 2'b10; //register $rd
        else if(cpu_MFC0)
            MUX6_ORDER <= 2'b01; //register $rt
        else
            MUX6_ORDER <= 2'b00;

        // MUX7
        if(cpu_MTHI)
            MUX7_ORDER <= 3'b100;
        else
            MUX7_ORDER <= 3'b000;

        // MUX8
        if(cpu_MTLO)
            MUX8_ORDER <= 3'b100;
        else
            MUX8_ORDER <= 3'b000;
    
        // ALU_aluc
        if(cpu_ADDI||cpu_ADD||
           cpu_LW||cpu_SW||
           cpu_LBU||cpu_LB||cpu_LHU||cpu_LH||
           cpu_SB||cpu_SH)
            ALU_aluc <= 4'b0010;
        else if(cpu_ADDIU||cpu_ADDU)
            ALU_aluc <= 4'b0000;
        else if(cpu_ANDI||cpu_AND)
            ALU_aluc <= 4'b0100;
        else if(cpu_ORI||cpu_OR)
            ALU_aluc <= 4'b0101;
        else if(cpu_XORI||cpu_XOR)
            ALU_aluc <= 4'b0110;
        else if(cpu_LUI)
            ALU_aluc <= 4'b1000;
        else if(cpu_SUB||
                cpu_BEQ||cpu_BNE||
                cpu_BGEZ||cpu_TEQ)
            ALU_aluc <= 4'b0011;
        else if(cpu_SUBU)
            ALU_aluc <= 4'b0001;
        else if(cpu_NOR)
            ALU_aluc <= 4'b0111;
        else if(cpu_SLT||cpu_SLTI)
            ALU_aluc <= 4'b1011;
        else if(cpu_SLTU||cpu_SLTIU)
            ALU_aluc <= 4'b1010;
        else if(cpu_SLL||cpu_SLLV)
            ALU_aluc <= 4'b1110;
        else if(cpu_SRL||cpu_SRLV)
            ALU_aluc <= 4'b1101;
        else if(cpu_SRA||cpu_SRAV)
            ALU_aluc <= 4'b1100;
        else if(cpu_CLZ)
            ALU_aluc <= 4'b1001;
        else 
            ALU_aluc <= 4'b0000;
        
        DM_SIZE <= 2'b0;
        DM_WENA <= 1'b0;

        // RF_we
        if(cpu_JAL||cpu_JALR||cpu_MFC0||cpu_MFHI||cpu_MFLO)
            RF_we <= 1'b1; // 写入RegFiles中
        else 
            RF_we <= 1'b0;
        
        // mfc0
        if(cpu_MFC0)
            mfc0 <= 1'b1;
        else
            mfc0 <= 1'b0;
        
        // mtc0
        if(cpu_MTC0)
            mtc0 <= 1'b1;
        else
            mtc0 <= 1'b0;

        // exception
        if(cpu_BREAK||cpu_SYSCALL)
            exception <= 1'b1;
        else
            exception <= 1'b0;
        
        // eret
        if(cpu_ERET)
            eret <= 1'b1;
        else
            eret <= 1'b0;

        // cause
        if(cpu_BREAK)
            cause <= 5'b01001;
        else if(cpu_SYSCALL)
            cause <= 5'b01000;
        else
            cause <= 5'b00000;

    end
//--------------------------------T3--------------------------------
    STATE_T3:begin

        // PC_EN
        if(cpu_BEQ==1'b1&&ALU_Zero==1'b0)
            PC_EN <=1'b1;
        else if(cpu_BNE==1'b1&&ALU_Zero==1'b1)
            PC_EN <= 1'b1;
        else if(cpu_BGEZ==1'b1&&(ALU_Zero==1'b0&&ALU_Negative==1'b1))
            PC_EN <= 1'b1;
        else if(cpu_TEQ==1'b1&&ALU_Zero==1'b0)
            PC_EN <= 1'b1;
        else if(cpu_JAL||cpu_JALR||
                cpu_MFC0||cpu_MTC0||cpu_MFHI||cpu_MTHI||cpu_MFLO||cpu_MTLO||
                cpu_BREAK||cpu_SYSCALL)
            PC_EN <= 1'b1;
        else
            PC_EN <= 1'b0;
        

        IR_EN <= 1'b0;
        Z_EN <= 1'b0;
        NPC_EN <= 1'b0;

        // HI_EN
        if(cpu_MUL||cpu_MULTU)
            HI_EN <= 1'b1;
        else
            HI_EN <= 1'b0;
        // LO_EN
        if(cpu_MUL||cpu_MULTU)
            LO_EN <= 1'b1;
        else
            LO_EN <= 1'b0;
        
        // CONV
        if(cpu_LB) //LbEn
            LbEn <= 1'b1;
        else
            LbEn <= 1'b0;
        if(cpu_LH) //LhEn
            LhEn <= 1'b1;
        else
            LhEn <= 1'b0;
        if(cpu_LBU) //LbuEn
            LbuEn <= 1'b1;
        else
            LbuEn <= 1'b0;
        if(cpu_LHU) //LhuEn
            LhuEn <= 1'b1;
        else
            LhuEn <= 1'b0;

        Start_Div <= 1'b0;
        Start_Divu <= 1'b0;
        Start_MUL <= 1'b0;
        Start_MULTU <= 1'b0;

        MUX1_ORDER <= 2'b00;  //PC
        MUX2_ORDER <= 3'b000; //rt
   
        // MUX4
        if(COMMON_CAL||cpu_CLZ)
            MUX4_ORDER <= 3'b101; //Z
        else if(cpu_LW||cpu_LB||cpu_LBU||cpu_LH||cpu_LHU)
            MUX4_ORDER <= 3'b100; //CONV
        else if(cpu_MUL)
            MUX4_ORDER <= 3'b000; //MUL_Z[31:0]
        else
            MUX4_ORDER <= 3'b000;
        
        // MUX5
        if(cpu_BEQ==1'b1&&ALU_Zero==1'b0)
            MUX5_ORDER <= 3'b101; //NPC-->BEQ
        else if(cpu_BNE==1'b1&&ALU_Zero==1'b1)
            MUX5_ORDER <= 3'b101; //NPC-->BNE
        else if(cpu_BGEZ==1'b1&&(ALU_Zero==1'b0&&ALU_Negative==1'b1))
            MUX5_ORDER <= 3'b101; //NPC-->BGEZ
        else if(cpu_TEQ==1'b1&&ALU_Zero==1'b0)
            MUX5_ORDER <= 3'b101; //NPC-->TEQ
        else if(cpu_MFC0||cpu_MTC0||cpu_MFHI||cpu_MTHI||cpu_MFLO||cpu_MTLO)
            MUX5_ORDER <= 3'b101; //NPC
        else if(cpu_JAL)
            MUX5_ORDER <= 3'b010; //joint
        else if(cpu_JALR)
            MUX5_ORDER <= 3'b001; //rs
        else if(cpu_BREAK||cpu_SYSCALL)
            MUX5_ORDER <= 3'b100; //04
        else
            MUX5_ORDER <= 3'b000; 

        // MUX6
        if(cpu_ADDI||cpu_ADDIU||cpu_ANDI||cpu_ORI||cpu_XORI||cpu_LUI||
           cpu_SLTI||cpu_SLTIU||
           cpu_LW||cpu_LB||cpu_LBU||cpu_LH||cpu_LHU)
            MUX6_ORDER <= 2'b01; //rt
        else if(cpu_ADD||cpu_ADDU||cpu_SUB||cpu_SUBU||cpu_AND||cpu_OR||cpu_XOR||cpu_NOR||
                cpu_SLT||cpu_SLTU||
                cpu_SLL||cpu_SRL||cpu_SRA||cpu_SLLV||cpu_SRLV||cpu_SRAV||
                cpu_CLZ||
                cpu_MUL)
            MUX6_ORDER <=2'b10; //rd
        else
            MUX6_ORDER <= 2'b00;

        // MUX7
        if(cpu_MUL)
            MUX7_ORDER <= 3'b010;
        else if(cpu_MULTU)
            MUX7_ORDER <= 3'b011;
        else
            MUX7_ORDER <= 3'b000;

        // MUX8
        if(cpu_MUL)
            MUX8_ORDER <= 3'b010;
        else if(cpu_MULTU)
            MUX8_ORDER <= 3'b011;
        else
            MUX8_ORDER <= 3'b000;
        
        // ALU_aluc
        ALU_aluc <= 4'b0000;

        // DM_SIZE
        if(cpu_SW||cpu_LW)
            DM_SIZE <= 2'b00;
        else if(cpu_SH||cpu_LH||cpu_LHU)
            DM_SIZE <= 2'b01;
        else if(cpu_SB||cpu_LB||cpu_LBU)
            DM_SIZE <= 2'b10;
        else
            DM_SIZE <= 2'b00;

        // DM_WENA
        if(cpu_SW||cpu_SB||cpu_SH)
            DM_WENA <= 1'b1;
        else
            DM_WENA <= 1'b0;

        // RF_we
        if(COMMON_CAL||
           cpu_LW||cpu_LB||cpu_LBU||cpu_LH||cpu_LHU||
           cpu_CLZ||
           cpu_MUL)
            RF_we <= 1'b1;
        else
            RF_we <= 1'b0;

        mfc0 <= 1'b0;
        mtc0 <= 1'b0;
        exception <= 1'b0;
        eret <= 1'b0;
        cause <= 5'b00000;

    
    end
//--------------------------------T4--------------------------------
    STATE_T4:begin

        // PC_EN
        if(COMMON_CAL||
           cpu_LW||cpu_SW||cpu_CLZ||
           cpu_LB||cpu_LBU||cpu_LH||cpu_LHU||cpu_SB||cpu_SH||
           cpu_MUL||cpu_MULTU)
            PC_EN <= 1'b1;
        else
            PC_EN <= 1'b0;

        IR_EN <= 1'b0;

        // Z_EN
        if(cpu_BEQ||cpu_BNE||cpu_BGEZ)
            Z_EN <= 1'b1;
        else
            Z_EN <= 1'b0;
        
        NPC_EN <= 1'b0;

        // HI_EN
        if(cpu_DIV||cpu_DIVU)
            HI_EN <= 1'b1;
        else
            HI_EN <= 1'b0;
        // LO_EN
        if(cpu_DIV||cpu_DIVU)
            LO_EN <= 1'b1;
        else
            LO_EN <= 1'b0;

        LbEn <= 1'b0;
        LhEn <= 1'b0;
        LbuEn <= 1'b0;
        LhuEn <= 1'b0;

        Start_Div <= 1'b0;
        Start_Divu <= 1'b0;
        Start_MUL <= 1'b0;
        Start_MULTU <= 1'b0;

        // MUX1
        if(cpu_BEQ||cpu_BNE||cpu_BGEZ)
            MUX1_ORDER <= 2'b00; //PC
        else
            MUX1_ORDER <= 2'b00;
        
        // MUX2
        if(cpu_BEQ||cpu_BNE||cpu_BGEZ)
            MUX2_ORDER <= 3'b011; //Ext18
        else
            MUX2_ORDER <= 3'b000;
        
        MUX4_ORDER <= 3'b000;

        // MUX5
        if(COMMON_CAL||cpu_LW||cpu_SW||cpu_CLZ||
           cpu_LB||cpu_LBU||cpu_LH||cpu_LHU||cpu_SB||cpu_SH||
           cpu_MUL||cpu_MULTU)
            MUX5_ORDER <= 3'b101; // NPC
        else
            MUX5_ORDER <= 3'b000;

        MUX6_ORDER <= 2'b00;

        // MUX7
        if(cpu_DIV)
            MUX7_ORDER <= 3'b000;
        else if(cpu_DIVU)
            MUX7_ORDER <= 3'b001;
        else
            MUX7_ORDER <= 3'b000;

        // MUX8
        if(cpu_DIV)
            MUX8_ORDER <= 3'b000;
        else if(cpu_DIVU)
            MUX8_ORDER <= 3'b001;
        else
            MUX8_ORDER <= 3'b000;

        // ALU_aluc
        if(cpu_BEQ||cpu_BNE||cpu_BGEZ)
            ALU_aluc <= 4'b0010;
        else
            ALU_aluc <= 4'b0000;

        DM_SIZE <= 2'b0;
        DM_WENA <= 1'b0;
        RF_we <= 1'b0;

        mfc0 <= 1'b0;
        mtc0 <= 1'b0;

        // exception
        if(cpu_TEQ)
            exception <= 1'b1;
        else
            exception <= 1'b0;
        
        eret <= 1'b0;

        // cause
        if(cpu_TEQ)
            cause <= 5'b01101;
        else
            cause <= 5'b00000;
    
    end
//--------------------------------T5--------------------------------
    STATE_T5:begin

        // PC_EN
        if(cpu_BEQ||cpu_BNE||cpu_BGEZ||cpu_TEQ||cpu_DIV||cpu_DIVU)
            PC_EN <= 1'b1;
        else
            PC_EN <= 1'b0;
        
        IR_EN <= 1'b0;
        Z_EN <= 1'b0;
        NPC_EN <= 1'b0;
        HI_EN <= 1'b0;
        LO_EN <= 1'b0;

        LbEn <= 1'b0;
        LhEn <= 1'b0;
        LbuEn <= 1'b0;
        LhuEn <= 1'b0;

        Start_Div <= 1'b0;
        Start_Divu <= 1'b0;
        Start_MUL <= 1'b0;
        Start_MULTU <= 1'b0;

        MUX1_ORDER <= 2'b00;
        MUX2_ORDER <= 3'b000;
        MUX4_ORDER <= 3'b000;

        // MUX5
        if(cpu_BEQ||cpu_BNE||cpu_BGEZ)
            MUX5_ORDER <= 3'b011; //Z
        else if(cpu_TEQ)
            MUX5_ORDER <= 3'b100; //04
        else if(cpu_DIV||cpu_DIVU)
            MUX5_ORDER <= 3'b101; //NPC
        else
            MUX5_ORDER <= 3'b000;
        
        MUX6_ORDER <= 2'b00;
        MUX7_ORDER <= 3'b000;
        MUX8_ORDER <= 3'b000;
    
        ALU_aluc <= 4'b0000;

        DM_SIZE <= 2'b0;
        DM_WENA <= 1'b0;
        RF_we <= 1'b0;

        mfc0 <= 1'b0;
        mtc0 <= 1'b0;
        exception <= 1'b0;
        eret <= 1'b0;
        cause <= 5'b00000;
    
    end
//--------------------------other conditions-------------------------
    default:begin
        PC_EN <= 1'b0;
        IR_EN <= 1'b0;
        Z_EN <= 1'b0;
        NPC_EN <= 1'b0;
        HI_EN <= 1'b0;
        LO_EN <= 1'b0;

        LbEn <= 1'b0;
        LhEn <= 1'b0;
        LbuEn <= 1'b0;
        LhuEn <= 1'b0;

        Start_Div <= 1'b0;
        Start_Divu <= 1'b0;
        Start_MUL <= 1'b0;
        Start_MULTU <= 1'b0;

        MUX1_ORDER <= 2'b00;
        MUX2_ORDER <= 3'b000;
        MUX4_ORDER <= 3'b000;
        MUX5_ORDER <= 3'b000;
        MUX6_ORDER <= 2'b00;
        MUX7_ORDER <= 3'b000;
        MUX8_ORDER <= 3'b000;
    
        ALU_aluc <= 4'b0000;

        DM_SIZE <= 2'b0;
        DM_WENA <= 1'b0;
        RF_we <= 1'b0;

        mfc0 <= 1'b0;
        mtc0 <= 1'b0;
        exception <= 1'b0;
        eret <= 1'b0;
        cause <= 5'b00000;
    end
    endcase
end


// for test
/*assign T1 = (CURSTATE==STATE_T1)?1'b1:1'b0;
assign T2 = (CURSTATE==STATE_T2)?1'b1:1'b0;
assign T3 = (CURSTATE==STATE_T3)?1'b1:1'b0;
assign T4 = (CURSTATE==STATE_T4)?1'b1:1'b0;
assign T5 = (CURSTATE==STATE_T5)?1'b1:1'b0;*/


endmodule
