#include "stdafx.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "SNR.h"
#include <iostream>

#define COPY(X,n,m,Y) memcpy(Y,(void *)X,(n)*(m)*sizeof(double))


double GetDoubleFromString(char Line[], int Count)
{
	char str[100];
	double val;

	strncpy(str, Line, Count);
	str[Count] = '\0';

	val = atof(str);
	return(val);
}

double GetIntFromString(char Line[], int Count)
{
	char str[100];
	double val;

	strncpy(str, Line, Count);
	str[Count] = '\0';

	val = atoi(str);
	return(val);
}

double str2num(char *s, int i, int n)
{
	char tempS[80];
	double temp;
	int sta = 0;
	for (int j = i; j < i + n; j++)
	{
		tempS[sta++] = s[j];
	}
	tempS[sta++] = '\0';
	temp = atof(tempS);
	return temp;
}

double str2int(char *s, int i, int n)
{
	char tempS[80];
	double temp;
	int sta = 0;
	for (int j = i; j < i + n; j++)
	{
		tempS[sta++] = s[j];
	}
	tempS[sta++] = '\0';
	temp = atoi(tempS);
	return temp;
}

void float2int(double *floatmat, int *intmat)
{
	int i, size;
	size = sizeof(floatmat) / sizeof(double);
	for (i = 0; i < size; i++)
	{
		intmat[i] = int(floatmat[i]);
	}
}

void getTypeseq(char *myTypeName, char *typeList, int *seq, int List, int numofType)
{
	int i = 0, j = 0;
	for (j = 0; j < List; j++)
	{
		for (i = 0; i < numofType; i++)
		{
			if (strncmp(&typeList[j * 4], &myTypeName[i * 4], 3) == 0 && j < 4)
			{
				seq[j] = i;
				i = 0;
				break;
			}
			else if (strncmp(&typeList[j * 4], &myTypeName[i * 4], 3) == 0 && j >= 4)
			{
				seq[j] = i;
				i = 0;
				break;
			}
			else
			{
				seq[j] = -1;
			}
		}
	}
}

void zeroListofObs(double *listObs)
{
	for (int i = 0; i < 30; i++)
	{
		listObs[i] = 0;
	}
}

