#include "stdafx.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "SNR.h"
using namespace std;

void rotation(double *out, double *pos, double agnle, double axis)
{
	double rot[9];


	if (agnle == 0)
	{
		printf("Angle and axis should be scalar.");
	}

	if (axis == 1)
	{
		rot[0] = 1;            rot[1] = 0;            rot[2] = 0;
		rot[3] = 0;            rot[4] = cos(agnle);   rot[5] = sin(agnle);
		rot[6] = 0;            rot[7] = -sin(agnle);  rot[8] = cos(agnle);
	}
	if (axis == 2)
	{
		rot[0] = cos(agnle);   rot[1] = 0;            rot[2] = -sin(agnle);
		rot[3] = 0;            rot[4] = 1;            rot[5] = 0;
		rot[6] = sin(agnle);   rot[7] = 0;            rot[8] = cos(agnle);
	}
	if (axis == 3)
	{
		rot[0] = cos(agnle);   rot[1] = sin(agnle);   rot[2] = 0;
		rot[3] = -sin(agnle);  rot[4] = cos(agnle);   rot[5] = 0;
		rot[6] = 0;            rot[7] = 0;            rot[8] = 1;
	}
	for (int i = 0; i < 3; i++)
	{
		out[0+i] = rot[0+i*3] * pos[0] + rot[1+i*3] * pos[1] + rot[2+i*3] * pos[2];
	}
}