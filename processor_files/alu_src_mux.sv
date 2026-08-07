//picks value of B from r2_data or imm
module ALU_SRC_MUX(
	input	logic [7:0]	r2_data,
	input	logic [3:0]	imm,
	input	logic		add_en,
	output	logic [7:0]	B
);

assign B = (add_en) ? {4'b0000, imm} : r2_data;

endmodule