module controller(tx,buffsel,loadsize,decsize,loadburst,decburst,
			readydata,loadB0,shiftB0,loadB1,shiftB1,start,stop,clk,startTx,burstout,reset,sizeout, sdaIn);//include Sack
output loadsize,decsize,loadburst,decburst,readydata,loadB0,shiftB0,loadB1,shiftB1,start,stop, tx;
output [1:0] buffsel;
input [7:0] burstout;
input startTx,clk,reset,sdaIn;//include Sda
input [7:0] sizeout;
reg loadsize,decsize,loadburst,decburst,addsel,readydata,loadB0,shiftB0,loadB1,shiftB1,datasel,start,stop;
reg [1:0] buffsel;
reg [6:0] nextState;
reg [1:0] count;
reg tx;

initial
begin
	nextState <= 7'd0;
	readydata <= 0;		//setting everything to 0
	loadsize<=0;
	decsize<=0;
	loadburst<=0;
	decburst<=0;
	loadB0<=0;
	loadB1<=0;
	shiftB0<=0;
	shiftB1<=0;
	tx<=1;
end

always@(negedge clk)
begin

case(nextState)
	7'd0: 
		begin 	if (startTx)			//proceed to the next state if write is low or stay in the same state
			nextState <= 7'd1;
			else
			nextState <= 7'd0;
		end
	7'd1:
					//start bit to SDA
		begin
			readydata<=1;
			loadsize<=1;
			loadburst<=1;
			loadB0<=1;
			start<=1;
			buffsel<=2'd0;
			tx<=1;
			nextState<=7'd2;
			
		end
				
	7'd2:
		
		begin  
			loadsize<=0;
			loadburst<=0;
			loadB0<=0;
			start<=0;
			buffsel<=2'd0;
			readydata<=1;
			decsize<=1;
			decburst<=1;
			shiftB0<=1;
			loadB1<=1;
			tx<=1;			
			nextState<=7'd3;
		end 
	
	7'd3:
					//B0 data transmission
		begin
			readydata<=0;
			decsize<=0;
			decburst<=0;
			shiftB0<=0;
			loadB1<=0;
			nextState<=7'd4;
			buffsel<=2'd1;
			tx<=1;
		end
	7'd4:				
		begin	if (sizeout%8!= 0)
			begin
			buffsel<=2'd1;
			shiftB0<=1;
			decsize<=1;
			tx<=1;
			nextState<=7'd3;
			end
			else if (sizeout ==0)//shuld check ack and start sending B1
			begin
			nextState<=7'd5;
			end
			else
			begin
			nextState <=7'd40 ; //shuld check ack and send b0
			end
		end
	7'd40:		
		begin
			tx<=0;
			readydata<=0;
			loadsize<=0;
			loadB0<=0;
			nextState<=7'd41;
		end
	7'd41:
		begin   //if(sda==0)
			tx<=0;
			decsize<=1;
			shiftB0<=1;
			nextState<=7'd3;
		end
	7'd5:				//check for ack
		begin	
			tx<=0;
			loadsize<=1;
			loadB0<=1;
			if((burstout)>0)
			begin
			nextState<=7'd6;
			readydata<=1;
			end
			else
			begin
			nextState<=7'd11;
			readydata<=0;
			tx<=0;
			end
			
		end
	7'd6:				
		begin	
			readydata<=0;
			loadsize<=0;
			decsize<=1;
			decburst<=1;
			loadB0<=0;
			tx<=0;
			//if(sda==0)
			shiftB1<=1;
			nextState<=7'd7;				
		end
	7'd7:	
		begin	//starting b1
			decsize<=0;
			decburst<=0;
			shiftB1<=0;
			buffsel<=2'd2;
			nextState<=7'd8;
			tx<=1;
		end
	7'd8:
		begin
			if(sizeout%8!=0)
			begin
			decsize<=1;
			shiftB1<=1;
			buffsel<=2'd2;
			nextState<=7'd7;
			tx<=1;
			end
			else if (sizeout ==0)//shuld check ack and start sending B0
			begin
			nextState<=7'd9;
			end
			else
			begin
			nextState <=7'd81 ; //shuld check ack and send b1
			end
		end
	7'd81:		//ack
		begin
			tx<=0;
			readydata<=0;
			loadsize<=0;
			loadB1<=0;
			nextState<=7'd82;
		end
	7'd82:
		begin
			//if sda == 0
			decsize<=1;
			shiftB1<=1;
			nextState<=7'd7;
			tx<=0;
		end
	7'd9:		//ack
		begin
			loadsize<=1;
			loadB1<=1;
			
			tx<=0;

			if((burstout)>0)
			begin
			nextState<=7'd10;
			readydata<=1;
			end
			else
			begin
			nextState<=7'd11;
			readydata<=0;
			end



			
		end
	7'd10:
		begin
			readydata<=0;
			loadsize<=0;
			decsize<=1;
			decburst<=1;
			loadB1<=0;
			shiftB0<=1;
			tx<=0;
			nextState<=7'd3; //start transmitting B0			
		end
7'd11:				
		begin
			nextState<=7'd12;
		end
7'd12:		begin
			nextState<=7'd13;
			tx<=1;
			buffsel<=2'd3;
			stop<=0;
		end

	7'd13:				
		begin	
			tx<=1;
			buffsel<=2'd3;
			stop<=1;
			nextState<=7'd14;
		end
			
	7'd14:				
		begin
			tx<=0;
			
		end
	
	

		
endcase	
end
endmodule
