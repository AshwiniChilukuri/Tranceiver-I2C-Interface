
module mux4X1( out,select,in1,in2,in3,in4);
output out;
input[1:0] select;
input in1,in2,in3,in4;


reg out;
always@ (in1,in2,in3,in4,select)
begin
   case( select )
       0 : out = in1;
       1 : out = in2;
       2 : out = in3;
       3 : out = in4;
   endcase
end
endmodule
