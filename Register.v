module Register (data_input,reset,clk)
  parameter delay = 60

  input [63 : 0] data_input,
  input reset,
  input clk,
  output reg [63 : 0] data_output

  always @(posedge clk)begin
    if (reset)
      data_output <= 0 {63{1'b0}};
    else
      data_output <= data_input;   
    end    
endmodule 
