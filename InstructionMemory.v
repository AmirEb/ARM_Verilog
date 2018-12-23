module InstructionMemory( input_address , output_data);
	parameter delay = 60;

	input [64:0] input_address;

	output [31:0] output_data;

	reg [7:0] memory [0:255];

	assign output_data[7 : 0] = memory[input_address];
	assign output_data[15 : 8] = memory[input_address + 1];
	assign output_data[23 : 16] = memory[input_address + 2];
	assign output_data[31 : 24] = memory[input_address + 3];

endmodule
