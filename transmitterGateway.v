
module transmitterGateway(sdaIn, sdaOut, sda, tx);

inout sda;
input sdaOut,tx;
output sdaIn;


assign sda=tx?sdaOut:1'bz;
assign sdaIn = sda;

endmodule
