module shift(input_address, output_data);
	parameter delay = 60;
	input [63:0] input_address;
	output [63:0] output_data;
	
	assign output_data = input_address << 2;

endmodule
