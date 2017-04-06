`timescale 1 ns / 1 ns
 
module testbench(VGA_CLK, VGA_BLANK, VGA_HS, VGA_VS, VGA_SYNC, VGA_R, VGA_G, VGA_B, LEDR);
  output VGA_CLK;
  output VGA_BLANK;
  output VGA_HS;
  output VGA_VS;
  output VGA_SYNC;

  output [17:0] LEDR;
  
  output [9:0] VGA_R;
  output [9:0] VGA_G;
  output [9:0] VGA_B;
    
  reg clk;
  reg [17:0] SW;

  mandelbrot_generator mg(clk, VGA_CLK, VGA_BLANK, VGA_HS, VGA_VS, VGA_SYNC, VGA_R, VGA_G, VGA_B, SW, LEDR);
  
  initial begin
    $vga_init();
    clk <= 0;
    SW[0] <= 0;
    SW[17:1] <= 17'b0;
    #100 SW[0] <= 1;
  end
    
  always begin
    #20 clk <= ~clk;
  end

  always @(posedge VGA_CLK)
  begin
    if(VGA_HS == 1)
    begin
      if(VGA_BLANK == 0)
        $vga_pixel(0, 0, 0);
      else
        $vga_pixel(VGA_R, VGA_G, VGA_B);
    end
  end

  always @(VGA_HS)
  begin
    if(VGA_HS == 0)
    begin
      $vga_row();
    end
  end

  always @(posedge clk)
  begin
    if(VGA_VS == 0 && SW[0] == 1)
    begin
      $stop();
    end
  end

endmodule
