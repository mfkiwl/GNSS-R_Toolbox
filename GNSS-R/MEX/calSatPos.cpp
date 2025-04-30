#include "stdafx.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "SNR.h"
using namespace std;

void copyMat(double *matIn, double *matOut, int n, int start)
{
	for (int i = 0; i < n + 1; i++)
	{
		matOut[i] = matIn[i + start];
	}
}

void matslc(double *matIn, double *matOut, int sp3Epno, int sno, int rowOrCol, int select)
{
	if (rowOrCol == 1)/*select as col*/
	{
		for (int j = 0; j < sp3Epno; j++)
		{
			matOut[j] = matIn[j*sno + select];
		}
	}
	else /*select as row*/
	{
		for (int j = 0; j < sno; j++)
		{
			matOut[j] = matIn[select*sno + j];
		}
	}
		
}

void entrp(double *out,  double nep, int sp3Int, double *dclk)
{
	int min, max;
	double n, nt;
	min = 1;
	max = 86400 / sp3Int;
	n = nep / sp3Int + 1;
	double kern[10];
	int st, fn;
	double out1, out2;
	if (n <= min + double(5))
	{
		copyMat(dclk, kern, 9, 0);
		nt = fmod(n ,min + 5);
		out1 = lag(nt, kern);
		out2 = vel(nt, kern, sp3Int);
	}
	else if (n > (max - double(5)))
	{
		copyMat(dclk, kern, 9, max - 10);
		nt = fmod(n, max - 5) + 5;
		out1 = lag(nt, kern);
		out2 = vel(nt, kern, sp3Int);
	}
	else
	{
		st = floorl(n - 1) - 4;
		fn = ceilf(n - 1) + 4;
		copyMat(dclk, kern, fn - st, st - 1);
		nt = fmod(n, 1) + 5;
		out1 = lag(nt, kern);
		out2 = vel(nt, kern, sp3Int);
	}
	out[0] = out1;
	out[1] = out2;
}

void entrpOrbit(double *out, double nep, double sp3Int, double *dclk)
{
	int min, max, st, fn;
	double n, nt;
	double kern[10];
	double out1, out2;
	n = nep / sp3Int + 6;
	st = floorl(n) - 4;
	fn = ceilf(n) + 4;
	copyMat(dclk, kern, fn - st, st - 1);
	//for (int i = 0; i < 10; i++)
	//{
	//	printf("%f\n", kern[i]);
	//}
	nt = fmod(n, 1) + 5;
	out1 = lag(nt, kern);
	out2 = vel(nt, kern, sp3Int);
	out1 = lag(nt, kern);
	out2 = vel(nt, kern, sp3Int);
	out[0] = out1;
	out[1] = out2;
}



void calSatPos(double *SP3x, double *SP3y, double *SP3z, double *clcBias, int *sp3Const, int *st,
	double *pos, double *tofs, double *p1, double *p2, double *eps, int max, int sno, double *posX,
	double *posY, double *posZ, double *posVx, double *posVy, double *posVz, int ConstSno)
{   /* sp3Const[5] 0-5:SP3int, numOfSat, year, month, day*/
	int sp3Int = sp3Const[0];
	int clcInt = sp3Const[0];
	double recX, recY, recZ;
	recX = pos[0];
	recY = pos[1];
	recZ = pos[2];
	int epno = 86400 / sp3Const[0] + 10;
	int satnum = sp3Const[1];
	int i, j;
	double tof = 0, nep = 0, *dclk, dt = 0, out1 = 0, out2 = 0, out[2];
	double *dx, *dy, *dz, *d_clk;
	dx = new double[epno]();
	dy = new double[epno]();
	dz = new double[epno]();
	d_clk = new double[epno]();
	double X = 0, Y = 0, Z = 0, Vx = 0, Vy = 0, Vz = 0;
	double R[3], tf = 0, erAngle = 0, newPos[3];
	/*every epoch and sat*/
	for (i = 0; i < max; i++)
	{
		for (j = 0; j < ConstSno; j++)
		{   /*is there any sat£¿yes->time of transform*/
			if (st[i * ConstSno + j] == 1)
			{   /*is there any p1+p2 observation*/
				if ((p1[i * ConstSno + j] > 1000) & (p2[i * ConstSno + j] > 1000))
				{
					tof = (p1[i * ConstSno + j] + p2[i * ConstSno + j]) / (2 * double(c));
				}
				/*is there any p1 observation*/
				else if (p1[i * ConstSno + j] > 1000)
				{
					tof = p1[i * ConstSno + j] / c;
				}
				/*is there any p1 observation*/
				else if (p2[i * ConstSno + j] > 1000)
				{
					tof = p2[i * ConstSno + j] / c;
				}
				//printf("%d %d \n",i,j);
				if (eps[i] > 86400 || eps[i] < 0)
				{
					st[i * ConstSno + j] = 0;
					continue;
				}
				nep = eps[i] - tof;
				//dclk = clcBias;
				matslc(clcBias, d_clk, epno, sno, 1, j);
				entrp(out, nep, sp3Int, d_clk);
				/*is dt is NaN*/
				dt = out[0];
				if (!isnormal(dt))
				{
					st[i * ConstSno + j] = 0;
					continue;
				}
				nep = nep - dt;
				tofs[i * ConstSno + j] = tof + dt;
				/*dx dy dz*/
				matslc(SP3x, dx, epno, sno, 1, j);
				matslc(SP3y, dy, epno, sno, 1, j);
				matslc(SP3z, dz, epno, sno, 1, j);


				/*X Y Z Vx Vy Vz*/
				entrpOrbit(out, nep, sp3Int, dx);
				X = out[0]; Vx = out[1];
				entrpOrbit(out, nep, sp3Int, dy);
				Y = out[0]; Vy = out[1];
				entrpOrbit(out, nep, sp3Int, dz);
				Z = out[0]; Vz = out[1];
				/*clk*/
				matslc(clcBias, d_clk, epno, sno, 1, j);
				entrp(out, nep, sp3Int, d_clk);
				dt = out[0];
				/*distance between sat and rec*/
				R[0] = X;
				R[1] = Y;
				R[2] = Z;
				(X - recX)*(X - recX) + (Y - recY)*(Y - recY) + (Z - recZ)*(Z - recZ);
				tf = sqrt((X - recX)*(X - recX) + (Y - recY)*(Y - recY) + (Z - recZ)*(Z - recZ)) / c;
				erAngle = tf*we;
				rotation(newPos, R, erAngle, 3);

				/*is pos is NaN*/
				if (!isnormal(newPos[0]) || !isnormal(newPos[1]) || !isnormal(newPos[2]))
				{
					st[i * ConstSno + j] = 0;
				}
				else
				{
					/*result which returned to the main fun*/
					posX[i * ConstSno + j] = newPos[0];
					posY[i * ConstSno + j] = newPos[1];
					posZ[i * ConstSno + j] = newPos[2];
					posVx[i * ConstSno + j] = Vx;
					posVy[i * ConstSno + j] = Vy;
					posVz[i * ConstSno + j] = Vz;
				}
					
			}/*if st[i * ConstSno + j -1] == 1*/
		}/*end of sat*/

	}/*end of epoch*/

	delete[] dx; delete[] dy; delete[] dz; delete[] d_clk;
}/*end of fun*/