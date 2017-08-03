module Rburstcount(Rburstout,loadburst,decburst,burst,clk);
output[7:0] Rburstout;
input loadburst,decburst,clk;
input[7:0] burst;
reg[7:0] Rburstout;

always@ (negedge clk)
begin
if (loadburst)
Rburstout <= burst;
else if(decburst)
Rburstout <= Rburstout-1;
end
endmodule
