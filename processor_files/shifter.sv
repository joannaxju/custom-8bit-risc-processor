//shifter
module SHIFTER(
	input	logic [7:0]	value,
	input	logic		c_in,
	input	logic [1:0]	funct,
	output	logic [7:0]	result,
	output	logic		c_out
);
always_comb begin
	result = value;
	c_out = 1'b0;
	case (funct)
		//shl
		2'b00: begin
			c_out = value[7];
			result = value << 1;
		end
		//rlc
		2'b01: begin
			c_out = value[7];
			result = {value[6:0], c_in};
            	end
		//shr
		2'b10: begin
			c_out = value[0];
			result = value >> 1;
		end
		//rrc
		2'b11: begin
			c_out = value[0];
			result = {c_in, value[7:1]};
		end
	endcase
end

endmodule

