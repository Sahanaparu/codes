`include "memory.v"

module memory_tb;

parameter	WIDTH=16;
parameter	DEPTH=128;
parameter	ADDR_WIDTH=7;
reg		clk, rst, w_en, r_en;
//reg		valid;
//wire		ready;
reg		[ADDR_WIDTH-1:0] addr;
reg		[WIDTH-1:0] w_data;
wire	 	[WIDTH-1:0] r_data;
integer i;
reg		[20*8:0] testname;

memory #(.WIDTH(WIDTH), .DEPTH(DEPTH), .ADDR_WIDTH(ADDR_WIDTH)) dut (.clk(clk), .rst(rst), .addr(addr), .w_data(w_data), .r_data(r_data), .w_en(w_en), .r_en(r_en));//, .valid(valid), .ready(ready));

initial 
begin
	clk=0;
	forever
	begin
		#5;
		clk=~clk;
	end
end

initial
begin
	rst=1;
	w_en=0;
	r_en=0;
	#20;
	rst=0;
//	valid=1;

	$value$plusargs ("testname=%s", testname); 
	$display ("testname=%s", testname);

	case (testname)
		"fd_wr_fd_rd" :
		begin
			fd_write();
			fd_read();
		end

		"fd_wr_bd_rd" :
		begin
			fd_write();
			bd_read();
		end

		"bd_wr_fd_rd" :
		begin
			bd_write();
			fd_read();
		end
		
		"bd_wr_bd_rd" :
		begin
			bd_write();
			bd_read();
		end

	endcase
end

task fd_write();
	begin
		for (i=0; i<DEPTH; i=i+1)
		begin
			@ (posedge clk);
			w_en=1;
//			wait (ready==1);
			addr=i;
			w_data=$random;
		end
			@ (posedge clk);
			w_en=0;
			addr=0;
			w_data=0;
	end
endtask

task fd_read();
	begin
		for (i=0; i<DEPTH; i=i+1)
		begin
			@ (posedge clk);
			r_en=1;
			addr=i;
		end
			@ (posedge clk);
			r_en=0;
			addr=0;
	end
endtask

task bd_write();
	begin
		$readmemh ("image_wr.hex", dut.mem);
	end
endtask

task bd_read();
	begin
		$writememh ("image_rd.hex", dut.mem);
	end
endtask

initial
begin
	#5000;
	$finish;
end

endmodule
