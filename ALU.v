module ALU #(parameter n = 64) (input1, input2, operation, output1,z );
	input [n-1:0] input1;
	input [n-1:0] input2;
	input [3:0] operation;
	output reg z;
	output reg [n-1:0] output1;
	always @(input1 , input2 , operation) begin 
	assign z = output_data == 0 ? 1 : 0;
		case(operation)
			4'b0000:output1 = input1 & input2;
			4'b0001:output1 = input1 | input2;
			4'b0010:output1 = input1 + input2;
			4'b0110:output1 = input1 - input2;
			4'b0111:output1 = input2;
			4'b1100:output1 = ~(input1 | input2);
		endcase
   end

endmodule
