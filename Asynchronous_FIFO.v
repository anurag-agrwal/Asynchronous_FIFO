// We will see 2 cycle penalty for both EMPTY and FULL flag because of 2 Flop Syncronization
// Make sure to change the DEPTH in all the files, and TB

module Asynchronous_FIFO #(parameter DEPTH=8, DATA_WIDTH=6)
(wr_clk, rd_clk, rst_n, wr_en, rd_en, wr_ptr, rd_ptr, data_in, data_out, FULL, EMPTY);

parameter ptr_bits = $clog2(DEPTH);

reg [DATA_WIDTH-1:0] fifo [DEPTH-1:0];

input wr_clk, rd_clk, wr_en, rd_en, rst_n;

output reg [ptr_bits:0] wr_ptr, rd_ptr; //1 extra bit for FULL, EMPTY condition
input [DATA_WIDTH-1:0] data_in;
output reg [DATA_WIDTH-1:0] data_out;
output FULL, EMPTY;

wire [ptr_bits:0] rd_ptr_wrclk_gray, wr_ptr_gray, wr_ptr_rdclk_gray, rd_ptr_gray;

// Generating Full condition and B2G, G2B conversion
write_ckt #(DEPTH) write0 (rd_ptr_wrclk_gray, wr_ptr, wr_ptr_gray, FULL);

// Sending Gray encoded Binary wr_ptr into rd_clk domain
Synchronizer #(DEPTH) Sync_wr (rst_n, wr_ptr_gray, rd_clk, wr_ptr_rdclk_gray);

// Generating Empty condition and B2G, G2B conversion
read_ckt #(DEPTH) read0 (wr_ptr_rdclk_gray, rd_ptr, rd_ptr_gray, EMPTY);

// Sending Gray encoded Binary rd_ptr into wr_clk domain
Synchronizer #(DEPTH) Sync_rd (rst_n, rd_ptr_gray, wr_clk, rd_ptr_wrclk_gray);

// WRITE
always@(posedge wr_clk, negedge rst_n)
	begin
		if (!rst_n)
				wr_ptr <= {ptr_bits+1{1'b0}};
		
		else if (wr_en && !FULL)
			begin
				fifo[wr_ptr[ptr_bits-1:0]] <= data_in;
				wr_ptr <= wr_ptr + 1'b1;
			end
	end

// READ
always@(posedge rd_clk, negedge rst_n)
	begin
		if (!rst_n)
			begin
				rd_ptr <= {ptr_bits+1{1'b0}};
				data_out <= {DATA_WIDTH{1'b0}};
			end
		
		else if (rd_en && !EMPTY)
			begin
				data_out <= fifo[rd_ptr[ptr_bits-1:0]];
				rd_ptr <= rd_ptr + 1'b1;
			end
	end

endmodule
