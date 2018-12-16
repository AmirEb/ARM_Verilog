module ALU(input1, input2, operation, output1 );
	input [63:0] num1;
	input [63:0] num2;
	input [3:0] operation;
	output reg z;
	output reg [63:0] output;
	always @(num1 , num2 , operation) begin 
	
		case(operation)
			4'b0000:output1 = input1 & input2;
			4'b0001:output1 = input1 | input2;
			4'b0010:output1 = input1 + input2;
			4'b0110:output1 = input1 - input2;
			4'b0111:output1 = input2;
			4'b1100:output1 = ~(input1 | input2);
		endcase
   end
    assign z = output1 ? 0 : 1;

endmodule
