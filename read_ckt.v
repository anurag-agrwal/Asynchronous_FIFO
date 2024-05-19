module read_ckt #(parameter DEPTH=8)(wr_ptr_rdclk_gray, rd_ptr, rd_ptr_gray, EMPTY);

parameter ptr_bits = $clog2(DEPTH);
input [ptr_bits:0] wr_ptr_rdclk_gray, rd_ptr;
output [ptr_bits:0] rd_ptr_gray;
output EMPTY;
wire [ptr_bits:0] wr_ptr_rdclk;

// Gray to Binary conversion of rd_ptr
Gray2Binary #(ptr_bits+1) G2B1 (.gray_in(wr_ptr_rdclk_gray), .binary_out(wr_ptr_rdclk));

// Binary to Gray conversion of rd_ptr
Binary2Gray #(ptr_bits+1) B2G1 (.binary_in(rd_ptr), .gray_out(rd_ptr_gray));

// Empty condition: rd_ptr and wr_ptr should be same, including the extra added MSB bit
assign EMPTY = ( wr_ptr_rdclk[ptr_bits:0] ==  rd_ptr[ptr_bits:0] );

endmodule
