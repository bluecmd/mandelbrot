/**
 * Pipelined mandelbrot generator.
 * Written by Christian Svensson <blue@cmd.nu> 2011
 */

module mandelbrot_generator(CLOCK_50, VGA_CLK, VGA_BLANK, VGA_HS, VGA_VS, VGA_SYNC, VGA_R, VGA_G, VGA_B, SW, LEDR);

  parameter width = 32;

  input CLOCK_50;
  
  output VGA_CLK;
  output VGA_BLANK;
  output VGA_HS;
  output VGA_VS;
  output VGA_SYNC;

  input [17:0] SW;
  output [17:0] LEDR;
  
  output [9:0] VGA_R;
  output [9:0] VGA_G;
  output [9:0] VGA_B;
  
  wire fpga_reset_n;
  wire fpga_clk;
  wire fpga_reset;
  wire logic_clk;
  
  assign fpga_clk = CLOCK_50;
  assign fpga_reset_n = SW[0];
  assign fpga_reset = ~fpga_reset_n;

  wire [10:0] pixel_x;
  wire [10:0] pixel_y;
  
  reg [9:0] pd_r;
  reg [9:0] pd_g;
  reg [9:0] pd_b;

  wire pll_locked;
  
  vga v(fpga_clk, fpga_reset_n, VGA_CLK, VGA_BLANK, VGA_SYNC, VGA_HS, VGA_VS, pixel_x, pixel_y, pd_r, pd_g, pd_b, VGA_R, VGA_G, VGA_B);
  
  pll pll(fpga_reset, fpga_clk, logic_clk, pll_locked);
  
  /* Mandelbrot */
  
  /* Pipeline registers */
  reg [width:0] stage1_re, stage1_im, stage1_p_re, stage1_p_im;
  reg [width:0] stage2_re, stage2_im, stage2_p_re, stage2_p_im;
  reg [width:0] stage3_re, stage3_im, stage3_p_re, stage3_p_im;
  reg [width:0] stage4_re, stage4_im, stage4_p_re, stage4_p_im;
  reg [width:0] stage5_re, stage5_im, stage5_p_re, stage5_p_im;
  reg [width:0] stage6_re, stage6_im, stage6_p_re, stage6_p_im;
  reg [width:0] stage7_re, stage7_im, stage7_p_re, stage7_p_im;
  reg [width:0] stage8_re, stage8_im, stage8_p_re, stage8_p_im;
  
  wire [width:0] m1_re, m1_im;
  wire [width:0] m2_re, m2_im;
  wire [width:0] m3_re, m3_im;
  wire [width:0] m4_re, m4_im;
  wire [width:0] m5_re, m5_im;
  wire [width:0] m6_re, m6_im;
  wire [width:0] m7_re, m7_im;
  wire [width:0] m8_re, m8_im;
  
  /* Support up to 128 pipeline stages */
  reg [6:0] stage1_conv, stage2_conv, stage3_conv, stage4_conv;
  reg [6:0] stage5_conv, stage6_conv, stage7_conv, stage8_conv;
  reg [6:0] stage9_conv, stage10_conv, stage11_conv, stage12_conv;
  reg [6:0] stage13_conv, stage14_conv, stage15_conv;
  reg [6:0] stage_complete_conv;

  wire m1_conv, m2_conv, m3_conv, m4_conv;
  wire m5_conv, m6_conv, m7_conv, m8_conv;

  /* Operational parameters */
  reg signed [width:0] p_re, p_im;

  parameter START_RE = -(33'd67108864); /* -2.0 */
  parameter START_IM = 33'd50331648;    /* +1.5 */
  
  parameter STEP_RE = 157286; /* add steps of 3.0/640 */
  parameter STEP_IM = 209715; /* add steps of 3.0/480 */
  
  /* Pipeline stages */
  mandelbrot  m1( stage1_re,  stage1_im,  m1_re,  m1_im,  stage1_p_re,  stage1_p_im,  m1_conv);
  mandelbrot  m2( stage2_re,  stage2_im,  m2_re,  m2_im,  stage2_p_re,  stage2_p_im,  m2_conv);
  mandelbrot  m3( stage3_re,  stage3_im,  m3_re,  m3_im,  stage3_p_re,  stage3_p_im,  m3_conv);
  mandelbrot  m4( stage4_re,  stage4_im,  m4_re,  m4_im,  stage4_p_re,  stage4_p_im,  m4_conv);
  mandelbrot  m5( stage5_re,  stage5_im,  m5_re,  m5_im,  stage5_p_re,  stage5_p_im,  m5_conv);
  mandelbrot  m6( stage6_re,  stage6_im,  m6_re,  m6_im,  stage6_p_re,  stage6_p_im,  m6_conv);
  mandelbrot  m7( stage7_re,  stage7_im,  m7_re,  m7_im,  stage7_p_re,  stage7_p_im,  m7_conv);
  mandelbrot  m8( stage8_re,  stage8_im,  m8_re,  m8_im,  stage8_p_re,  stage8_p_im,  m8_conv);

  reg [3:0] counter;

  always @(posedge fpga_clk or posedge fpga_reset)
  begin
    if (fpga_reset)
    begin
      stage1_p_re <= 33'd0;
      stage1_p_im <= 33'd0;
      stage1_re <= 33'd0;
      stage1_im <= 33'd0;

      stage2_p_re <= 33'd0;
      stage2_p_im <= 33'd0;
      stage2_re <= 33'd0;
      stage2_im <= 33'd0;

      stage3_p_re <= 33'd0;
      stage3_p_im <= 33'd0;
      stage3_re <= 33'd0;
      stage3_im <= 33'd0;

      stage4_p_re <= 33'd0;
      stage4_p_im <= 33'd0;
      stage4_re <= 33'd0;
      stage4_im <= 33'd0;

      stage5_p_re <= 33'd0;
      stage5_p_im <= 33'd0;
      stage5_re <= 33'd0;
      stage5_im <= 33'd0;

      stage6_p_re <= 33'd0;
      stage6_p_im <= 33'd0;
      stage6_re <= 33'd0;
      stage6_im <= 33'd0;

      stage7_p_re <= 33'd0;
      stage7_p_im <= 33'd0;
      stage7_re <= 33'd0;
      stage7_im <= 33'd0;

      stage8_p_re <= 33'd0;
      stage8_p_im <= 33'd0;
      stage8_re <= 33'd0;
      stage8_im <= 33'd0;

      stage1_conv <= 6'd0;
      stage2_conv <= 6'd0;
      stage3_conv <= 6'd0;
      stage4_conv <= 6'd0;
      stage5_conv <= 6'd0;
      stage6_conv <= 6'd0;
      stage7_conv <= 6'd0;
      stage8_conv <= 6'd0;
      stage9_conv <= 6'd0;
      stage10_conv <= 6'd0;
      stage11_conv <= 6'd0;
      stage12_conv <= 6'd0;
      stage13_conv <= 6'd0;
      stage14_conv <= 6'd0;
      stage15_conv <= 6'd0;

      counter <= 4'd0;
    end
    else
    begin
      if (counter == 4'd1)
        counter <= 4'd0;
      else
        counter <= counter + 4'd1;

      if (counter == 4'd0)
      begin
        stage1_p_re <= p_re;
        stage1_p_im <= p_im;
        stage1_re <= 33'd0;
        stage1_im <= 33'd0;

        stage2_p_re <= stage1_p_re;
        stage2_p_im <= stage1_p_im;
        stage2_re <= m1_re;
        stage2_im <= m1_im;

        stage3_p_re <= stage2_p_re;
        stage3_p_im <= stage2_p_im;
        stage3_re <= m2_re;
        stage3_im <= m2_im;

        stage4_p_re <= stage3_p_re;
        stage4_p_im <= stage3_p_im;
        stage4_re <= m3_re;
        stage4_im <= m3_im;

        stage5_p_re <= stage4_p_re;
        stage5_p_im <= stage4_p_im;
        stage5_re <= m4_re;
        stage5_im <= m4_im;

        stage6_p_re <= stage5_p_re;
        stage6_p_im <= stage5_p_im;
        stage6_re <= m5_re;
        stage6_im <= m5_im;

        stage7_p_re <= stage6_p_re;
        stage7_p_im <= stage6_p_im;
        stage7_re <= m6_re;
        stage7_im <= m6_im;

        stage8_p_re <= stage7_p_re;
        stage8_p_im <= stage7_p_im;
        stage8_re <= m7_re;
        stage8_im <= m7_im;


        stage1_conv <= 6'd0;
        stage3_conv <= (&(~stage2_conv) && ~m1_conv) ? 7'd3 : stage2_conv;
        stage5_conv <= (&(~stage4_conv) && ~m2_conv) ? 7'd5 : stage4_conv;
        stage7_conv <= (&(~stage6_conv) && ~m3_conv) ? 7'd7 : stage6_conv;
        stage9_conv <= (&(~stage4_conv) && ~m4_conv) ? 7'd9 : stage8_conv;
        stage11_conv <= (&(~stage10_conv) && ~m5_conv) ? 7'd11 : stage10_conv;
        stage13_conv <= (&(~stage12_conv) && ~m6_conv) ? 7'd13 : stage12_conv;
        stage15_conv <= (&(~stage14_conv) && ~m7_conv) ? 7'd15 : stage14_conv;
      end
      else if (counter == 4'd1)
      begin
        stage1_re <= m1_re;
        stage1_im <= m1_im;

        stage2_re <= m2_re;
        stage2_im <= m2_im;

        stage3_re <= m3_re;
        stage3_im <= m3_im;

        stage4_re <= m4_re;
        stage4_im <= m4_im;

        stage5_re <= m5_re;
        stage5_im <= m5_im;

        stage6_re <= m6_re;
        stage6_im <= m6_im;

        stage7_re <= m7_re;
        stage7_im <= m7_im;

        stage8_re <= m8_re;
        stage8_im <= m8_im;

        stage2_conv <= (&(~stage1_conv) && ~m1_conv) ? 7'd2 : stage1_conv;
        stage4_conv <= (&(~stage3_conv) && ~m2_conv) ? 7'd4 : stage3_conv;
        stage6_conv <= (&(~stage5_conv) && ~m3_conv) ? 7'd6 : stage5_conv;
        stage8_conv <= (&(~stage7_conv) && ~m4_conv) ? 7'd8 : stage7_conv;
        stage10_conv <= (&(~stage9_conv) && ~m5_conv) ? 7'd10 : stage9_conv;
        stage12_conv <= (&(~stage11_conv) && ~m6_conv) ? 7'd12 : stage11_conv;
        stage14_conv <= (&(~stage13_conv) && ~m7_conv) ? 7'd14 : stage13_conv;
        stage_complete_conv <= (&(~stage15_conv) && ~m8_conv) ? 7'd16 : stage15_conv;
      end
    end
  end

  wire [width:0] pad_x;
  wire [width:0] pad_y;
  
  assign pad_x[width:11] = {22{pixel_x[10]}};
  assign pad_y[width:11] = {22{pixel_y[10]}};
  
  assign pad_x[10:0] = pixel_x;
  assign pad_y[10:0] = pixel_y;

    
  always @(posedge fpga_clk or posedge fpga_reset)
  begin
    if (fpga_reset)
      begin
        p_re <= START_RE;
        p_im <= START_IM; 
      end
    else
      begin
        p_re <= START_RE + pad_x * STEP_RE;
        p_im <= START_IM - pad_y * STEP_IM;
      end
  end
  
  always @(posedge VGA_CLK)
  begin
    if (VGA_CLK)
      begin
        if (pixel_x == 639)
          pd_b <= 10'b1111111111;
        else if (pixel_y == 479)
          pd_b <= 10'b1111111111;
        else if (pixel_x == 0)
          pd_b <= 10'b1111111111;
        else if (pixel_y == 0)
          pd_b <= 10'b1111111111; 
        else
          pd_b <= 10'd0;
        pd_r <= 10'd0;
        pd_g[9:6] <= stage_complete_conv[3:0];
        pd_g[5:0] <= 6'd0;
      end
  end
    
endmodule
