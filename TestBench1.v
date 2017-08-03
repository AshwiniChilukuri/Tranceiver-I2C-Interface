`timescale 10ns/1ns
module TestBench1(readydata,rxValid,rxOut);
input readydata, rxValid;
input [31:0]rxOut;
reg startTx, write, reset, clk;
reg [7:0]data;
reg [3:0]addin;
reg [2:0]nextState;
reg [1:0]count;
reg signed [7:0]txdata;		//change the dimension based on size [size-1:0]txdata
reg signed [7:0]temp[1:0];	//change the dimension based on size and burst [size-1:0]temp[burst-1:0]
reg [5:0] i,j;
reg [7:0]burst;


topModule topModule(.rxValid(rxValid), .rxOut(rxOut), .readydata(readydata), .txdata(txdata), .startTx(startTx), .data(data), .write(write),.addin(addin),.reset(reset),.clk(clk));

always #10 clk = ~clk;
	
initial begin
reset <= 0;
clk <= 1;
nextState <= 3'd0;
count<=2'd2;
i<=6'd0;
j<=6'd0;

/*Add more indices for higher burst values	
temp[0]<=$random;
....
temp[burst-1]<=$random;
*/

temp[0]<=$random;		//based on burst
temp[1]<=$random;		//based on burst
//temp[2]<=$random;		//based on burst
//temp[3]<=$random;		//based on burst


end

always @(posedge clk)
begin
		
	if(readydata)
	begin	
		txdata <= temp[i];
		i<=i+1;
	end
	
	if (rxValid && (temp[j]==rxOut[7:0])) // change the dimensions of rxOut based on size
	begin
		$display("ok");
		j<=j+1;
	end		
end


always@(posedge clk)
begin
case(nextState)
3'd0:
	begin
		
		
			write <= 1;	    
			data <= 8'd8;  			//Size in bits
			addin <= 4'd01;
			nextState <= 3'd1;
	end
		
3'd1:
	begin
			data <= 8'd4;  			//burst's value
			addin <= 4'd02;	
			nextState <= 3'd2;
			burst <=8'd2;

	end

3'd2:
	begin
			write<=0;	
			nextState <= 3'd5;
			startTx<=1;

	end
3'd5:
	begin
			startTx<=0;
	end


endcase
end
endmodule
