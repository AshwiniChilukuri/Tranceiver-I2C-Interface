module RBuffer1 (Rbout,din,clk,size,rloadB1);

output [31:0] Rbout ;
input rloadB1;
reg [7:0]r1;
reg [15:0]r2;
reg [31:0] Rbout;
input din,clk;
input [7:0]size;
initial
begin
	Rbout<=32'b0;
	r1<=8'd0;
	r2<=16'd0;
end

always @ (negedge (clk))
begin 
	if(size==8'd8 && rloadB1)
	begin
	Rbout<={24'd0,din,Rbout[7:1]};
	end
	else if(size==8'd16 && rloadB1)
	begin
	Rbout<={16'd0,din,Rbout[15:1]};
	end
	else if(size==8'd32 && rloadB1)
	begin
	Rbout<={din,Rbout[31:1]};
	end
end
endmodule