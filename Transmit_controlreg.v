module Transmitter_controlreg(Tdata,dataout1, dataout2, clk,Twrite,Taddr);
output [7:0]dataout1,dataout2;
reg[7:0] Tburst;
reg[7:0] Tsize;
reg [7:0]dataout1, dataout2;
input clk,Twrite;
input[7:0] Tdata;
input[3:0] Taddr;

reg[31:0] dout;

always@ (negedge clk)
begin
	if(Taddr==2&&Twrite==1)
		Tburst<=Tdata;
	if(Taddr==1&&Twrite==1)
		Tsize<=Tdata;
	dataout2<=Tburst;
	dataout1<=Tsize;
	
end

endmodule 