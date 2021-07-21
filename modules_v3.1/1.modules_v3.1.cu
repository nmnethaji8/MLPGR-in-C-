#include<iostream>
#include"modules_v3.1.h"
using namespace std;
PROBESMOD::PROBETYP::PROBETYP():NP(0), NVAR(0), FILE(0),
XYZ(NULL), DATA(NULL){};
void PROBESMOD::PROBETYP::INITPROBE(long int N,long int NV,long int F)
{
    NP=N;
    NVAR=NV;
    FILE=F;
    if(XYZ!=NULL){delete [] XYZ;}
    if(DATA!=NULL){delete [] DATA;}
    XYZ = new double[NP*3]();
    DATA = new double[NP*NVAR]();
}
