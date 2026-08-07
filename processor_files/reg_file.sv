//register file
module REG_FILE(
	input	logic		clk,
	input	logic		start,
	input	logic [3:0]	r1_addr,
	input	logic [3:0]	r2_addr,
	input	logic [2:0]	w_addr,
	input	logic [7:0]	w_data,
	input	logic		w_en,
	output	logic [7:0]	r1_data,
	output	logic [7:0]	r2_data
);
logic [7:0] regs [0:7];
//RL
localparam logic [7:0] RL = 8'b0000_0001;
//RM
localparam logic [7:0] RM = 8'b1000_0000;
always_comb begin
	if(r1_addr == 4'b1000) r1_data = RL;
	else if(r1_addr == 4'b1001) r1_data = RM;
        else r1_data = regs[r1_addr[2:0]];
	if(r2_addr == 4'b1000) r2_data = RL;
	else if(r2_addr == 4'b1001) r2_data = RM;
	else r2_data = regs[r2_addr[2:0]];
end
always_ff @(posedge clk) begin
	if(start) begin
		regs[0] <= 8'd0;
		regs[1] <= 8'd0;
		regs[2] <= 8'd0;
		regs[3] <= 8'd0;
		regs[4] <= 8'd0;
		regs[5] <= 8'd0;
		regs[6] <= 8'd0;
		regs[7] <= 8'd0;
	end
	else if(w_en) regs[w_addr] <= w_data;
end

endmodule