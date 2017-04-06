
#include <SDL/SDL.h>
#include "vpi_user.h"


static SDL_Surface* screen;
static int x;
static int y;

static void draw_pixel(SDL_Surface *screen, int x, int y, int r, int g, int b)
{
  uint32_t* buf;
  uint32_t color;

  color = SDL_MapRGB(screen->format, r, g, b);

  buf = (uint32_t*)screen->pixels + y*screen->pitch/4 + x;
  *buf = color;
}

static PLI_INT32 init(PLI_BYTE8* data)
{
  SDL_Init(SDL_INIT_VIDEO);

  screen = SDL_SetVideoMode(800, 600, 32, SDL_SWSURFACE);
  SDL_LockSurface(screen);

  x = 0;
  y = 0;

  return 0;
}

static PLI_INT32 pixel(PLI_BYTE8* data)
{
  int r;
  int g;
  int b;
  vpiHandle systfref, args_iter, argh;
  struct t_vpi_value argval;

  systfref = vpi_handle(vpiSysTfCall, NULL);
  args_iter = vpi_iterate(vpiArgument, systfref);
  argh = vpi_scan(args_iter);
  argval.format = vpiIntVal;
  vpi_get_value(argh, &argval);
  r = argval.value.integer;

  argh = vpi_scan(args_iter);
  argval.format = vpiIntVal;
  vpi_get_value(argh, &argval);
  g = argval.value.integer;

  argh = vpi_scan(args_iter);
  argval.format = vpiIntVal;
  vpi_get_value(argh, &argval);
  b = argval.value.integer;

  draw_pixel(screen, x, y, r >> 2, g >> 2, b >> 2);
  ++x;

  return 0;
}

static PLI_INT32 row(PLI_BYTE8* data)
{
  draw_pixel(screen, x, y, 255, 255, 255);

  SDL_UnlockSurface(screen);
  SDL_UpdateRect(screen, 0, y, 800, 1);
  SDL_LockSurface(screen);

  ++y;
  x = 0;

  return 0;
}

static void vga_register(void)
{
  s_vpi_systf_data systf_data;
  vpiHandle systf_handle;

  systf_data.type        = vpiSysTask;
  systf_data.sysfunctype = 0;
  systf_data.tfname      = "$vga_pixel";
  systf_data.calltf      = pixel;
  systf_data.compiletf   = 0;
  systf_data.sizetf      = 0;
  systf_data.user_data   = 0;
  systf_handle = vpi_register_systf( &systf_data );
  vpi_free_object( systf_handle );

  systf_data.type        = vpiSysTask;
  systf_data.sysfunctype = 0;
  systf_data.tfname      = "$vga_row";
  systf_data.calltf      = row;
  systf_data.compiletf   = 0;
  systf_data.sizetf      = 0;
  systf_data.user_data   = 0;
  systf_handle = vpi_register_systf( &systf_data );
  vpi_free_object( systf_handle );

  systf_data.type        = vpiSysTask;
  systf_data.sysfunctype = 0;
  systf_data.tfname      = "$vga_init";
  systf_data.calltf      = init;
  systf_data.compiletf   = 0;
  systf_data.sizetf      = 0;
  systf_data.user_data   = 0;
  systf_handle = vpi_register_systf( &systf_data );
  vpi_free_object( systf_handle );

}

void (*vlog_startup_routines[])() = {
  vga_register,
  0
};
