.PHONY:	work

all: work vga.so

work:
	vlib work
	vlog *.v

sim: all
	vsim -do simulation.do

vga.so: vga_decoder.c
	gcc -Wall -ansi -pedantic -fPIC -shared -g -I/srv/apps/mentor/modelsim_10.0/modeltech/include -o vga.so vga_decoder.c -lSDL

clean:
	rm -fr work
	rm -f vga.so
