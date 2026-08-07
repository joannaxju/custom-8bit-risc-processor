//look up table for register decoding
module REG_LUT(
	input	logic [1:0]	i_type,
	input	logic [1:0]	r1,
	input	logic [1:0]	r2,
	input	logic [2:0]	rs,
	input	logic [2:0]	rd,
	output	logic [3:0]	r1_out,
	output	logic [3:0]	r2_out,
	output	logic [2:0]	w_out
);
always_comb begin
	r1_out = 4'b0000;
	r2_out = 4'b0000;
	w_out = 3'b000;
	case(i_type)
		//A type
		2'b00: begin
			r1_out = {2'b00,r1};
			r2_out = {2'b00,r2};
			if(r1 == 2'b10) r1_out = 4'b1000;
			if(r1 == 2'b11) r1_out = 4'b1001;
			if(r2 == 2'b10) r2_out = 4'b1000;
			if(r2 == 2'b11) r2_out = 4'b1001;
			w_out = 3'b010;
		end
		//B type
		2'b01: begin
			r1_out = {1'b0, rs};
			r2_out = {1'b0, rd};
			w_out = rd;
		end
		//C type
		2'b10: begin
			r1_out = {2'b00,r1};
			w_out = {2'b0,r1};
		end
		//D type
		2'b11: begin
			r1_out = {1'b0, rd};
			w_out = rd;
		end
	endcase
end

endmodule