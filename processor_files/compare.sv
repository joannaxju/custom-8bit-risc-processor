//compare
module COMPARE(
	input	logic [7:0]	A,
	input	logic [7:0]	B,
	output	logic		E,
	output	logic		L
);
always_comb begin
	E =(A == B);
	L = (A < B);

end

endmodule