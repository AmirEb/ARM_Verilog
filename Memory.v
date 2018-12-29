module memory(clk, address, data_in, read, write, data_out);
	input clk;
	input [63:0] address;
	input [63:0] data_in;
	input read;
	input write;
	output [63:0] data_out;

	reg [0:512] memory [0:512];
	
	assign data_out = read ? memory[address] : 64'bz;
	
	always @(posedge clk) 
		if(write == 1)
			memory[address] <= data_in;
		
	end 
endmodule
