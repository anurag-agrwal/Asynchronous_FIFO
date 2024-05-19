module Binary2Gray #(parameter ptr_bits=4)(binary_in, gray_out);

input [ptr_bits-1:0] binary_in;
output [ptr_bits-1:0] gray_out;

assign gray_out[ptr_bits-1] = binary_in[ptr_bits-1];

genvar i;
generate
	for (i=ptr_bits-2; i>=0; i=i-1'b1) begin : binary2gray
		xorr x0 (binary_in[i], binary_in[i+1], gray_out[i]);
	end
endgenerate

endmodule
