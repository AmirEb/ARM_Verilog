module signextend(input inp,out);
 	input [31:0] inp;
  output [63:0] out;
  	base on type of instruction
  assign out = 32(signed(inp));


endmodule
