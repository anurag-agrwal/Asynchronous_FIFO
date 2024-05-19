module write_ckt #(parameter DEPTH=8)(rd_ptr_wrclk_gray, wr_ptr, wr_ptr_gray, FULL);

parameter ptr_bits = $clog2(DEPTH);
input [ptr_bits:0] rd_ptr_wrclk_gray, wr_ptr;
output [ptr_bits:0] wr_ptr_gray;
output FULL;
wire [ptr_bits:0] rd_ptr_wrclk;

// Gray to Binary conversion of rd_ptr
Gray2Binary #(ptr_bits+1) G2B0 (.gray_in(rd_ptr_wrclk_gray), .binary_out(rd_ptr_wrclk));

// Binary to Gray conversion of wr_ptr
Binary2Gray #(ptr_bits+1) B2G0 (.binary_in(wr_ptr), .gray_out(wr_ptr_gray));

// Full condition: Extra added MSB bit needs to be different for rd_ptr and wr_ptr
assign FULL = ( {!wr_ptr[ptr_bits], wr_ptr[ptr_bits-1:0]} ==  rd_ptr_wrclk[ptr_bits:0] );

endmodule
