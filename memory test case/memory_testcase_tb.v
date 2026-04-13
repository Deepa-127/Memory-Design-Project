`include "memory_testcase.v"
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
	reg [8*27-1:0]test_name;
	
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
		//	write(0,31);
		//	read(0,31);			
			//read
			bd_write();
			bd_read();
			$value$plusargs("test_name=%s",test_name);
			case(test_name)
					"1WR_1RD" : begin
							write (15,1);
							read (15,1);
					end		
					"5WR_5RD" : begin
							write (5,5);
							read (5,5);
					end		
					"FDWR_FDRD" : begin
							write (0,DEPTH);
							read (0,DEPTH);
					end		
  					"FDWR_BDRD" : begin
							write (0,DEPTH);
							bd_read ();
					end		
					"BDWR_FDRD" : begin
							bd_write ();
							read (0,DEPTH);
					end		
					"BDWR_BDRD" : begin
							bd_write ();
							bd_read ();
					end		
					"1ST_QUATOR" : begin
							write (0,DEPTH/4);
							read (0,DEPTH/4);
					end		
					"2ND_QUATOR" : begin
							write (DEPTH/4,DEPTH/4);
							read (DEPTH/4,DEPTH/4);
					end		
					"3RD_QUATOR" : begin
							write (DEPTH/2,DEPTH/4);
							read (DEPTH/2,DEPTH/4);
					end		
					"4TH_QUATOR" : begin
							write ((3*DEPTH)/4,DEPTH/4);
							read ((3*DEPTH)/4,DEPTH/4);
					end		
					"CONSECUTIVE" : begin
							for(i=0;i<DEPTH;i=i+1) begin
									consecutive_wr_rd(i);
							end
					end	
					default: $display("case failure occured");
			endcase								
			#50;
			$finish;		
	end
	task write (input reg[ADDR_WIDTH-1:0] start_loc,input reg [ADDR_WIDTH:0]num_loc); begin
	
			for (i=start_loc; i<(start_loc + num_loc);i=i+1)begin
					@(posedge clk);
					wr_rd=1;
					addr=i;
					wdata=$random;
					valid=1;
					wait(ready==1);

			end		
					@(posedge clk);
					wr_rd=0;
					addr=0;
					valid=0;

	end		
	endtask	
		
	task read (input reg[ADDR_WIDTH-1:0] start_loc,input reg [ADDR_WIDTH:0]num_loc); begin
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

	task bd_write();
		$readmemh("input.hex",dut.mem);
	endtask	

	task bd_read();
		$writememh("output.hex",dut.mem);
	endtask	
	
	task consecutive_wr_rd(input integer N); begin
		@(posedge clk);
		wr_rd=1;
		addr=N;
		wdata=$random;
		valid=1;	
		wait(ready==1);

	    @(posedge clk);
		wr_rd=0;
		addr=0;
		wdata=0;
		valid=0;

		@(posedge clk);
		wr_rd=0;
		addr=N;
		valid=1;
		wait(ready==1);

 		@(posedge clk);
		wr_rd=0;
		addr=0;
		valid=0;
	end	
	endtask


endmodule	


