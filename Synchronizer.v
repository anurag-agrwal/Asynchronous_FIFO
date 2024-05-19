module Synchronizer #(parameter DEPTH=8) (rst_n, data_in, clk_out, data_out);

parameter width = $clog2(DEPTH);

input rst_n, clk_out;
input [width:0] data_in;
output reg [width:0] data_out;
reg [width:0] data_1;

always@(posedge clk_out, negedge rst_n)
	begin
    if (!rst_n) begin
				data_1 <= {width+1'b1{1'b0}};
				data_out <= {width+1'b1{1'b0}};
		end
		else begin
				data_1 <= data_in;
				data_out <= data_1;
		end
	end

endmodule
