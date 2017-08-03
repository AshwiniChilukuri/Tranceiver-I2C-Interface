
module Transmitter_controlreg(Tdata,dataout,clk,Twrite,Taddr);
output dataout;
reg[7:0] Tburst;
reg[7:0] Tsize;
reg [7:0] dataout;
input clk,Twrite;
input[7:0] Tdata;
input Taddr;

reg[31:0] dout;

always@ (negedge clk)
begin
	if(Taddr==2&&Twrite==1)
		Tburst<=Tdata;
	if(Taddr==1&&Twrite==1)
		Tsize<=Tdata;
	if(Taddr==2&&Twrite==0)
	dataout<=Tburst;
	if(Taddr==1&&Twrite==0)
	dataout<=Tsize;
	
end

endmodule 
