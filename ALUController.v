module ALU_Control(ALUOp, OpCode, ALUIn);
	
	input [1:0] ALUOp;
	input [10:0] OpCode;
	output reg [3:0] code;
	always @(ALUOp, OpCode) begin
		 casex(ALUOp) 
		     2'b00: code = 4'b0010;
		     2'b01: code = 4'b0111;
		     2'b10:
			casex(Op_Code)
				11'b11xxxxxxxxx: code = 4'b0110;
				11'b101xxxxxxxx: code = 4'b0001;
				11'b10001010xxx: code = 4'b0000;
				11'b10001011xxx: code = 4'b0010;
			endcase
		  endcase
	end
endmodule 
