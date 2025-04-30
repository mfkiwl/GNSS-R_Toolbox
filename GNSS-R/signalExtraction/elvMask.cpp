#include "stdafx.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "SNR.h"
using namespace std;

void xyz2plh(double *ellp, double *rec)
{
	double lam, p, phi0,e3;
	e3 = 0.006694379990141;
	double a = 6378137.0;
	lam = atan2(rec[1], rec[0]);
	/*mod(lam,2 * pi)*/
	lam = fmod(lam, 2 * pi);
	p = sqrt(rec[0] * rec[0] + rec[1] * rec[1]);

	phi0 = atan(rec[2] / (p*(1 - e3)));

	double N, h, phi, dphi;
	do
	{
		N = a / sqrt(1 - (e3*sin(phi0)*sin(phi0)));
		h = p / cos(phi0) - N;
		phi = atan((rec[2] / p) / (1 - (N / (N + h)*e3)));
		dphi = fabs(phi - phi0);
		if (dphi > 1e-12)
		{
			phi0 = phi;
		}
		else
		{
			break;
		}

		ellp[0] = phi;
		ellp[1] = lam;
		ellp[2] = h;

	} while (true);
}

void local(double *azl, double *rec, double *sat, double dopt)
{
	double los[3], p[3], ellp[3];
	double lenOfsatLink;
	double lat;
	double lon;
	double e[3], n[3], u[3], elev, azim;
	/*vector of sat to rec*/
	los[0] = sat[0] - rec[0];
	los[1] = sat[1] - rec[1];
	los[2] = sat[2] - rec[2];
	/*length of sat-rec link*/
	lenOfsatLink = sqrt(los[0] * los[0] + los[1] * los[1] + los[2] * los[2]);
	p[0] = los[0] / lenOfsatLink;
	p[1] = los[1] / lenOfsatLink;
	p[2] = los[2] / lenOfsatLink;
	xyz2plh(ellp, rec);
	lat = ellp[0];
	lon = ellp[1];
	e[0] = -sin(lon);           e[1] = cos(lon);             e[2] = 0;
	n[0] = -cos(lon)*sin(lat);  n[1] = -sin(lon)*sin(lat);   n[2] = cos(lat);
	u[0] = cos(lon)*cos(lat);   u[1] = sin(lon)*cos(lat);    u[2] = sin(lat);
	elev = (180 / pi) *asin(p[0] * u[0] + p[1] * u[1] + p[2] * u[2]);
	azim = atan2((p[0] * e[0] + p[1] * e[1] + p[2] * e[2]), (p[0] * n[0] + p[1] * n[1] + p[2] * n[2]));
	azim = (180 / pi) *fmod(azim, 2 * pi);
	if (azim<0)
	{
		azim = azim + 360;
	}
	azl[0] = elev;
	azl[1] = azim;
}


void eleMask(double *pos, double *posX, double *posY, double *posZ, int epno, int sn, int *st,
double *elv, double *azm)
{
	double satPos[3];
	double azl[2];
	/*each epoch*/
	for (int i = 0; i < epno; i++)
	{   /*each sat*/
		for (int j = 0; j < sn; j++)
		{   /*is there any record*/
			if (st[i * sn + j] == 1)
			{   /*pos of sat*/
				satPos[0] = posX[i * sn + j];
				satPos[1] = posY[i * sn + j];
				satPos[2] = posZ[i * sn + j];
				local(azl, pos, satPos, 0);
				elv[i * sn + j] = azl[0];
				azm[i * sn + j] = azl[1];
				if (azl[0]<(pi / 180) * 5 || azl[0] > (pi / 180) * 35)
				{
					st[i * sn + j] = 0;
				}
			}/*is there any record*/
		}/*each sat*/
	}/*each epoch*/

}