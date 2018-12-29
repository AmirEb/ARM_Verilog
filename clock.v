module clock(clk);
	output reg clk;
		initial begin
		clk = 1;
	end
	always begin
		#100 clk = 1;
		#100 clk = 0;
	end
endmodule
