module receiverController(rx, loadB0, loadB1, loadSize, loadBurst, decSize, decBurst, rbuffSel, rxValid, scl,clk, sda, sizeOut, burstOut);//include Sack
input scl,clk, sda; 
input [7:0]sizeOut, burstOut;

output loadB0, loadB1, loadSize, loadBurst, decSize, decBurst, rbuffSel, rxValid, rx;
reg loadB0, loadB1, loadSize, loadBurst, decSize, decBurst, rbuffSel, rxValid, rx;
reg [6:0]nextState;
reg start;
reg [1:0]temp,temp1;
reg dummyClock;

initial
begin
	nextState <= 7'd0;
	rx<=0;
	loadSize<=1;
	loadBurst<=1;
	
end
always@(posedge clk or negedge clk)
begin
case(nextState)
	7'd0: 
	begin
		if (sda==1)
			temp <= 2'd1;
		else if (temp==1 && scl==1)
			temp <= 2'd2;
		else if (temp==2 && sda==0)
		begin
			nextState <= 7'd1;
			temp <=2'd3;
		end
		else
		begin
			nextState <= 7'd0;
			temp<=2'd0;
			loadB0<=1;
			
		end
	end
endcase
end
//stop
always@(posedge clk or negedge clk)
begin
case(nextState)
	7'd77: 
	begin
		if (sda==0)
			temp1 <= 2'd1;
		else if (temp1==1 && scl==1)
			temp1 <= 2'd2;
		else if (temp1==2 && sda==1)
		begin
			temp1 <=2'd3;
		end
		else
		begin
			nextState <= 7'd77;
			temp1<=2'd0;
			$display("stop");
			
		end
	end
endcase
end
//end stop
always@(negedge clk)
begin

case(nextState)
	
	7'd1:		//receiving b0
		
		begin 
				loadSize<=0;
				loadBurst<=0;
				if(burstOut>0)
				begin
					loadB1<=0;
					rx<=0;
					loadB0<=0;
					decSize <=1;
					nextState <= 7'd2;
					if(sizeOut==1)
					begin
						decBurst<=1;
						rxValid<=1;
						rbuffSel<=0;
					end
				end
				else
				nextState<=7'd77;
				
						
		end 
	
	7'd2:
				
		begin
				loadB0 <=1;
				rxValid<=0;
				decSize <=0;
				decBurst <=0;
				nextState<=7'd1;
				if((sizeOut-1)%8==0)
				begin
					rx<=1;
					nextState<=7'd3;
					loadB0<=0;
				end
					
		end
			
				
				
	7'd3:	//ack
		begin
			rx <= 1;
			loadB0 <=0;
			nextState <= 7'd4;
			
			
		end
	7'd4:
		begin
			rx<=0;
			if(sizeOut!=0)
			begin
			nextState <= 7'd1;
			loadB0<=1;
			end
			else
			begin
			loadSize<=1;
			loadB1 <=1;
			nextState <= 7'd5;
			end
			
		end
	
	7'd5:		//receiving b1
		
		begin 
				loadSize<=0;
				loadBurst<=0;
				if(burstOut>0)
				begin
					loadB0<=0;
					rx<=0;
					loadB1<=0;
					decSize <=1;
					nextState <= 7'd6;
					if(sizeOut==1)
					begin
						decBurst<=1;
						rxValid<=1;
						rbuffSel<=1;
					end
				end
				else
				nextState<=7'd77;
				
						
		end 
	
	7'd6:
				
		begin
				loadB1 <=1;
				rxValid<=0;
				decSize <=0;
				decBurst <=0;
				nextState<=7'd5;
				if((sizeOut-1)%8==0)
				begin
					rx<=1;
					nextState<=7'd7;
					loadB1<=0;
				end
		end
			
				
				
	7'd7:	//ack
		begin
			rx <= 1;
			loadB1 <=0;
			nextState <= 7'd8;
			
			
		end
	7'd8:
		begin
			rx<=0;
			if(sizeOut!=0)
			begin
				nextState <= 7'd5;
				loadB1<=1;
			end
			else
			begin
				loadSize<=1;
				loadB0 <=1;
				nextState <= 7'd1;
			end
			
		end
	

endcase	
end
endmodule
