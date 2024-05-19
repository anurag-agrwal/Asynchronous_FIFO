module Gray2Binary #(parameter ptr_bits=4)(gray_in, binary_out);

input [ptr_bits-1:0] gray_in;
output [ptr_bits-1:0] binary_out;

assign binary_out[ptr_bits-1] = gray_in[ptr_bits-1];

genvar i;
generate
	for (i=ptr_bits-2; i>=0; i=i-1'b1) begin: gray2binary
		xorr x1 (gray_in[i], binary_out[i+1], binary_out[i]);
	end
endgenerate

endmodule
