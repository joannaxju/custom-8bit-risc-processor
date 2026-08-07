//branch and jump
module BRANCH_JUMP(
	input	logic		bj_en,
	input	logic		b_type,
	input	logic		C,
	input	logic		E,
	input	logic		L,
	output	logic		pc_inc,
	output	logic		pc_dec
);
always_comb begin
	pc_inc = 1'b0;
	pc_dec = 1'b0;
	if(bj_en) begin
		case (b_type)
			//ju
			1'b0: pc_dec = 1'b1;
			//bge
			1'b1: if (!L) pc_inc = 1'b1;
		endcase
	end
end

endmodule