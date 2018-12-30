module Register #(parameter n = 64) (data_input,reset,clk,data_output)
  parameter delay = 60

  input [n-1 : 0] data_input,
  input reset,
  input clk,
  output reg [n-1 : 0] data_output;

  always @(posedge clk)begin
    if (reset)
      data_output =0;
    else
      data_output = data_input;   
    end    
endmodule 
