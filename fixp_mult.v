/**
 * Simple fixed point multiplicator.
 * Written by Christian Svensson <blue@cmd.nu> 2011
 */
 
module fixp_mult(a,b,res);
	
	parameter scale = 25; // Scale in base 2
	parameter width = 32; // Width in bits
	
	input signed [width:0] a;
	input signed [width:0] b;
	
	output signed [width:0] res;
	
	wire signed [width*2:0] ab;
	assign ab = a*b;
	
	assign res = ab[width+scale:scale];
		
endmodule