void getobs(int *seq, double *obs1, double *obs2, double *obs3, double *obs4, double *obs5, 
	double* obs6, double* obs7, double* obs8, double* obs9, double* obs10,
	double* obs11, double* obs12, double* obs13, double* obs14, double* obs15, 
	double *p1s, double *p2s, int *st, double *listofObs, int epno, int k, int sno)
{
	if (seq[0] == -1)
	{
		obs1[epno * sno + k - 1] = 0;
	}
	else
	{
		obs1[epno * sno + k - 1] = listofObs[seq[0]];
	}
	if (seq[1] == -1)
	{
		obs2[epno * sno + k - 1] = 0;
	}
	else
	{
		obs2[epno * sno + k - 1] = listofObs[seq[1]];
	}
	if (seq[2] == -1)
	{
		obs3[epno * sno + k - 1] = 0;
	}
	else
	{
		obs3[epno * sno + k - 1] = listofObs[seq[2]];
	}
	if (seq[3] == -1)
	{
		obs4[epno * sno + k - 1] = 0;
	}
	else
	{
		obs4[epno * sno + k - 1] = listofObs[seq[3]];
	}
	if (seq[4] == -1)
	{
		obs5[epno * sno + k - 1] = 0;
	}
	else
	{
		obs5[epno * sno + k - 1] = listofObs[seq[4]];
	}
	/*****************************************************/
	if (seq[5] == -1)
	{
		obs6[epno * sno + k - 1] = 0;
	}
	else
	{
		obs6[epno * sno + k - 1] = listofObs[seq[5]];
	}
	if (seq[6] == -1)
	{
		obs7[epno * sno + k - 1] = 0;
	}
	else
	{
		obs7[epno * sno + k - 1] = listofObs[seq[6]];
	}
	if (seq[7] == -1)
	{
		obs8[epno * sno + k - 1] = 0;
	}
	else
	{
		obs8[epno * sno + k - 1] = listofObs[seq[7]];
	}
	if (seq[8] == -1)
	{
		obs9[epno * sno + k - 1] = 0;
	}
	else
	{
		obs9[epno * sno + k - 1] = listofObs[seq[8]];
	}
	if (seq[9] == -1)
	{
		obs10[epno * sno + k - 1] = 0;
	}
	else
	{
		obs10[epno * sno + k - 1] = listofObs[seq[9]];
	}
	/*********************************************************/
	if (seq[10] == -1)
	{
		obs11[epno * sno + k - 1] = 0;
	}
	else
	{
		obs11[epno * sno + k - 1] = listofObs[seq[10]];
	}
	if (seq[11] == -1)
	{
		obs12[epno * sno + k - 1] = 0;
	}
	else
	{
		obs12[epno * sno + k - 1] = listofObs[seq[11]];
	}
	if (seq[12] == -1)
	{
		obs13[epno * sno + k - 1] = 0;
	}
	else
	{
		obs13[epno * sno + k - 1] = listofObs[seq[12]];
	}
	if (seq[13] == -1)
	{
		obs14[epno * sno + k - 1] = 0;
	}
	else
	{
		obs14[epno * sno + k - 1] = listofObs[seq[13]];
	}
	if (seq[14] == -1)
	{
		obs15[epno * sno + k - 1] = 0;
	}
	else
	{
		obs15[epno * sno + k - 1] = listofObs[seq[14]];
	}
	/*********************************************************/
	if (seq[15] == -1)
	{
		p1s[epno * sno + k - 1] = 0;
	}
	else
	{
		p1s[epno * sno + k - 1] = listofObs[seq[15]];
	}

	if (seq[16] == -1)
	{
		p2s[epno * sno + k - 1] = 0;
	}
	else
	{
		p2s[epno * sno + k - 1] = listofObs[seq[16]];
	}

	if (seq[15] > -1 && seq[16] > -1)
	{
		st[epno * sno + k - 1] = 1;
	}
	//if (seq[5] > -1 || seq[6] > -1)
	//{
	//	st[epno * sno + k - 1] = 1;
	//}
}

