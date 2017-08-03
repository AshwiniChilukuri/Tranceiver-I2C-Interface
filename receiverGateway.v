module receiverGateway(sda, sdaIn, rx);

inout sda;
input rx;
output sdaIn;

assign sdaIn = sda;
assign sda=(rx)?1'b0:1'bz;


endmodule
