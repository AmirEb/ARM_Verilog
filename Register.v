
module Register

  parameter n = 64
  input [n-1 : 0] D,
  input rst,
  input clk,
  output reg [n-1 : 0] Q

  always @(posedge clk)begin
    if (reset)
      Q <= {n{1'b0}};
    else
      Q <= D;   
    end    
endmodule 
