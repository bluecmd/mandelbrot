/**
 * VGA module for the DE2 board
 * Written by Christian Svensson <blue@cmd.nu> 2011
 */
 
module vga(fpga_clk, fpga_reset_n, vga_clk, vga_blank, vga_sync, vga_hs, vga_vs, pixel_x, pixel_y, pd_r, pd_g, pd_b, vga_r, vga_g, vga_b);

  /**
   * External connectors
   */
  input fpga_clk;
  input fpga_reset_n;
  
  output vga_clk;
  output vga_blank;
  output vga_sync;
  output vga_vs;
  output vga_hs;
  
  output [10:0] pixel_x;
  output [10:0] pixel_y;
  
  input [9:0] pd_r;
  input [9:0] pd_g;
  input [9:0] pd_b;
  
  output [9:0] vga_r;
  output [9:0] vga_g;
  output [9:0] vga_b;
  
  /**
   * Internal connections and registers
   */
  reg int_vga_clk;
  
  reg sync_tick;
  
  reg [10:0] int_x;
  reg [10:0] int_y; 
  reg [10:0] vcnt;
  reg [10:0] hcnt;
    
  reg [9:0] int_r;
  reg [9:0] int_g;
  reg [9:0] int_b;
  
  wire int_blank;
  wire int_vblank;
  wire int_hs;
  wire int_vs;  
  
  assign int_blank = ((hcnt > 142 && hcnt < 783) && (vcnt > 35 && vcnt < 516)) ? 1'b0 : fpga_reset_n;
  assign int_vblank = (vcnt > 35 && vcnt < 516) ? 1'b0 : fpga_reset_n;
  assign int_hs = (hcnt < 95) ? (~fpga_reset_n) : 1'b1;
  assign int_vs = (vcnt < 2) ? (~fpga_reset_n) : 1'b1;
  
  /**
   * Keep track of which horisontal line we are drawing
   */
  always @(posedge fpga_clk or negedge fpga_reset_n)
    if (~fpga_reset_n)
      hcnt <= 0;
    else
      if (~int_vga_clk)
        begin
          if (hcnt == 793)
            hcnt <= 0;
          else
            hcnt <= hcnt + 11'd1;
        end
        
  /**
   * Generate internal tick for pixel and vcnt counter beat
   */
  always @(posedge fpga_clk)
    if (fpga_clk)
      sync_tick <= (hcnt == 95 && ~int_vga_clk) ? 1'b1 : 1'b0;
      
  /**
   * Keep track of which vertical line we are drawing
   */
  always @(posedge fpga_clk or negedge fpga_reset_n)
    if (~fpga_reset_n)
      vcnt <= 12;
    else
      if (sync_tick)
        begin
          if (vcnt == 524)
            vcnt <= 0;
          else
            vcnt <= vcnt + 11'd1;
        end
  

        
  /**
   * Generate the VGA clock
   */
  always@(posedge fpga_clk or negedge fpga_reset_n)
  begin
    if (~fpga_reset_n)
      int_vga_clk <= 1;
    else if (fpga_clk)
      int_vga_clk <= ~int_vga_clk;
  end
    
  /*
   * Pixel counters for external reference.
   * Mainly used for external resources to know what pixel we want in to
   * the VGA generator.
   */
  always@(posedge fpga_clk or negedge fpga_reset_n)
  begin
    if (~fpga_reset_n)
      begin
        int_x <= 0;
        int_y <= 0;
      end
    else
      begin
        if (int_vblank == 1)
          begin
            int_x <= 0;
            int_y <= 0;
          end
        else if (sync_tick == 1)
          begin
            int_y <= int_y + 11'd1;
            int_x <= 0;
          end
        else if (int_blank == 0)
          begin
            if (int_vga_clk == 1)
              int_x <= int_x + 11'd1;
          end
        else
          int_x <= 0;
      end
  end
  
  /**
   * VGA output generator
   */
  always @(posedge fpga_clk or negedge fpga_reset_n)
  begin
    if (~fpga_reset_n)
      begin
        int_r <= 9'b111111111;
        int_g <= 9'b111111111;
        int_b <= 9'b111111111;
      end
    else
      begin
        int_r <= pd_r;
        int_g <= pd_g;
        int_b <= pd_b;
      end
  end

  assign vga_blank = ~int_blank;
  
  assign pixel_x = int_x;
  assign pixel_y = int_y;
  
  assign vga_clk = int_vga_clk;
  assign vga_hs = int_hs;
  assign vga_vs = int_vs;
  assign vga_sync = 1;
  
  assign vga_r = int_r;
  assign vga_g = int_g;
  assign vga_b = int_b;
  
endmodule
