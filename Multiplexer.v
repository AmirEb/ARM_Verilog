module multiplexer #(parameter n = 64) (input1,input2,select,result);
    parameter delay = 60;
    input select;
    input [n-1:0] input1;
    input [n-1:0] input2;
    output reg [n-1:0] outcome;
	assign result = select ? input2 : input1;
endmodule 
