module Reciever(rxValid, rxOut, sda, scl, raddOut, rData, rWrite, reset, clk);

output rxValid;
output [31:0]rxOut;
inout sda;
input scl,rWrite,reset,clk;
input [3:0]raddOut;
input [7:0]rData;
wire [7:0]size,burst;
wire sdaIn,rx,loadB0, loadB1, loadSize, loadBurst, decSize, decBurst, rbuffSel;
wire [7:0] sizeout,burstout;
wire [31:0] buffOut0,buffOut1;


receiverGateway receiverGateway(.sda(sda), .rx(rx),.sdaIn(sdaIn));
receiverController receiverController(.rx(rx), .loadB0(loadB0), .loadB1(loadB1), .loadSize(loadSize), .loadBurst(loadBurst), .decSize(decSize), .decBurst(decBurst), 
		.rbuffSel(rbuffSel), .rxValid(rxValid), .scl(scl),.clk(clk), .sda(sda), .sizeOut(sizeout), .burstOut(burstout));
Receiver_controlreg Receiver_controlreg(.Rdata(rData),.dataout1(size),.dataout2(burst),.clk(clk),.Rwrite(rWrite),.Raddr(raddOut));
RBuffer0 RBuffer0(.Rbout(buffOut0),.din(sda),.clk(clk),.size(size), .rloadB0(loadB0));
RBuffer1 RBuffer1(.Rbout(buffOut1),.din(sda),.clk(clk),.size(size),.rloadB1(loadB1));
mux2x1 mux2x1(.out(rxOut), .in0(buffOut0),.in1(buffOut1),.sel(rbuffSel));
Rsizecount Rsizecount(.Rsizeout(sizeout),.loadsize(loadSize),.decsize(decSize),.size(size),.clk(clk));
Rburstcount Rburstcount(.Rburstout(burstout),.loadburst(loadBurst),.decburst(decBurst),.burst(burst),.clk(clk));

endmodule
