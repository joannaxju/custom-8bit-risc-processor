//decides what addr goes into data memory
module DATA_SRC_MUX(
	input	logic [7:0]	r1_data,
	input	logic [7:0]	r2_data,
	input	logic		w_en,
	output	logic [7:0]	addr
);

assign addr = (w_en) ? r2_data : r1_data;

endmodule
