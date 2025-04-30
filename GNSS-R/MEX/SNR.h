#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "stdafx.h"
#include <iostream>
#include <math.h>
#include <cmath>
#include <vector>
using namespace std;

#define COPY(X,n,m,Y) memcpy(Y,(void *)X,(n)*(m)*sizeof(double))
#define MAXRNXLEN  1024
#define c   299792458
#define we  7.2921151467e-5
#define pi  3.14159265359
#define f   1 / 298.257223563;
#define e2  0.006694379990141;
#define rad2deg(agnle) (180/pi) * agnle;
#define FREQ1 = 1.57542e9;
#define FREQ2 = 1.22760e9;
#define FREQ5 = 1.17645e9;
#define FREQ6 = 1.27875e9;
#define FREQ7 = 1.20714e9;
#define FREQ8 = 1.191795e9;
#define FREQ1_GLO = 1.60200e9;
#define DFRQ1_GLO = 0.56250e6;
#define FREQ2_GLO = 1.24600e9;
#define DFRQ2_GLO = 0.43750e6;
#define FREQ3_GLO = 1.202025e9;
#define FREQ1_CMP = 1.561098e9;
#define FREQ2_CMP = 1.20714e9;
#define FREQ3_CMP = 1.26852e9;



extern double GetDoubleFromString(char Line[], int Count);
extern double GetIntFromString(char Line[], int Count);
extern double str2num(char *s, int i, int n);
extern double str2int(char *s, int i, int n);
extern void float2int(double *floatmat, int *intmat);
extern void getTypeseq(char *myTypeName, char *typeList, int *seq, int List, int numofType);
extern void zeroListofObs(double *listObs);
extern void getobs(int* seq, double* obs1, double* obs2, double* obs3, double* obs4, double* obs5,
	double* obs6, double* obs7, double* obs8, double* obs9, double* obs10,
	double* obs11, double* obs12, double* obs13, double* obs14, double* obs15,
	double* p1s, double* p2s, int* st, double* listofObs, int epno, int k, int sno);
extern void readObsHeader(const char* file, int* seqGPS, int* seqGLO, int* seqGAL, int* seqBDS, int* myconst, 
	int max, double* pos, int* kOFGLO, char* GtypeList, char* RtypeList, char* EtypeList, char* CtypeList, int ListNum);

extern void readObsFileBody(const char* file, int* seqGPS, int* seqGLO, int* seqGAL, int* seqBDS, int* myconst,
	double* eps, double* obs1, double* obs2, double* obs3, double* obs4, double* obs5,
	double* obs6, double* obs7, double* obs8, double* obs9, double* obs10,
	double* obs11, double* obs12, double* obs13, double* obs14, double* obs15, double* p1s, double* p2s, int* st, int sno);

extern void readSP3FileHeader(const char *file, int *sp3Const);
extern void readSP3FileBody(const char *file, double *SP3x, double *SP3y, double *SP3z, double *clcBias, int *sp3Const, int ConstSno);

extern void entrp(double *out, double nep, double sp3Int, double *dclk);
extern void entrpOrbit(double *out, double nep, double sp3Int, double *dclk);
extern void copyMat(double *matIn, double *matOut, int n, int start);
extern double lag(double t, double *y);
extern double vel(double t, double *y, double gap);
extern void matslc(double *matIn, double *matOut, int sp3Epno, int sno, int rowOrCol, int select);

extern void rotation(double *out, double *pos, double agnle, double axis);

extern void calSatPos(double *SP3x, double *SP3y, double *SP3z, double *clcBias, int *sp3Const, int *st,
	double *pos, double *tofs, double *p1, double *p2, double *eps, int max, int sno, double *posX,
	double *posY, double *posZ, double *posVx, double *posVy, double *posVz, int ConstSno);

extern void xyz2plh(double *ellp, double *rec);
extern void local(double *azl, double *rec, double *sat, double dopt);
extern void eleMask(double *pos, double *posX, double *posY, double *posZ, int epno, int sn, int *st,
	double *elv, double *azm);
