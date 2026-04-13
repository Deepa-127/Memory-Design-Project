`include "memory_task.v"
module tb;
	parameter WIDTH =8;
	parameter DEPTH =32;
	parameter ADDR_WIDTH =$clog2(DEPTH);
	reg clk,res,wr_rd,valid;
	reg [ADDR_WIDTH-1:0]addr;
	reg [WIDTH-1:0] wdata;
	wire [WIDTH-1:0]rdata;
	wire ready;
	memory dut(.clk(clk),.res(res),.wr_rd(wr_rd),.addr(addr),.wdata(wdata),.rdata(rdata),.valid(valid),.ready(ready));
	integer i;
	always #5 clk=~clk;
	initial begin
			clk=0;
			res=1;
			addr=0;
			wdata=0;
			wr_rd=0;
			valid=0;
			repeat(2)@(posedge clk);
			res=0;
			//write
			write(5,10);
			read(5,10);			
			//read
			#50;
			$finish;		
	end
		task write (input reg[ADDR_WIDTH-1:0] start_loc,input reg [ADDR_WIDTH-1:0]num_loc); begin
	
			for (i=start_loc; i<(start_loc + num_loc);i=i+1)begin
					@(posedge clk);
					wr_rd=1;
					addr=i;
					wdata=$random;
					valid=1;
			end		
					wait(ready==1);
					@(posedge clk);
					wr_rd=0;
					addr=0;
					valid=0;

		end		
		endtask	
						task read (input reg[ADDR_WIDTH-1:0] start_loc,input reg [ADDR_WIDTH-1:0]num_loc); begin
			for (i=start_loc; i<(start_loc + num_loc);i=i+1)begin
					@(posedge clk);
					wr_rd=0;
					addr=i;
					valid=1;
					wait(ready==1);
			end		
					@(posedge clk);
					wr_rd=0;
					addr=0;
					valid=0;

		end	
		endtask	
endmodule	


