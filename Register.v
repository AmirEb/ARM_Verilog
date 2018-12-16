
module Register (data_input,reset,clk)

  parameter n = 64
  input [n-1 : 0] data_input,
  input reset,
  input clk,
  output reg [n-1 : 0] data_output

  always @(posedge clk)begin
    if (reset)
      data_output <= {n{1'b0}};
    else
      data_output <= data_input;   
    end    
endmodule 
