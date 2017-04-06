onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/mg/fpga_reset_n
add wave -noupdate /testbench/mg/fpga_clk
add wave -noupdate /testbench/LEDR
add wave -noupdate -expand -group VGA /testbench/VGA_CLK
add wave -noupdate -expand -group VGA /testbench/VGA_SYNC
add wave -noupdate -expand -group VGA /testbench/VGA_VS
add wave -noupdate -expand -group VGA /testbench/VGA_HS
add wave -noupdate -expand -group VGA /testbench/VGA_BLANK
add wave -noupdate -expand -group VGA -radix hexadecimal /testbench/VGA_R
add wave -noupdate -expand -group VGA -radix hexadecimal /testbench/VGA_G
add wave -noupdate -expand -group VGA -radix hexadecimal /testbench/VGA_B
add wave -noupdate -expand -group PLL /testbench/mg/pll/areset
add wave -noupdate -expand -group PLL /testbench/mg/pll/inclk0
add wave -noupdate -expand -group PLL /testbench/mg/pll/c0
add wave -noupdate -expand -group PLL /testbench/mg/pll/locked
add wave -noupdate /testbench/mg/stage1_conv
add wave -noupdate /testbench/mg/stage2_conv
add wave -noupdate /testbench/mg/stage3_conv
add wave -noupdate /testbench/mg/stage4_conv
add wave -noupdate /testbench/mg/stage5_conv
add wave -noupdate /testbench/mg/stage6_conv
add wave -noupdate /testbench/mg/stage7_conv
add wave -noupdate /testbench/mg/stage8_conv
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {847692225 ps} 0}
configure wave -namecolwidth 205
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2819754 ns}
