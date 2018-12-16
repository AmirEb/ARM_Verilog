module signextend(input inp,out);
 	input [31:0] inp;
  output [63:0] out;
  assign out = 32(signed(inp));


endmodule
