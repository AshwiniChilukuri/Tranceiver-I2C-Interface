module topModule(rxValid, rxOut, readydata, txdata, startTx, data, write, addin, reset, clk);

output readydata, rxValid;
output [31:0]rxOut;
input startTx, write, reset, clk;
input [31:0] txdata;
input [7:0]data;
input [3:0]addin;
wire clock, sda;

Transmitter Transmitter(.sda(sda),.clock(clock),.readydata(readydata),.txdata(txdata),.startTx(startTx),.data(data),.write(write),.addin(addin),.reset(reset),.clk(clk));
Reciever Reciever(.rxValid(rxValid), .rxOut(rxOut), .sda(sda), .scl(clock), .raddOut(addin), .rData(data), .rWrite(write), .reset(reset), .clk(clk));

endmodule

