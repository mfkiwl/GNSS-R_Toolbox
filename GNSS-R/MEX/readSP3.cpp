#include "stdafx.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "SNR.h"

/* read SP3 Header -----------------------------------------------------------*/
void readSP3FileHeader(const char *file, int *sp3Const)
{
	FILE *fp;
	if ((fp = fopen(file, "rt")) == NULL) printf("error in SP3 fileheader read\n");
	char line[400];
	fgets(line, 400, fp);
	do
	{
		/*year month day first line*/
		if (strncmp(&line[0], "#", 1) == 0 && strncmp(&line[0], "##", 2) != 0)
		{
			sp3Const[2] = str2int(line, 3, 6);
			sp3Const[3] = str2int(line, 8, 9);
			sp3Const[4] = str2int(line, 11, 12);
		}
		if (strncmp(&line[0], "##", 2) == 0)
		{
			sp3Const[0] = str2int(line, 24, 37);
		}
		if (strncmp(&line[0], "+", 1) == 0 && sp3Const[1] == 0)
		{
			sp3Const[1] = str2int(line, 3, 6);
		}
		fgets(line, MAXRNXLEN, fp);
	} while (strncmp(&line[0], "*  ", 3) != 0);
	fclose(fp);
}

/* read SP3 body -----------------------------------------------------------*/
void readSP3FileBody(const char *file, double *SP3x, double *SP3y, double *SP3z, double *clcBias, int *sp3Const, int ConstSno)
{   /*open O file*/
	FILE *fp;
	if ((fp = fopen(file, "rt")) == NULL) printf("error in SP3 body read\n");
	char line[400];
	/*read Header*/
	do
	{
		fgets(line, 400, fp);
	} while (strncmp(&line[0], "*  ", 3) != 0);

	/*read sp3 body*/
	int year, month, day, hour, minute, second, epno, i, sno;
	double x, y, z, clc;
	int temp = 0;
	do
	{   /*time and epoch*/
		if (strncmp(&line[0], "*  ", 3) == 0)
		{   
			year = str2int(line, 3, 6);
			month = str2int(line, 8, 9);
			day = str2int(line, 11, 12);
			hour = str2int(line, 14, 15);
			minute = str2int(line, 17, 18);
			second = str2int(line, 20, 21);

			if (year != sp3Const[2] && month != sp3Const[3] && day != sp3Const[4])
			{
				continue;
			}
			epno = (hour * 3600 + minute * 60 + second) / sp3Const[0];
			//printf("%d\n", epno);
			//printf("num of epno:%d\n", ++temp);
		}
		/*obs body*/
		for (i = 0; i < sp3Const[1]; i++)
		{
			fgets(line, MAXRNXLEN, fp);
			/*-------------GPS-------------*/
			if ((strncmp(&line[1], "G", 1) == 0))
			{
				sno = str2int(line,2,3);
				if (sno > 32)
				{
					continue;
				}
				else
				{   /*millimeters*/
					x = str2num(line, 5, 18);
					y = str2num(line, 19, 32);
					z = str2num(line, 33, 46);
					clc = str2num(line, 47, 60);
					/*metters*/
					SP3x[epno * ConstSno + sno - 1] = x * 1000;
					SP3y[epno * ConstSno + sno - 1] = y * 1000;
					SP3z[epno * ConstSno + sno - 1] = z * 1000;
					/*seconds*/
					clcBias[epno * ConstSno + sno - 1] = clc *  (1e-6);
				}
			}
			/*-------------GPS-------------*/

			/*-------------GLO-------------*/
			if ((strncmp(&line[1], "R", 1) == 0))
			{
				sno = 32 + str2int(line, 2, 3);
				if (sno > 58)
				{
					continue;
				}
				else
				{   /*millimeters*/
					x = str2num(line, 5, 18);
					y = str2num(line, 19, 32);
					z = str2num(line, 33, 46);
					clc = str2num(line, 47, 60);
					/*metters*/
					SP3x[epno * ConstSno + sno - 1] = x * 1000;
					SP3y[epno * ConstSno + sno - 1] = y * 1000;
					SP3z[epno * ConstSno + sno - 1] = z * 1000;
					/*seconds*/
					clcBias[epno * ConstSno + sno - 1] = clc *  (1e-6);
				}
			}
			/*-------------GLO-------------*/

			/*-------------GAL-------------*/
			if ((strncmp(&line[1], "E", 1) == 0))
			{
				sno = 58 + str2int(line, 2, 3);
				if (sno > 94)
				{
					continue;
				}
				else
				{   /*millimeters*/
					x = str2int(line, 5, 18);
					y = str2int(line, 19, 32);
					z = str2int(line, 33, 46);
					clc = str2int(line, 47, 60);
					/*metters*/
					SP3x[epno * ConstSno + sno - 1] = x * 1000;
					SP3y[epno * ConstSno + sno - 1] = y * 1000;
					SP3z[epno * ConstSno + sno - 1] = z * 1000;
					/*seconds*/
					clcBias[epno * ConstSno + sno - 1] = clc *  (1e-6);
				}
			}
			/*-------------GAL-------------*/

			/*-------------GAL-------------*/
			if ((strncmp(&line[1], "C", 1) == 0))
			{
				sno = 94 + str2int(line, 2, 3);
				if (sno > ConstSno)
				{
					continue;
				}
				else
				{   /*millimeters*/
					x = str2num(line, 5, 18);
					y = str2num(line, 19, 32);
					z = str2num(line, 33, 46);
					clc = str2num(line, 47, 60);
					/*metters*/
					SP3x[epno * ConstSno + sno - 1] = x * 1000;
					SP3y[epno * ConstSno + sno - 1] = y * 1000;
					SP3z[epno * ConstSno + sno - 1] = z * 1000;
					/*seconds*/
					clcBias[epno * ConstSno + sno - 1] = clc *  (1e-6);
				}
			}
			/*-------------GAL-------------*/

			/*-------------GAL-------------*/
			if ((strncmp(&line[1], "G", 1) != 0) && (strncmp(&line[1], "R", 1) != 0)
				&& (strncmp(&line[1], "E", 1) != 0) && (strncmp(&line[1], "C", 1) != 0))
			{
				continue;
			}
			/*-------------GAL-------------*/
		}
		fgets(line, 400, fp);

	} while (strncmp(&line[0], "EOF", 3) != 0);
	fclose(fp);
}
