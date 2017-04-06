#vsim -novopt testbench
vsim -pli vga.so -voptargs="+acc=rn+vga" -debugdb testbench -L work -L altera_mf
#vsim -voptargs="+acc=rn+vga" -debugdb testbench -L work -L altera_mf

#log -r *

do wave.do
run -all

wave zoom full
