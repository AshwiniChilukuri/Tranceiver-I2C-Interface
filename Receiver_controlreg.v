module Receiver_controlreg(Rdata,dataout1, dataout2, clk,Rwrite,Raddr);
output [7:0] dataout1,dataout2;
reg[7:0] Rburst;
reg[7:0] Rsize;
reg [7:0]dataout1, dataout2;
input clk,Rwrite;
input[7:0] Rdata;
input[3:0] Raddr;

reg[31:0] dout;

always@ (negedge clk)
begin
	if(Raddr==2&&Rwrite==1)
		Rburst<=Rdata;
	if(Raddr==1&&Rwrite==1)
		Rsize<=Rdata;
	dataout2<=Rburst;
	dataout1<=Rsize;
	
end

endmodule 
