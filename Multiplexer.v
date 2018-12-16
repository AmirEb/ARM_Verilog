module multiplexer(input1,input2,select,result);
    parameter delay = 60
    input select;
    input [63:0] input1;
    input [63:0] input2;
    output reg [63:0] outcome;
    always @(input1,input2,select)
    begin
    if(select)
        outcome=input2;
    else
        outcome=input1;
    end    
endmodule 
