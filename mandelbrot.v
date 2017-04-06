/**
 * Mandelbrot iterator.
 * Written by Christian Svensson <blue@cmd.nu> 2011
 */
 
/**
 * Test point: Re: -1.3475 Im: 0.0625
 *  Over limit at 84 iterations
 */
module mandelbrot(in_re, in_im, out_re, out_im, p_re, p_im, conv_out);
	parameter width = 32;

	input signed [width:0] in_re;
	input signed [width:0] in_im;
	
	output signed [width:0] out_re;
	output signed [width:0] out_im;
	
	input signed [width:0] p_re;
	input signed [width:0] p_im;
	
	output conv_out;
	
	wire signed [width:0] re_sq;
	wire signed [width:0] im_sq;
	wire signed [width:0] imre;
	
	/* Re(z)^2 */
	fixp_mult mult1(in_re, in_re, re_sq);
	
	/* Im(z)^2 */
	fixp_mult mult2(in_im, in_im, im_sq);
	
	/* Re(z)*Im(z) */
	fixp_mult mult3(in_re, in_im, imre);
		
	assign out_re = re_sq - im_sq + p_re;
	assign out_im = (imre << 1) + p_im;
	
	assign conv_out = ((re_sq + im_sq) > 33'd134217728) ? (1'd0) : (1'd1);	
endmodule
