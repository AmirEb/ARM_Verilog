module RegisterBank (clock, write,input1, input2, input3, input_data, output1, output2);
	input clock;
	input write;
	input [4 : 0] input1, input2, input3;
	input [63 : 0] input_data;
	
	output[63 : 0] output1, output2;

	reg [63 : 0] registers [0 : 31];

	assign output1 = registers[input1];
	assign output2 = registers[input2];

	always @ (posedge clock) begin
		if(write)
			registers[input3] = input_data;
	end
endmodule

