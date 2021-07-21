#include"PROBESMOD.h"
void PROBETYP::INITPROBE(long int N,long int NV,long int F)
{
    NP=N;
    NVAR=NV;
    FILE=F;
    if(XYZ!=NULL){delete [] XYZ;}
    if(DATA!=NULL){delete [] DATA;}
    XYZ = new double[NP*3];
    DATA = new double[NP*NVAR];
    for(long int i=0; i<NP*3; i++)
    {
        XYZ[i]=0;
    }
    for(long int i=0; i<NP*NVAR; i++)
    {
        DATA[i]=0;
    }
};