/* read rinex body -----------------------------------------------------------*/
void readObsHeader(const char *file, int *seqGPS, int *seqGLO, int *seqGAL, int *seqBDS, int *myconst, int max, double *pos, int *kOFGLO, 
	char *GtypeList, char *RtypeList, char *EtypeList, char *CtypeList, int ListNum)
{   /*open O file*/
	FILE *fp;
	char sys[2] = "";
	int numofGPS = 0, numofGLO = 0, numofGAL = 0, numofBDS = 0, numofOBS = 0, timeDif;
	char typeOfGPS[160] = "", typeOfGLO[160] = "", typeOfGAL[160] = "", typeOfBDS[160] = "";
	char tempOBS1[160] = "", tempOBS2[240] = "", typeOfOBS[240] = "";
	char temp[512] = "";
	char *typeList;
	if ((fp = fopen(file, "rt")) == NULL) 		printf("error in fileheader read\n");
	char line[400];
	int lno = 0;
	int i, j, List, numofType;
	int interval;
	int starYear, starMonth, starDay, starHour, starMinute, starSecond;
	int endYear, endMonth, endDay, endHour, endMinute, endSecond;
	int startFlag = 0, endFlag = 0, intFlag = 0, typeFlag = 0;
	fgets(line, 400, fp);
	if (strncmp(&line[60], "RINEX VERSION / TYPE", 12) == 0 && strncmp(&line[5], "2", 1) == 0) /* rinex 2 -> 0 rinex 3 -> 1 */
	{
		typeFlag = 0;
	}
	else
	{
		typeFlag = 1;
	}
	do {
		fgets(line, 400, fp);
		if (strncmp(&line[60], "APPROX POSITION XYZ", 12) == 0)
		{
			for (i = 0, j = 0; i < 3; i++, j += 14)
			{
				pos[i] = str2num(line, j, 14);
			}
		}
		if (typeFlag == 1)
		{
			if (strncmp(&line[60], "SYS / # / OBS TYPES", 12) == 0)
			{
				strncpy(sys, line, 1);
				/*GPS type*/
				if (strncmp(sys, "G", 1) == 0)
				{
					numofGPS = str2num(line, 4, 2);
					myconst[0] = numofGPS;
					if (numofGPS > 13)
					{
						strncpy(typeOfGPS, line + 7, 4 * 13);
						fgets(line, 400, fp);
						lno = lno + 1;
						strncpy(temp, line + 7, 4 * (numofGPS - 13));
						strcat(typeOfGPS, temp);
						memset(temp, '\0', sizeof(temp));
					}
					else
					{
						strncpy(typeOfGPS, line + 7, 4 * numofGPS);
					}

					typeList = GtypeList;

					List = ListNum;
					getTypeseq(typeOfGPS, typeList, seqGPS, List, numofGPS);
				}
				/*GLO types*/
				if (strncmp(sys, "R", 1) == 0)
				{
					numofGLO = str2num(line, 4, 2);
					myconst[1] = numofGLO;
					if (numofGLO > 13)
					{
						strncpy(typeOfGLO, line + 7, 4 * 13);
						fgets(line, 400, fp);
						lno = lno + 1;
						strncpy(temp, line + 7, 4 * (numofGLO - 13));
						strcat(typeOfGLO, temp);
						memset(temp, '\0', sizeof(temp));
					}
					else
					{
						strncpy(typeOfGLO, line + 7, 4 * numofGLO);
					}
					//typeList = "S1C S2C S2P XXX C1C C2C ";
					typeList = RtypeList;
					List = ListNum;
					getTypeseq(typeOfGLO, typeList, seqGLO, List, numofGLO);
				}
				/*GAL TYPE*/
				if (strncmp(sys, "E", 1) == 0)
				{
					numofGAL = str2num(line, 4, 2);
					myconst[2] = numofGAL;
					if (numofGAL > 13)
					{
						strncpy(typeOfGAL, line + 7, 4 * 13);
						fgets(line, 400, fp);
						lno = lno + 1;
						strncpy(temp, line + 7, 4 * (numofGAL - 13));
						strcat(typeOfGAL, temp);
						memset(temp, '\0', sizeof(temp));
					}
					else
					{
						strncpy(typeOfGAL, line + 7, 4 * numofGAL);
					}
					//typeList = "S5Q S7Q S8Q XXX C1C C5Q ";
					typeList = EtypeList;
					List = ListNum;
					getTypeseq(typeOfGAL, typeList, seqGAL, List, numofGAL);
				}
				/*BDS TYPE*/
				if (strncmp(sys, "C", 1) == 0)
				{
					numofBDS = str2num(line, 4, 2);
					myconst[3] = numofBDS;
					if (numofBDS > 13)
					{
						strncpy(typeOfBDS, line + 7, 4 * 13);
						fgets(line, 400, fp);
						lno = lno + 1;
						strncpy(temp, line + 7, 4 * (numofBDS - 13));
						strcat(typeOfBDS, temp);
						memset(temp, '\0', sizeof(temp));
					}
					else
					{
						strncpy(typeOfBDS, line + 7, 4 * numofBDS);
					}
					//typeList = "S2I S6I S7I XXX C7I C2I ";
					typeList = CtypeList;
					List = ListNum;
					getTypeseq(typeOfBDS, typeList, seqBDS, List, numofBDS);
				}
			}
		}
		else
		{
		if (strncmp(&line[60], "# / TYPES OF OBSERV", 12) == 0)
		{
			numofOBS = str2num(line, 4, 2);
			/* You can also determine the observation type by reading the first epoch */
			myconst[0] = numofOBS; myconst[1] = numofOBS; myconst[2] = numofOBS; myconst[3] = 0;
			int numOfObsLine = ceil(numofOBS / 9);
			if (numofOBS % 9 > 0)
			{
				numOfObsLine = numOfObsLine + 1;
			}
			//if (numOfObsLine == 0)
			//{
			//	strncpy(tempOBS1, line + 10, 54);
			//	memset(tempOBS1 + 50, ' ', sizeof(char) * 4);
			//	strcat(tempOBS2, tempOBS1);
			//	memset(tempOBS1, '\0', sizeof(tempOBS1));
			//}
			for (int i = 0; i < numOfObsLine; i++)
			{
				strncpy(tempOBS1, line + 10, 54);
				memset(tempOBS1 + 50, ' ', sizeof(char) * 4);
				strcat(tempOBS2, tempOBS1);
				memset(tempOBS1, '\0', sizeof(tempOBS1));
				if (i < numOfObsLine - 1)
				{
					fgets(line, 400, fp);
				}
			}
			for (int i = 0; i < numofOBS; i++)
			{
				char tempData[5] = "";
				strncpy(tempData, tempOBS2 + i * 6, 4);
				strcat(typeOfOBS, tempData);
			}
			strcat(typeOfGPS, typeOfOBS); strcat(typeOfGAL, typeOfOBS); strcat(typeOfGLO, typeOfOBS); strcat(typeOfBDS, typeOfOBS);
			getTypeseq(typeOfGPS, GtypeList, seqGPS, ListNum, numofOBS);
			getTypeseq(typeOfGLO, RtypeList, seqGLO, ListNum, numofOBS);
			getTypeseq(typeOfGAL, EtypeList, seqGAL, ListNum, numofOBS);
			getTypeseq(typeOfBDS, CtypeList, seqBDS, ListNum, numofOBS);
		}

		}

		//if (strncmp(&line[60], "GLONASS SLOT / FRQ", 12) == 0)
		//{
		//	for (j = 0; j < 3; j++)
		//	{
		//		for (i = 0; i < 8; i++)
		//		{
		//			kOFGLO[i + j * 8] = str2int(line, 8 + 7 * i, 2);
		//		}
		//		fgets(line, 400, fp);
		//		lno = lno + 1;
		//	}
		//}

		if (strncmp(&line[60], "INTERVAL", 8) == 0)
		{
			interval = str2num(line, 0, 10);
			intFlag = 1;
		}

		if (strncmp(&line[60], "TIME OF FIRST OBS", 12) == 0)
		{
			starYear = str2num(line, 2, 4);
			starMonth = str2num(line, 10, 2);
			starDay = str2num(line, 16, 2);
			starHour = str2num(line, 22, 2);
			starMinute = str2num(line, 28, 2);
			starSecond = str2num(line, 33, 2);
			startFlag = 1;
		}

		if (strncmp(&line[60], "TIME OF LAST OBS", 12) == 0)
		{
			endYear = str2num(line, 2, 4);
			endMonth = str2num(line, 10, 2);
			endDay = str2num(line, 16, 2);
			endHour = str2num(line, 22, 2);
			endMinute = str2num(line, 28, 2);
			endSecond = str2num(line, 33, 2);
			endFlag = 1;
		}

		//if no intervial or start/end of time
		if (endFlag == 0)
		{
			endYear = 0;
			endMonth = 0;
			endDay = 0;
			endHour = 23;
			endMinute = 59;
			endSecond = 59;
		}
		if (startFlag == 0)
		{
			starYear = 0;
			starMonth = 0;
			starDay = 0;
			starHour = 0;
			starMinute = 0;
			starSecond = 0;
		}
		if (intFlag == 0)
		{
			interval = 1;
		}

		timeDif = (endDay - starDay) * 3600 * 24 + (endHour - starHour) * 3600 + (endMinute - starMinute) * 60 + (endSecond - starSecond);
		if (endFlag == 0 && timeDif < 0)
		{
			timeDif = (endHour - starHour) * 3600 + (endMinute - starMinute) * 60 + (endSecond - starSecond);
			myconst[5] = endHour*3600 + endMinute*60 + endSecond;
		}
		max = timeDif / interval + 1;
		myconst[4] = max;
		lno = lno + 1;
	} while (strncmp(&line[60], "END OF HEADER", 12) != 0);
	fclose(fp);
}
