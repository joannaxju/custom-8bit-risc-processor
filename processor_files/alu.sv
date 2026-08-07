//alu
module ALU(
	input	logic [7:0] A,
	input	logic [7:0] B,
	input	logic [1:0] funct,
	input	logic       c_in,
	input	logic	    add_en,
	output	logic [7:0] result,
	output	logic       c_out
);
logic [8:0] sum;
always_comb begin
	result = 8'd0;
	c_out = 1'b0;
	sum = 9'd0;
	if(add_en) begin
		sum = {1'b0, A} + {1'b0, B};
                result = sum[7:0];
               	c_out = sum[8];
	end
	else begin
        	case(funct)
			//and
			2'b00: result = A & B;
			//xor
			2'b01: result = A ^ B;
			//add
			2'b10: begin
                		sum = {1'b0, A} + {1'b0, B};
                		result = sum[7:0];
                		c_out = sum[8];
			end	
			//adc
			2'b11: begin
                		sum = {1'b0, A} + {1'b0, B} + c_in;
				result = sum[7:0];
				c_out = sum[8];
			end
		endcase
	end
end

endmodule
