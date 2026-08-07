//instruction rom
module IR #(parameter D = 10)(
	input	logic [D-1:0]	addr,
	output 	logic [D-2:0]	inst 
);

//2^D elements each 9 bits wide
logic [8:0] i_mem [0:(2**D)-1];
//load ins mem at start of simulation
initial begin
	//change depending on what program you are trying to run
	//$readmemb("machine_code_p1.txt", i_mem);
       	$readmemb("machine_code_p2.txt", i_mem);
       	//$readmemb("machine_code_p3.txt", i_mem);
end
//update new instruction
assign inst = i_mem[addr];

endmodule