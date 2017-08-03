module Buffer1(buffout,data,loadbuff,shiftbuff,clk);

output buffout;
input [31:0] data;
input loadbuff,shiftbuff,clk;
reg buffout;
reg [31:0] tempdata;

always @(negedge clk)
begin
if(loadbuff)
tempdata <= data;
else if(shiftbuff)
begin
buffout <= tempdata[0];
tempdata <= {1'b0,tempdata[31:1]};  //right shift
end
end




endmodule
