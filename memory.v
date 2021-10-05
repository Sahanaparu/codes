module memory (clk, rst, addr, w_data, r_data, w_en, r_en); //valid, ready);

parameter	WIDTH=16;
parameter	DEPTH=128;
parameter	ADDR_WIDTH=7;
input		clk, rst, w_en, r_en;
input		[ADDR_WIDTH-1:0]addr;
input		[WIDTH-1:0]w_data;
//input		valid;
//output reg	ready;
output reg 	[WIDTH-1:0]r_data;
reg 		[WIDTH-1:0]mem [DEPTH-1:0];
integer i;

always @ (posedge clk)
begin
	if (rst==1)
	begin
		r_data=0;
		for (i=0; i<DEPTH; i=i+1)
			mem[i]=0;
	end

	else
	begin
		if (w_en==1) //&& valid==1)
		begin
//			ready=1;
			mem[addr]=w_data;
		end

		if (r_en==1)
		begin
			r_data=mem[addr];
		end
	end
end

endmodule
