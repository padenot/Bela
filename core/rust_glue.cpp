#include <Bela.h>
#include <cmath>

extern "C" {
	bool rs_setup(BelaContext *context, void *userData);
	void rs_render(BelaContext *context, void *userData);
	void rs_cleanup(BelaContext *context, void *userData);
}

bool setup(BelaContext *context, void *userData)
{
  return rs_setup(context, userData);
}

void render(BelaContext *context, void *userData)
{
  rs_render(context, userData);
}

void cleanup(BelaContext *context, void *userData)
{
  rs_cleanup(context, userData);
}
