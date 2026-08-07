//selects write data of reg file
module REG_W_SRC_MUX(
	input logic [1:0] reg_w_sel,
	input logic [7:0] alu_result,
	input logic [7:0] sh_result,
	input logic [7:0] r1_data,
	input logic [7:0] mem_r_data,
	output logic [7:0] w_data
);

always_comb begin
	case(reg_w_sel)
		//alu
		2'b00: w_data = alu_result;
		//mov
		2'b01: w_data = r1_data;
		//lb
		2'b10: w_data = mem_r_data;
		//shifts
		2'b11: w_data = sh_result;
	endcase
end

endmodule
