//selects what to store for carry
module C_SRC_MUX(
	input logic sh_c_out,
	input logic alu_c_out,
	input logic c_sel,
	output logic C_in
);

assign C_in = (c_sel) ? sh_c_out : alu_c_out;

endmodule
