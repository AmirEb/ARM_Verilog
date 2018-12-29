module InstructionMemory( input_address , output_data);
	parameter delay = 60;

	input [64:0] input_address;

	output [31:0] output_data;

	reg [7:0] memory [0:255];
	
	
		initial begin
		memory[0] <= 8'hE5;
		memory[1] <= 8'h03;
		memory[2] <= 8'h1F;
		memory[3] <= 8'h8B;
		
		memory[4] <= 8'hA4;
		memory[5] <= 8'h00;
		memory[6] <= 8'h40;
		memory[7] <= 8'hF8;
		
		memory[8] <= 8'h86;
		memory[9] <= 8'h00;
		memory[10] <= 8'h04;
		memory[11] <= 8'h8B;
		
		memory[12] <= 8'hA6;
		memory[13] <= 8'h10;
		memory[14] <= 8'h00;
		memory[15] <= 8'hF8;
		end

	assign output_data[7 : 0] = memory[input_address];
	assign output_data[15 : 8] = memory[input_address + 1];
	assign output_data[23 : 16] = memory[input_address + 2];
	assign output_data[31 : 24] = memory[input_address + 3];

endmodule
