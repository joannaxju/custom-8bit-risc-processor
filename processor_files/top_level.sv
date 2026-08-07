//top_level
module DUT(
	input  logic clk,
	input  logic start,
	output logic done
);

//instruction ROM addr
logic [9:0] pc;

//instruction machine code
logic [8:0] instruction;

//different instruction fields
logic [2:0] opcode;
logic [1:0] r1;
logic [1:0] r2;
logic [2:0] rs;
logic [2:0] rd;
logic [1:0] alu_f;
logic [1:0] sh_f;
logic b_type;
logic [4:0] off;
logic [1:0] i_type;
logic [3:0] imm;

//reg lut outputs
logic [3:0] r1_addr;
logic [3:0] r2_addr;
logic [2:0] w_addr;
//reg file outputs
logic [7:0] r1_data;
logic [7:0] r2_data;
logic [7:0] w_data;
logic [7:0] B;

//alu and shifter results
logic [7:0] alu_result;
logic [7:0] sh_result;
logic alu_c_out;
logic sh_c_out;

//flags
logic E_in;
logic L_in;
logic C_in;
logic C;
logic E;
logic L;

//control signals
logic bj_en;
logic reg_w_en;
logic data_w_en;
logic C_en;
logic EL_en;
logic add_en;
logic [1:0] reg_w_sel;
logic c_sel;

//branch and jump
logic pc_inc;
logic pc_dec;

//data mem
logic [7:0] mem_r_data;
logic [7:0] data_addr;

// opcode always [8:6]
assign opcode = instruction[8:6];

// A type
assign r1 = instruction[5:4];
assign r2 = instruction[3:2];
assign alu_f = instruction[1:0];

// B type
assign rs = instruction[5:3];
assign rd = instruction[2:0];

// C type
assign imm = instruction[3:0];

// shift funct
assign sh_f = instruction[5:4];

// branch type
assign b_type = instruction[5];

// offset
assign off = instruction[4:0];

//done condition
assign done = (!start)? (instruction == 9'b111000000) :  1'b0; 

PC PC0(
	.clk(clk),
	.start(start),
	.done(done),
	.pc_inc(pc_inc),
	.pc_dec(pc_dec),
	.off(off),
	.pc(pc)
);

IR IR0(
	.addr(pc),
	.inst(instruction)
);

REG_LUT LUT0(
	.i_type(i_type),
	.r1(r1),
	.r2(r2),
	.rs(rs),
	.rd(rd),
	.r1_out(r1_addr),
	.r2_out(r2_addr),
	.w_out(w_addr)
);

REG_FILE RF0(
	.clk(clk),
	.start(start),
	.r1_addr(r1_addr),
	.r2_addr(r2_addr),
	.w_addr(w_addr),
	.w_data(w_data),
	.w_en(reg_w_en),
	.r1_data(r1_data),
	.r2_data(r2_data)
);

REG_W_SRC_MUX REGWMUX0(
	.reg_w_sel(reg_w_sel),
	.alu_result(alu_result),
	.sh_result(sh_result),
	.r1_data(r1_data),
	.mem_r_data(mem_r_data),
	.w_data(w_data)
);

ALU ALU0(
	.A(r1_data),
	.B(B),
	.funct(alu_f),
	.c_in(C),
	.add_en(add_en),
	.result(alu_result),
	.c_out(alu_c_out)
);

ALU_SRC_MUX ALUMUX0 (
	.r2_data(r2_data),
	.imm(imm),
	.add_en(add_en),
	.B(B)
);

SHIFTER SH0(
	.value(r1_data),
	.c_in(C),
	.funct(sh_f),
	.result(sh_result),
	.c_out(sh_c_out)
);

COMPARE CMP0(
	.A(r1_data),
	.B(r2_data),
	.E(E_in),
	.L(L_in)
);

FLAGS FLAG0(
	.clk(clk),
	.start(start),
	.C_in(C_in),
	.E_in(E_in),
	.L_in(L_in),
	.C_en(C_en),
	.EL_en(EL_en),
	.C(C),
	.E(E),
	.L(L)
);

C_SRC_MUX CMUX0(
	.sh_c_out(sh_c_out),
	.alu_c_out(alu_c_out),
	.c_sel(c_sel),
	.C_in(C_in)
);

CONTROL CTRL0(
	.opcode(opcode),
	.alu_f(alu_f),
	.sh_f(sh_f),
	.b_type(b_type),
	.bj_en(bj_en),
	.reg_w_en(reg_w_en),
	.data_w_en(data_w_en),
	.C_en(C_en),
	.EL_en(EL_en),
	.i_type(i_type),
	.add_en(add_en),
	.reg_w_sel(reg_w_sel),
	.c_sel(c_sel)
);

BRANCH_JUMP BJ0(
	.bj_en(bj_en),
	.b_type(b_type),
	.C(C),
	.E(E),
	.L(L),
	.pc_inc(pc_inc),
	.pc_dec(pc_dec)
);

DATA_SRC_MUX DATAMUX0(
	.r1_data(r1_data),
	.r2_data(r2_data),
	.w_en(data_w_en),
	.addr(data_addr)
);

DATA_MEM dm(
	.clk(clk),
	.addr(data_addr),
	.w_data(r1_data),
	.w_en(data_w_en),
	.start(start),
	.done(done),
	.r_data(mem_r_data)
);

endmodule