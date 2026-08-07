//data memory
module DATA_MEM #(parameter D = 8)(
	input	logic		clk,
	input	logic [D-1:0]	addr,
	input	logic [D-1:0]	w_data,
	input	logic		w_en,
	input	logic		start,
	input	logic		done,
	output	logic [D-1:0]	r_data
);

logic [D-1:0] core[0:(2**D)-1];
assign r_data = core[addr];
always_ff @(posedge clk) begin
	if(w_en && !start && !done) begin
		core[addr] <= w_data;
	end
end

endmodule