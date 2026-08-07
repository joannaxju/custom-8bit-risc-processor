//flags E C L
module FLAGS (
	input	logic	clk,
	input	logic	start,
	input	logic	C_in,
	input	logic	E_in,
	input	logic	L_in,
	input	logic	C_en,
	input	logic	EL_en,
	output	logic	C,
	output	logic	E,
	output	logic	L
);
always_ff @(posedge clk) begin
	if(start) begin
		C <= 1'b0;
		E <= 1'b0;
		L <= 1'b0;
	end
	else begin
		if (C_en)
			C <= C_in;
		if (EL_en) begin
			E <= E_in;
			L <= L_in;
		end
	end
end

endmodule