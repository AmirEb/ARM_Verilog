module signextend (input_address , output_data);
  
        input  [31:0] input_address;
        output reg [63:0] output_data;
        
               always@(input_address)
begin
 if (input_address[31:26]==6'b000101)  //BType      
                     begin 
                       output_data[25:0] = input_address[25:0];
                         output_data[63:26] = {38{output_data[25]}};
			 
                     end

 else if (input_address[31:24] == 8'b10110100) //CBZType
                     begin 
                      output_data[18:0] = input_address[23:5];
                      output_data[63:19] = {65{output_data[18]}};
                     end 
          
               else      //DType
                     begin  
                      output_data[8:0] = input_address[20:12];
                      output_data[63:9] = {55{output_data[8]}};
                     end
    end
endmodule
