module Transmitter(clock, readydata,txdata,startTx,data,write,addin,reset,clk,sda);

inout sda;
output clock;
output readydata;
input [31:0] txdata;
input startTx;
input [7:0] data;
input write;
input [3:0] addin;
input reset;
input clk;
wire [7:0] cntrldata1,cntrldata2;
wire loadB0,loadB1,shiftB0,shiftB1,start,loadsize,decsize,loadburst,decburst,stop;
wire [1:0] buffsel;
wire buffout0,buffout1;
wire [7:0] sizeout, burstout;
wire sdaIn;
wire sdaOut;
reg clock;
wire tx;

initial
begin
clock <= 0;
end

always@(posedge clk)
begin
clock <= ~clock;
end

Transmitter_controlreg Transmitter_controlreg(.Tdata(data),.dataout1(cntrldata1),.dataout2(cntrldata2),.clk(clk),.Twrite(write),.Taddr(addin));
Buffer0 Buffer0(.buffout(buffout0),.data(txdata),.loadbuff(loadB0),.shiftbuff(shiftB0),.clk(clk));
Buffer1 Buffer1(.buffout(buffout1),.data(txdata),.loadbuff(loadB1),.shiftbuff(shiftB1),.clk(clk));
mux4X1 mux4X1( .out(sdaOut),.select(buffsel),.in1(start),.in2(buffout0),.in3(buffout1),.in4(stop));
sizecount sizecount(.sizeout(sizeout),.loadsize(loadsize),.decsize(decsize),.size(cntrldata1),.clk(clk));
burstcount burstcount(.burstout(burstout),.loadburst(loadburst),.decburst(decburst),.burst(cntrldata2),.clk(clk));
controller controller(.tx(tx),.buffsel(buffsel),.loadsize(loadsize),.decsize(decsize),.loadburst(loadburst),.decburst(decburst),
	.readydata(readydata),.loadB0(loadB0),.shiftB0(shiftB0),.loadB1(loadB1),.shiftB1(shiftB1),.start(start),.stop(stop),.clk(clk),.startTx(startTx),.burstout(burstout),.reset(reset),.sizeout(sizeout),.sdaIn(sdaIn));
transmitterGateway transmitterGateway(.sdaIn(sdaIn), .sdaOut(sdaOut), .sda(sda), .tx(tx));

endmodule
