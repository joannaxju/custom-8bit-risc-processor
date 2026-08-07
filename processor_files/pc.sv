//program counter
module PC #(parameter D = 10)(
	input	logic		clk,
	input	logic 		start,
	input	logic		done,
	input	logic 		pc_inc,
	input	logic		pc_dec,
	input	logic [4:0]	off,

	output	logic [D-1:0]	pc = '0
);

always_ff @(posedge clk) begin
	//testbench loading data memory
	if(start && !done) begin
		pc <= '0;
	end
	//testbench verifying results
	else if(!start && done)
		pc <= pc;
	//program is executing
	else if(!start && !done) begin
		//logic handled in branch_jump module
		if(pc_inc)
			pc <= pc + off; 
		else if(pc_dec)
			pc <= pc - off;
		else
			pc <= pc  + 1'b1;
	end
end

endmodule
