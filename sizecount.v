module sizecount(sizeout,loadsize,decsize,size,clk);
output[7:0] sizeout;
input loadsize,decsize,clk;
input[7:0] size;
reg[7:0] sizeout;

always@ (negedge clk)
begin
if (loadsize)
sizeout <= size;
if(decsize)
sizeout <= sizeout-1;
end
endmodule
