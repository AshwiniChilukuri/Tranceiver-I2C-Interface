module burstcount(burstout,loadburst,decburst,burst,clk);
output[7:0] burstout;
input loadburst,decburst,clk;
input[7:0] burst;
reg[7:0] burstout;

always@ (negedge clk)
begin
if (loadburst)
burstout <= burst;
else if(decburst)
burstout <= burstout-1;
end
endmodule
