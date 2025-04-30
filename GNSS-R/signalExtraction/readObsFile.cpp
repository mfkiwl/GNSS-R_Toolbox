#include "stdafx.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "SNR.h"



/* read rinex body -----------------------------------------------------------*/
void readObsFileBody(const char* file, int* seqGPS, int* seqGLO, int* seqGAL, int* seqBDS, int* myconst,
	double* eps, double* obs1, double* obs2, double* obs3, double* obs4, double* obs5,
	double* obs6, double* obs7, double* obs8, double* obs9, double* obs10,
	double* obs11, double* obs12, double* obs13, double* obs14, double* obs15, double* p1s, double* p2s, int* st, int sno)
{   /*open O file*/
	FILE* fp;
	if ((fp = fopen(file, "rt")) == NULL) printf("error in OBS file body read\n");
	char line[MAXRNXLEN];
	char ObsValList[MAXRNXLEN] = "";
	int lno = 0, epno = 0, typeFlag = 0;
	int Flag = 1;
	int year, month, day, hour, minute, NumOfSat;
	double DouNumOfSat;
	double second;
	int SatNumOfEpoch = 0, satNum = 0, obsNum = 0, obsLen = 0, k = 0;
	int onoGPS, onoGLO, onoGAL, onoBDS, max;
	onoGPS = myconst[0]; onoGLO = myconst[1]; onoGAL = myconst[2]; onoBDS = myconst[3]; max = myconst[4];
	double listofGObs[40], listofRObs[440], listofEObs[40], listofCObs[40], listofObs[40];
	int NumOfObs = 0;
	char tempObs[40] = "";
	char ObsList[200] = "";
	if (onoGPS != 0)
	{
		zeroListofObs(listofGObs);
	}
	if (onoGLO != 0)
	{
		zeroListofObs(listofRObs);
	}
	if (onoGAL != 0)
	{
		zeroListofObs(listofEObs);
	}
	if (onoBDS != 0)
	{
		zeroListofObs(listofCObs);
	}


	int len;
	double obsvalue = 0;
	/*read HEADER*/
	fgets(line, MAXRNXLEN, fp);
	if (strncmp(&line[60], "RINEX VERSION / TYPE", 12) == 0 && strncmp(&line[5], "2", 1) == 0) /* rinex 2 -> 0 rinex 3 -> 1 */
	{
		typeFlag = 0;
	}
	else
	{
		typeFlag = 1;
	}
	do {
		fgets(line, MAXRNXLEN, fp);
		if (typeFlag == 0)
		{
			if (strncmp(&line[60],"# / TYPES OF OBSERV",12) == 0)
			{
				NumOfObs = str2num(line, 3, 5);
				for (int i = 0; i < int(NumOfObs/9); i++)
				{
					fgets(line, MAXRNXLEN, fp);
				}
			}
		}
		lno = lno + 1;
	} while (strncmp(&line[60], "END OF HEADER", 12) != 0);
	if (!fgets(line, MAXRNXLEN, fp))
	{
		//printf("s% is over\n", file);
	}
	/*is the end of file?*/
	if (line == NULL)
	{
		//printf("s% is over\n", file);
	}
	/*read body*/
	/* rinex 2 */
	if (typeFlag == 1)
	{
		do {
			/*read body*/
			/*time of epoch*/
			/*************************** 2022/1/18 *******************************/
			year = str2num(line, 2, 4);
			month = str2num(line, 7, 2);
			day = str2num(line, 10, 2);
			hour = str2num(line, 13, 2);
			minute = str2num(line, 16, 2);
			second = str2num(line, 19, 10);
			NumOfSat = str2num(line, 33, 2);
			eps[epno] = 3600 * (double)hour + 60 * (double)minute + second;
			printf("time: %d %d %d %d %d %f num of sat: %d epoch: %d \n", year, month, day, hour, minute, second, NumOfSat, epno + 1);
			do
			{
				if (!fgets(line, MAXRNXLEN, fp))
				{
					//printf("%s is over\n", file);
					break;
				}
				if (line == NULL)
				{
					//printf("%s is over\n", file);
					break;
				}
				/*printf("%s \n", line);*/
				lno = lno + 1;
				//cout << year[epno] << ' '<< day[epno] << ' ' <<hour[epno] << ' '<< minute[epno] << ' ' << second[epno] << endl;
				/*GPS*/
				if (strncmp(&line[0], "G", 1) == 0 && onoGPS != 0)
				{
					k = str2int(line, 1, 2);
					if (k > 32)
					{
						continue;
					}
					len = strlen(line);
					for (obsLen = 4, obsNum = 0; obsLen < len - 1; obsLen = obsLen + 16, obsNum++)
					{
						obsvalue = str2num(line, obsLen, 13);
						if (!obsvalue == 0)
						{
							listofGObs[obsNum] = obsvalue;
						}
					}
					getobs(seqGPS, obs1, obs2, obs3, obs4, obs5, obs6, obs7, obs8, obs9, obs10, obs11, obs12, obs13, obs14, obs15, p1s, p2s, st, listofGObs, epno, k, sno);
					zeroListofObs(listofGObs);
				}
				else if (strncmp(&line[0], "R", 1) == 0 && onoGLO != 0)
				{
					k = 32 + str2int(line, 1, 2);
					if (k > 58)
					{
						continue;
					}
					len = strlen(line);
					for (obsLen = 4, obsNum = 0; obsLen < len - 1; obsLen = obsLen + 16, obsNum++)
					{
						obsvalue = str2num(line, obsLen, 13);
						if (!obsvalue == 0)
						{
							listofRObs[obsNum] = obsvalue;
						}
					}
					getobs(seqGLO, obs1, obs2, obs3, obs4, obs5, obs6, obs7, obs8, obs9, obs10, obs11, obs12, obs13, obs14, obs15, p1s, p2s, st, listofRObs, epno, k, sno);
					zeroListofObs(listofRObs);
				}
				else if (strncmp(&line[0], "E", 1) == 0 && onoGAL != 0)
				{
					k = 58 + str2int(line, 1, 2);
					if (k > 94)
					{
						continue;
					}
					len = strlen(line);
					for (obsLen = 4, obsNum = 0; obsLen < len - 1; obsLen = obsLen + 16, obsNum++)
					{
						obsvalue = str2num(line, obsLen, 13);
						if (!obsvalue == 0)
						{
							listofEObs[obsNum] = obsvalue;
						}
					}
					getobs(seqGAL, obs1, obs2, obs3, obs4, obs5, obs6, obs7, obs8, obs9, obs10, obs11, obs12, obs13, obs14, obs15, p1s, p2s, st, listofEObs, epno, k, sno);
					zeroListofObs(listofEObs);
				}
				else if (strncmp(&line[0], "C", 1) == 0 && onoBDS != 0)
				{
					k = 94 + str2int(line, 1, 2);
					if (k == (94 + 130))
					{
						k = 94 + 62;
					}
					if (k == (94 + 143))
					{
						k = 94 + 63;
					}
					if (k == (94 + 144))
					{
						k = 94 + 64;
					}
					if (k > 160)
					{
						continue;
					}
					len = strlen(line);
					for (obsLen = 4, obsNum = 0; obsLen < len - 1; obsLen = obsLen + 16, obsNum++)
					{
						obsvalue = str2num(line, obsLen, 13);
						if (!obsvalue == 0)
						{
							listofCObs[obsNum] = obsvalue;
						}
					}
					getobs(seqBDS, obs1, obs2, obs3, obs4, obs5, obs6, obs7, obs8, obs9, obs10, obs11, obs12, obs13, obs14, obs15, p1s, p2s, st, listofCObs, epno, k, sno);
					zeroListofObs(listofCObs);
				} /*end of one observation*/

			} while (strncmp(&line[0], ">", 1) != 0);
			epno++;
			if (max == epno)
			{
				break;
			}
		} while (!feof(fp)); /*end of file*/
	}
	/* rinex 2 */
	else
	{
		do
		{
			/*read body*/
			/*time of epoch*/
			/* read body header */
			year = str2num(line, 1, 2) + 2000;
			month = str2num(line, 4, 2);
			day = str2num(line, 7, 2);
			hour = str2num(line, 10, 2);
			minute = str2num(line, 13, 2);
			second = str2num(line, 16, 10);
			NumOfSat = str2num(line, 30, 2);
			DouNumOfSat = str2num(line, 30, 2);
			eps[epno] = 3600 * (double)hour + 60 * (double)minute + second;
			memset(ObsList, '\0', sizeof(ObsList));
			/* Obs List */
			if (NumOfSat < 12)
			{
				strncpy(tempObs, line + 32, 36);
				strcat(ObsList, tempObs);
			}
			else
			{
				for (int i = 0; i < int(NumOfSat / 12) + 1; i++)
				{
					strncpy(tempObs, line + 32, 36);
					strcat(ObsList, tempObs);
					if (i < ceil(double(DouNumOfSat / 12.0)) - 1)
					{
						fgets(line, MAXRNXLEN, fp);
					}
					else
					{
						break;
					}
				}
			}
			//printf("time: %6f ; epoch: %d \n", eps[epno], epno + 1);
			//printf("time: %4d %2d %2d %2d %3d %3f  num of sat: %d epoch: %d Line: %f \n", year, month, day, hour, minute, second, NumOfSat, epno, ceil(double(DouNumOfSat / 12.0)) - 1);
			/* read obs body */
			for (int i = 0; i < NumOfSat; i++)
			{
				memset(ObsValList, '\0', sizeof(ObsValList));
				/* PRN */
				char ObsType[4] = "";
				strncpy(ObsType, ObsList + 3 * i, 3);
				if (strncmp(ObsType, "G", 1) == 0)
				{
					k = str2int(ObsType, 1, 2);
					if (k > 32)
					{
						continue;
					}
				}
				else if (strncmp(ObsType, "R", 1) == 0)
				{
					k = 32 + str2int(ObsType, 1, 2);
					if (k > 58)
					{
						continue;
					}
				}
				else if (strncmp(ObsType, "E", 1) == 0)
				{
					k = 58 + str2int(ObsType, 1, 2);
					if (k > 94)
					{
						continue;
					}
				}
				else if (strncmp(ObsType, "C", 1) == 0)
				{
					k = 94 + str2int(ObsType, 1, 2);
					if (k == (94 + 130))
					{
						k = 94 + 62;
					}
					if (k == (94 + 143))
					{
						k = 94 + 63;
					}
					if (k == (94 + 144))
					{
						k = 94 + 64;
					}
					if (k > 160)
					{
						continue;
					}
				}
				else
				{
					k = -1;
				}

				/* Obs of each satellite of each epoch */
				char tempObsVal[100] = "";
				for (int j = 0; j < double(NumOfObs / 5) + 1; j++)
				{
					/* obs values */
					fgets(line, MAXRNXLEN, fp);
					strncpy(tempObsVal, line, 80);
					memset(tempObsVal + strlen(tempObsVal) - 1, ' ', sizeof(char)*(81 - strlen(tempObsVal)));
					strcat(ObsValList, tempObsVal);
					memset(tempObsVal, '\0', sizeof(tempObsVal));
				}

				/* put the obs into the struct */
				zeroListofObs(listofObs);
				len = strlen(ObsValList);
				for (obsLen = 0, obsNum = 0; obsLen < len - 1; obsLen = obsLen + 16, obsNum++)
				{
					obsvalue = str2num(ObsValList, obsLen, 14);
					if (obsvalue > 0 )
					{
						listofObs[obsNum] = obsvalue;
					}
				}
				if (0 < k && k <= 32)
				{
					getobs(seqGPS, obs1, obs2, obs3, obs4, obs5, obs6, obs7, obs8, obs9, obs10, obs11, obs12, obs13, obs14, obs15, p1s, p2s, st, listofObs, epno, k, sno);
				}
				else if (0 < k && k <= 58)
				{
					getobs(seqGLO, obs1, obs2, obs3, obs4, obs5, obs6, obs7, obs8, obs9, obs10, obs11, obs12, obs13, obs14, obs15, p1s, p2s, st, listofObs, epno, k, sno);
				}
				else if (0 < k && k <= 94)
				{
					getobs(seqGAL, obs1, obs2, obs3, obs4, obs5, obs6, obs7, obs8, obs9, obs10, obs11, obs12, obs13, obs14, obs15, p1s, p2s, st, listofObs, epno, k, sno);
				}
				else if (0 < k && k > 94)
				{
					getobs(seqBDS, obs1, obs2, obs3, obs4, obs5, obs6, obs7, obs8, obs9, obs10, obs11, obs12, obs13, obs14, obs15, p1s, p2s, st, listofObs, epno, k, sno);
				}

			}

			fgets(line, MAXRNXLEN, fp);
			epno++;
			if (max == epno || eps[epno] >= myconst[5])
			{
				break;
			}
		} while (!feof(fp));
	}
	fclose(fp);
}
