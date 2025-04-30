#include "mex.h"
#include "stdafx.h"
#include "SNR.h"
#include <omp.h>

void snr( char *input_buf )
{
	char Listline1[100], Listline4[100], Listline5[100], Listline6[100], Listline3[100];
	char ObsList[1200][100], AftList[1200][100], BefList[1200][100], NowList[1200][100], OutList[1200][100];
	FILE *fp1, *fp4, *fp5, *fp6, *fp3, *fpconfig;

	char* Path = input_buf;
	//filepath = input_buf;


	//string filename1 = "/obsFile.txt";
	//string filename4 = "/anavFile.txt";
	//string filename5 = "/bnavFile.txt";
	//string filename6 = "/nnavFile.txt";
	//string filename3 = "/outFile.txt";


	//string filepath1 = filepath + filename1;
	//string filepath4 = filepath + filename4;
	//string filepath5 = filepath + filename5;
	//string filepath6 = filepath + filename6;
	//string filepath3 = filepath + filename3;

	//char* ListFile1 = const_cast<char*>(filepath1.c_str());
	//char* ListFile4 = const_cast<char*>(filepath4.c_str());
	//char* ListFile5 = const_cast<char*>(filepath5.c_str());
	//char* ListFile6 = const_cast<char*>(filepath6.c_str());
	//char* ListFile3 = const_cast<char*>(filepath3.c_str());


	char *ListFile11 = "obsFile.txt";
	char *ListFile41 = "anavFile.txt";
    char *ListFile51 = "bnavFile.txt";
    char *ListFile61 = "nnavFile.txt";
    char *ListFile31 = "outFile.txt";

	int filelen1 = strlen(ListFile11) + strlen(Path) + 1;
	int filelen4 = strlen(ListFile41) + strlen(Path) + 1;
	int filelen5 = strlen(ListFile51) + strlen(Path) + 1;
	int filelen6 = strlen(ListFile61) + strlen(Path) + 1;
	int filelen3 = strlen(ListFile31) + strlen(Path) + 1;

	char *ListFile1 = (char*)malloc(filelen1 * sizeof(char));
	strcpy(ListFile1, Path);
	strcat(ListFile1, ListFile11);

	char* ListFile4 = (char*)malloc(filelen4 * sizeof(char));
	strcpy(ListFile4, Path);
	strcat(ListFile4, ListFile41);

	char* ListFile5 = (char*)malloc(filelen5 * sizeof(char));
	strcpy(ListFile5, Path);
	strcat(ListFile5, ListFile51);

	char* ListFile6 = (char*)malloc(filelen6 * sizeof(char));
	strcpy(ListFile6, Path);
	strcat(ListFile6, ListFile61);

	char* ListFile3 = (char*)malloc(filelen3 * sizeof(char));
	strcpy(ListFile3, Path);
	strcat(ListFile3, ListFile31);

	//char *ListFile1 = "../obsFile.txt";

	//char *ListFile4 = "../anavFile.txt";
	//char *ListFile5 = "../bnavFile.txt";
	//char *ListFile6 = "../nnavFile.txt";

	//char *ListFile3 = "../outFile.txt";

	if ((fp1 = fopen(ListFile1, "rt")) == NULL) printf("error in obs file\n");

	if ((fp4 = fopen(ListFile4, "rt")) == NULL) printf("error in nav file\n");
	if ((fp5 = fopen(ListFile5, "rt")) == NULL) printf("error in nav file\n");
	if ((fp6 = fopen(ListFile6, "rt")) == NULL) printf("error in nav file\n");

	if ((fp3 = fopen(ListFile3, "rt")) == NULL) printf("error in out file\n");

	/*****************************/
	int lenOfList = 0;
	do
	{
		fgets(Listline1, sizeof(Listline1), fp1);
		strcpy(ObsList[lenOfList], Listline1);

		fgets(Listline4, sizeof(Listline4), fp4);
		strcpy(AftList[lenOfList], Listline4);
		fgets(Listline5, sizeof(Listline5), fp5);
		strcpy(BefList[lenOfList], Listline5);
		fgets(Listline6, sizeof(Listline6), fp6);
		strcpy(NowList[lenOfList], Listline6);
		
		fgets(Listline3, sizeof(Listline3), fp3);
		strcpy(OutList[lenOfList], Listline3);

		lenOfList++;
		if (Listline1 == NULL || Listline4 == NULL || Listline3 == NULL)
		{
			//printf("fileList is over\n");
			break;
		}
	} while (strcmp(Listline1, "end") != 0);
	fclose(fp1); fclose(fp4); fclose(fp5); fclose(fp6); fclose(fp3);
	/******************************/

	// confuguration files
	char* configfilename = "GNSSR.par";
	char GtypeList[256]; char RtypeList[256]; char EtypeList[256]; char CtypeList[256];
	int configfilelen = strlen(configfilename) + strlen(Path) + 1;

	char* configfilepath = (char*)malloc(configfilelen * sizeof(char));

	strcpy(configfilepath, Path);
	strcat(configfilepath, configfilename);

	if ((fpconfig = fopen(configfilepath, "rt")) == NULL) printf("error in configuration file\n");

	if (fpconfig != NULL) {
		fgets(GtypeList, sizeof(GtypeList), fpconfig);
		fgets(RtypeList, sizeof(RtypeList), fpconfig);
		fgets(EtypeList, sizeof(EtypeList), fpconfig);
		fgets(CtypeList, sizeof(CtypeList), fpconfig);
		fclose(fpconfig);
	}
	else {
		perror("Error opening file");
	}




//#pragma omp parallel for num_threads(3)
#pragma omp parallel for
	for (int iOfList = 0; iOfList < lenOfList - 1; iOfList++)
	{
		double pos[3], *Lamda1, *Lamda2;
		char *file, *asp3File, *nsp3File, *bsp3File, *sp3File, *outFile;
		file = ObsList[iOfList];
		file[strlen(file) - 1] = 0;

		asp3File = AftList[iOfList];
		asp3File[strlen(asp3File) - 1] = 0;
		bsp3File = BefList[iOfList];
		bsp3File[strlen(bsp3File) - 1] = 0;
		nsp3File = NowList[iOfList];
		nsp3File[strlen(nsp3File) - 1] = 0;
		sp3File = nsp3File;

		outFile = OutList[iOfList];
		outFile[strlen(outFile) - 1] = 0;
		int *st;
		
		int myconst[6] = { 0, 0, 0, 0, 0, 0 }, max = 0, row = 0, col = 0, totalSize = 0, kOFGLO[24];
		double * eps;
		/*number of obs*/
		int ListNum = 17;
		int	seqGPS[17] = { -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 },
			seqGLO[17] = { -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 },
			seqGAL[17] = { -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 },
			seqBDS[17] = { -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 };

		//char *GtypeList = "S1C S1W S2W S2L S5Q L1C L2W xxx xxx xxx C1C C2W xxx xxx xxx C1C C2W ",
		//	 *RtypeList = "S1C S1P S2P S2C xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx C1C C2C ",
		//	 *EtypeList = "S1X S5X S7X S8X S6X xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx C1X C5X ",
		//	 *CtypeList = "S1X S5X S2I S7I S6I xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx C1X C5X ";


		//char* GtypeList = "S1  S2  S5  xxx xxx L1  L2  L5  xxx xxx C1  C2  xxx xxx xxx C1  C2  ",
		//	* RtypeList = "S1  S2  S5  xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx C1  C2  ",
		//	* EtypeList = "S1  S5  S6  S7  S8  xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx C1  C5  ",
		//	* CtypeList = "S1  S2  S5  xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx C1  C5  ";

		/*read obs header*/		
		readObsHeader(file, seqGPS, seqGLO, seqGAL, seqBDS, myconst, max, pos, kOFGLO, GtypeList, RtypeList, EtypeList, CtypeList, ListNum);
		max = myconst[4];
		int sno = 160;
		double* obs1, * obs2, * obs3, * obs4, * obs5, * obs6, * obs7, * obs8, * obs9, * obs10, * obs11, * obs12, * obs13, * obs14, * obs15, * p1s, * p2s;
		obs1 = new double[max*sno](); obs2 = new double[max*sno](); obs3 = new double[max*sno](); obs4 = new double[max*sno](); obs5 = new double[max * sno]();
		obs6 = new double[max * sno](); obs7 = new double[max * sno](); obs8 = new double[max * sno](); obs9 = new double[max * sno](); obs10 = new double[max * sno]();
		obs11 = new double[max * sno](); obs12 = new double[max * sno](); obs13 = new double[max * sno](); obs14 = new double[max * sno](); obs15 = new double[max * sno]();
		p1s = new double[max*sno](); p2s = new double[max*sno](); eps = new double[max]();
		st = new int[max*sno]();
		/*read obs body*/
		printf("%s is processing \n", file);
		readObsFileBody(file, seqGPS, seqGLO, seqGAL, seqBDS, myconst, eps, obs1, obs2, obs3, obs4, obs5, obs6, obs7, obs8, obs9, obs10, obs11, obs12, obs13, obs14, obs15, p1s, p2s, st, sno);

		/*read sp3 Header*/
		/*after*/
		int asp3Const[5];
		asp3Const[0] = 0; asp3Const[1] = 0; asp3Const[2] = 0; asp3Const[3] = 0; asp3Const[4] = 0;
		/* sp3Const[5] 0-5:SP3int, numOfSat, year, month, day*/
		int asp3Epno;
		readSP3FileHeader(asp3File, asp3Const);
		asp3Epno = 86400 / asp3Const[0] + 10;
		/*now*/
		int nsp3Const[5];
		nsp3Const[0] = 0; nsp3Const[1] = 0; nsp3Const[2] = 0; nsp3Const[3] = 0; nsp3Const[4] = 0;
		/* sp3Const[5] 0-5:SP3int, numOfSat, year, month, day*/
		int nsp3Epno;
		readSP3FileHeader(nsp3File, nsp3Const);
		nsp3Epno = 86400 / nsp3Const[0] + 10;
		/*before*/
		int bsp3Const[5];
		bsp3Const[0] = 0; bsp3Const[1] = 0; bsp3Const[2] = 0; bsp3Const[3] = 0; bsp3Const[4] = 0;
		/* sp3Const[5] 0-5:SP3int, numOfSat, year, month, day*/
		int bsp3Epno;
		readSP3FileHeader(bsp3File, bsp3Const);
		bsp3Epno = 86400 / bsp3Const[0] + 10;
		/*vercat*/
		int sp3Const[5];
		sp3Const[0] = 0; sp3Const[1] = 0; sp3Const[2] = 0; sp3Const[3] = 0; sp3Const[4] = 0;
		int sp3Epno;
		readSP3FileHeader(sp3File, sp3Const);
		sp3Epno = 86400 / sp3Const[0] + 10;


		/*read sp3 body*/
		/*after*/
		double *aSP3x, *aSP3y, *aSP3z, *aclcBias;
		aSP3x = new double[asp3Epno*sno]();
		aSP3y = new double[asp3Epno*sno]();
		aSP3z = new double[asp3Epno*sno]();
		aclcBias = new double[asp3Epno*sno]();
		readSP3FileBody(asp3File, aSP3x, aSP3y, aSP3z, aclcBias, asp3Const, sno);
		/*now*/
		double *nSP3x, *nSP3y, *nSP3z, *nclcBias;
		nSP3x = new double[nsp3Epno*sno]();
		nSP3y = new double[nsp3Epno*sno]();
		nSP3z = new double[nsp3Epno*sno]();
		nclcBias = new double[nsp3Epno*sno]();
		readSP3FileBody(nsp3File, nSP3x, nSP3y, nSP3z, nclcBias, nsp3Const, sno);
		/*before*/
		double *bSP3x, *bSP3y, *bSP3z, *bclcBias;
		bSP3x = new double[bsp3Epno*sno]();
		bSP3y = new double[bsp3Epno*sno]();
		bSP3z = new double[bsp3Epno*sno]();
		bclcBias = new double[bsp3Epno*sno]();
		readSP3FileBody(bsp3File, bSP3x, bSP3y, bSP3z, bclcBias, bsp3Const, sno);

		/*vercat*/
		double *SP3x, *SP3y, *SP3z, *clcBias;
		SP3x = new double[sp3Epno*sno]();
		SP3y = new double[sp3Epno*sno]();
		SP3z = new double[sp3Epno*sno]();
		clcBias = new double[sp3Epno*sno]();

		for (int sp3i = 0; sp3i < sp3Epno; sp3i++)
		{
			for (int sp3j = 0; sp3j < sno; sp3j++)
			{
				if (sp3i < 5)
				{
					SP3x[sp3i*sno + sp3j] = bSP3x[(sp3i + bsp3Epno - 15)*sno + sp3j];
					SP3y[sp3i*sno + sp3j] = bSP3y[(sp3i + bsp3Epno - 15)*sno + sp3j];
					SP3z[sp3i*sno + sp3j] = bSP3z[(sp3i + bsp3Epno - 15)*sno + sp3j];
					clcBias[sp3i*sno + sp3j] = bclcBias[(sp3i + bsp3Epno - 15)*sno + sp3j];
				}
				else if (sp3i >= sp3Epno - 5)
				{
					SP3x[sp3i*sno + sp3j] = aSP3x[(sp3i - asp3Epno + 5)*sno + sp3j];
					SP3y[sp3i*sno + sp3j] = aSP3y[(sp3i - asp3Epno + 5)*sno + sp3j];
					SP3z[sp3i*sno + sp3j] = aSP3z[(sp3i - asp3Epno + 5)*sno + sp3j];
					clcBias[sp3i*sno + sp3j] = aclcBias[sp3i*sno + sp3j];
				}
				else                     
				{
					SP3x[sp3i*sno + sp3j] = nSP3x[(sp3i - 5)*sno + sp3j];
					SP3y[sp3i*sno + sp3j] = nSP3y[(sp3i - 5)*sno + sp3j];
					SP3z[sp3i*sno + sp3j] = nSP3z[(sp3i - 5)*sno + sp3j];
					clcBias[sp3i*sno + sp3j] = nclcBias[(sp3i - 5)*sno + sp3j];
				}
			}

		}


		/*pos of sat*/
		double *tofs, *posX, *posY, *posZ, *posVx, *posVy, *posVz;
		tofs = new double[max*sno]();
		posX = new double[max*sno]();  posY = new double[max*sno]();  posZ = new double[max*sno]();
		posVx = new double[max*sno](); posVy = new double[max*sno](); posVz = new double[max*sno]();
		calSatPos(SP3x, SP3y, SP3z, clcBias, sp3Const, st, pos, tofs, p1s, p2s, eps, max, sno, posX, posY, posZ, posVx, posVy, posVz, sno);


		/*elv and azm*/
		double *elv, *azm;
		elv = new double[max*sno](); azm = new double[max*sno]();
		eleMask(pos, posX, posY, posZ, max, sno, st, elv, azm);
		/*print to outFile*/
		FILE *fp;
		if ((fp = fopen(outFile, "wt")) == NULL) printf("error in outFile write\n");
		for (int i = 0; i < max; i++)
		{
			for (int j = 0; j < sno; j++)
			{
				if (elv[i*sno + j] > 0 && elv[i*sno + j] < 35 && 
					(obs1[i*sno + j] != 0 || obs2[i * sno + j] != 0 || obs3[i * sno + j] != 0 || obs4[i * sno + j] != 0 || obs5[i * sno + j] != 0))
				{
					fprintf(fp, "%6d% 10.3f% 10.3f% 15.7f% 15.2f% 15.2f% 15.2f% 15.2f% 15.2f% 15.2f% 15.2f% 15.2f% 15.2f% 15.2f% 15.2f% 15.2f% 15.2f% 15.2f% 15.2f% \n",
						j + 1, elv[i*sno + j], azm[i*sno + j], eps[i], 
						obs1[i*sno + j],obs2[i*sno + j], obs3[i*sno + j], obs4[i * sno + j], obs5[i * sno + j],
						obs6[i * sno + j], obs7[i * sno + j], obs8[i * sno + j], obs9[i * sno + j], obs10[i * sno + j],
						obs11[i * sno + j], obs12[i * sno + j], obs13[i * sno + j], obs14[i * sno + j], obs15[i * sno + j]);
				}
			}
		}
		fclose(fp);
		printf("%s is processed \n", file);
		/*free the storage*/
		//delete[] eps, L1S, L2S, L2PS, L5S, p1s, p2s, SP3x, SP3y, SP3z, clcBias, tofs, st, aSP3x, aSP3y, aSP3z, aclcBias, bSP3x, bSP3y, bSP3z, bclcBias
		//	, nSP3x, nSP3y, nSP3z, nclcBias, posX, posY, posZ, posVx, posVy, posVz, elv, azm;
		delete[] eps;
		delete[] obs1;
		delete[] obs2; 
		delete[] obs3; 
		delete[] obs4;   delete[] obs5;
		delete[] obs6;  delete[] obs7;  delete[] obs8;    delete[] obs9;   delete[] obs10;
		delete[] obs11;  delete[] obs12;  delete[] obs13;    delete[] obs14;   delete[] obs15;
		delete[] p1s;   delete[] p2s;
		delete[] SP3x; delete[] SP3y; delete[] SP3z; delete[] clcBias; delete[] tofs;  delete[] st;
		delete[] aSP3x; delete[] aSP3y; delete[] aSP3z; delete[] aclcBias;
		delete[] bSP3x; delete[] bSP3y; delete[] bSP3z; delete[] bclcBias;
		delete[] nSP3x; delete[] nSP3y; delete[] nSP3z; delete[] nclcBias;
		delete[] posX; delete[] posY; delete[] posZ; delete[] posVx;   delete[] posVy; delete[] posVz;
		delete[] elv;  delete[] azm;
		sp3Const[0] = 0;  sp3Const[1] = 0;  sp3Const[2] = 0;  sp3Const[3] = 0;  sp3Const[4] = 0;
		nsp3Const[0] = 0; nsp3Const[1] = 0; nsp3Const[2] = 0; nsp3Const[3] = 0; nsp3Const[4] = 0;
		asp3Const[0] = 0; asp3Const[1] = 0; asp3Const[2] = 0; asp3Const[3] = 0; asp3Const[4] = 0;
		bsp3Const[0] = 0; bsp3Const[1] = 0; bsp3Const[2] = 0; bsp3Const[3] = 0; bsp3Const[4] = 0;
	}
	free(ListFile1); free(ListFile4); free(ListFile5); free(ListFile6); free(ListFile3);
}

//%% Input file path
//%% Ensure the configuration file is in the input path
int main() {

    char* filepath = "F:\\GNSSR\\Data\\output\\";
	snr(filepath);

return 0;
}