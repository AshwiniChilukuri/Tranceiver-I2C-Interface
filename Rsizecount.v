
module Rsizecount(Rsizeout,loadsize,decsize,size,clk);
output[7:0] Rsizeout;
input loadsize,decsize,clk;
input[7:0] size;
reg[7:0] Rsizeout;

always@ (negedge clk)
begin
if (loadsize)
Rsizeout <= size;
else if(decsize)
Rsizeout <= Rsizeout-1;
end
endmodule 