//control unit
module CONTROL(
	input	logic [2:0]	opcode,
	input	logic [1:0]	alu_f,
	input	logic [1:0]	sh_f,
	input	logic 		b_type,
	output	logic 		bj_en,
	output	logic		reg_w_en,
	output	logic		data_w_en,
	output	logic		C_en,
	output	logic		EL_en,
	output	logic [1:0]	i_type,
	output	logic		add_en,
	output	logic [1:0]	reg_w_sel,
	output	logic		c_sel
);
always_comb begin
	bj_en = 1'b0;
	reg_w_en = 1'b0;
	data_w_en = 1'b0;
	C_en = 1'b0;
	EL_en = 1'b0;
	add_en = 1'b0;
	i_type = 2'b00;
	reg_w_sel = 2'b00;
	c_sel = 1'b0;
	case(opcode)
		//ALU
		3'b000: begin
			reg_w_en = 1'b1;
			reg_w_sel = 2'b00;
			c_sel = 1'b0;
			case(alu_f)
				//add
				2'b10: C_en = 1'b1;
				//adc
				2'b11: C_en = 1'b1;
			endcase
		end
		//mov
		3'b001: begin
			reg_w_en = 1'b1;
			reg_w_sel = 2'b01;
		end
		//lb
		3'b010: begin
			reg_w_en = 1'b1;
			reg_w_sel = 2'b10;
		end
		//sb
		3'b011: begin
			data_w_en = 1'b1;
		end
		//cmp
		3'b100: begin
			EL_en = 1'b1;
		end
		//addi
		3'b101: begin
			reg_w_en = 1'b1;
			C_en = 1'b1;
			add_en = 1'b1;
			reg_w_sel = 2'b00;
			c_sel = 1'b0;
		end
		//shifts
		3'b110: begin
			reg_w_en = 1'b1;
			C_en = 1'b1;
			reg_w_sel= 2'b11;
			c_sel = 1'b1;
		end
		//branches/jumps
		3'b111: begin
			bj_en = 1'b1;
		end
	endcase
	case(opcode)
		//A
		3'b000: i_type = 2'b00;
		//B
		3'b001: i_type = 2'b01;
		3'b010: i_type = 2'b01;
		3'b011: i_type = 2'b01;
		3'b100: i_type = 2'b01;
		//C
		3'b101: i_type = 2'b10;
		//D
		3'b110: i_type = 2'b11;
	endcase
end

endmodule