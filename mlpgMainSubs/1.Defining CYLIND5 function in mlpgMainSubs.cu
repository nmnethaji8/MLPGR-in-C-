#include<iostream>
#include<fstream>
#include<string>
#include<math.h>

#include"mlpgMainSubs.h"
#include"modCommon.h"

using namespace std;
using namespace COMMONMOD;

void CYLIND5(string MESHFILE, long int &FSNOD1, long int &FSNOD2,
double *DOMX, double *DOMY, double *DOMZ, double CYLX, double CYLY,
double CYLR, double DDL)
{
    long int MSFL = 101;
    long int FSNODSTART=0, FSNODEND=0, NGHST=0;
    long int IX=0, IY=0, IZ=0;
    long int NODEGETY[2]={0};
    double TMPR1=0, TMPR2=0, TMPR3=0, TMPR4=0, TMPR7=0, RIAV=0;
    double DRMIN=0.0001;
    ifstream meshfile;
    meshfile.open(MESHFILE);

    ofstream mlpgTerOut;
    mlpgTerOut.open("mlpgTerOut.dat", ofstream::app);
    mlpgTerOut << "Entering Cylind3" << endl;
    string skip;
    getline(meshfile,skip);
    //cout << skip << endl;
    for(int i=1; i<=7; i++)
    {
        meshfile >>  NODEID[i];
        mlpgTerOut <<   NODEID[i] << " ";
    }
    mlpgTerOut << endl;
    meshfile.ignore(1,'\n');
    getline(meshfile,skip);
    //cout << skip << endl;
    meshfile >> FSNODSTART >> FSNODEND;
    //cout << FSNODSTART << " "<< FSNODEND << endl;
    meshfile.ignore(1,'\n');
    getline(meshfile,skip);
    //cout << skip << endl;
    meshfile >> FSNOD1;
    //cout << FSNOD1 << endl;
    getline(meshfile,skip);
    //meshfile.ignore(1,'\n');
    meshfile >> FSNOD2;
    //cout << FSNOD2 << endl;
    getline(meshfile,skip);
    //meshfile.ignore(1,'\n');
    getline(meshfile,skip);
    //cout << skip << endl;

    //Reading fluid and freesurface nodes

    for(long int i=0; i< NODEID[2]; i++)
    {
        meshfile >>  COORX[i] >>  COORY[i]
        >>  COORZ[i] >>  SNX[i] >>  SNY[i]
        >>  SNZ[i] >>  SMX[i] >>  SMY[i]
        >>  SMZ[i] >>  SSX[i] >>  SSY[i]
        >>  SSZ[i] >> NODEGETY[0] >> NODEGETY[1];
         NODEID2[i]=0;
    }

    /*for(long int i=0; i< NODEID[2]; i++)
    {
        output <<  COORX[i] << " " <<  COORY[i] << " "
        <<  COORZ[i] << " " <<  SNX[i] << " " <<  SNY[i]
        << " " <<  SNZ[i] << " " <<  SMX[i] << " " <<  SMY[i]
        << " " <<  SMZ[i] << " " <<  SSX[i] << " " <<  SSY[i]
        << " " <<  SSZ[i] << " " << NODEGETY[0] << " " << NODEGETY[1]
        << endl;
    }*/
    for(long int i=FSNODSTART-1; i<FSNODEND; i++)
    {
         NODEID2[i]=4;
    }

    //Wavemaker nodes
    
    for(long int i= NODEID[2]; i< NODEID[3]; i++)
    {
        meshfile >>  COORX[i] >>  COORY[i]
        >>  COORZ[i] >>  SNX[i] >>  SNY[i]
        >>  SNZ[i] >>  SMX[i] >>  SMY[i]
        >>  SMZ[i] >>  SSX[i] >>  SSY[i]
        >>  SSZ[i] >> NODEGETY[0] >> NODEGETY[1];

        /*output <<  COORX[i] << " " <<  COORY[i] << " "
        <<  COORZ[i] << " " <<  SNX[i] << " " <<  SNY[i]
        << " " <<  SNZ[i] << " " <<  SMX[i] << " " <<  SMY[i]
        << " " <<  SMZ[i] << " " <<  SSX[i] << " " <<  SSY[i]
        << " " <<  SSZ[i] << " " << NODEGETY[0] << " " << NODEGETY[1]
        << endl;*/

         NODEID2[i]=8;
         NWALLID[i]=2;
         NWALLID[1* LNODE+i]=1;

        //Top edge of wavemaker
        if (NODEGETY[0]==2)
        {
             NWALLID[1* LNODE+i]=-11;
        }

        //Side edges of wavemaker
        if (NODEGETY[1]==1)
        {
             NWALLID[0* LNODE+i]=7;//Intersection of surfaces
             NWALLID[2* LNODE+i]=9;//SPECIAL NODE FOR PRESSURE EQUATION 
        }

    }

    //Bottom wall nodes
    for(long int i= NODEID[3]; i< NODEID[4]; i++)
    {
        meshfile >>  COORX[i] >>  COORY[i]
        >>  COORZ[i] >>  SNX[i] >>  SNY[i]
        >>  SNZ[i] >>  SMX[i] >>  SMY[i]
        >>  SMZ[i] >>  SSX[i] >>  SSY[i]
        >>  SSZ[i] >> NODEGETY[0] >> NODEGETY[1];

        /*output <<  COORX[i] << " " <<  COORY[i] << " "
        <<  COORZ[i] << " " <<  SNX[i] << " " <<  SNY[i]
        << " " <<  SNZ[i] << " " <<  SMX[i] << " " <<  SMY[i]
        << " " <<  SMZ[i] << " " <<  SSX[i] << " " <<  SSY[i]
        << " " <<  SSZ[i] << " " << NODEGETY[0] << " " << NODEGETY[1]
        << endl;*/

         NODEID2[i]=2;
         NWALLID[1* LNODE+i]=1;
         NWALLID[0* LNODE+i]=1;

        if (NODEGETY[1]==1)
        {
             NWALLID[0* LNODE+i]=7;//Intersection of surfaces
             NWALLID[2* LNODE+i]=9;//SPECIAL NODE FOR PRESSURE EQUATION 
        }
 
    }

    //Opposite wall of wavemaker

    for(long int i= NODEID[4]; i< NODEID[5]; i++)
    {
        meshfile >>  COORX[i] >>  COORY[i]
        >>  COORZ[i] >>  SNX[i] >>  SNY[i]
        >>  SNZ[i] >>  SMX[i] >>  SMY[i]
        >>  SMZ[i] >>  SSX[i] >>  SSY[i]
        >>  SSZ[i] >> NODEGETY[0] >> NODEGETY[1];

        /*output <<  COORX[i] << " " <<  COORY[i] << " "
        <<  COORZ[i] << " " <<  SNX[i] << " " <<  SNY[i]
        << " " <<  SNZ[i] << " " <<  SMX[i] << " " <<  SMY[i]
        << " " <<  SMZ[i] << " " <<  SSX[i] << " " <<  SSY[i]
        << " " <<  SSZ[i] << " " << NODEGETY[0] << " " << NODEGETY[1]
        << endl;*/

         NODEID2[i]=3;
         NWALLID[0* LNODE+i]=2;
         NWALLID[1* LNODE+i]=1;

        //Top edge

        if (NODEGETY[0]==2)
        {
             NWALLID[1* LNODE+i]=-11;//Intersection of surfaces
        }

        //Side edge
        if (NODEGETY[1]==1)
        {
             NWALLID[0* LNODE+i]=7;
             NWALLID[2* LNODE+i]=9;
        }
    }

    //Sidewall Near

    for(long int i= NODEID[5]; i< NODEID[6]; i++)
    {
        meshfile >>  COORX[i] >>  COORY[i]
        >>  COORZ[i] >>  SNX[i] >>  SNY[i]
        >>  SNZ[i] >>  SMX[i] >>  SMY[i]
        >>  SMZ[i] >>  SSX[i] >>  SSY[i]
        >>  SSZ[i] >> NODEGETY[0] >> NODEGETY[1];

        /*output <<  COORX[i] << " " <<  COORY[i] << " "
        <<  COORZ[i] << " " <<  SNX[i] << " " <<  SNY[i]
        << " " <<  SNZ[i] << " " <<  SMX[i] << " " <<  SMY[i]
        << " " <<  SMZ[i] << " " <<  SSX[i] << " " <<  SSY[i]
        << " " <<  SSZ[i] << " " << NODEGETY[0] << " " << NODEGETY[1]
        << endl;*/

         NODEID2[i]=1;
         NWALLID[1* LNODE+i]=1;
         NWALLID[0* LNODE+i]=3;

        //Top edge

        if (NODEGETY[0]==2)
        {
             NWALLID[1* LNODE+i]=-11;//Intersection of surfaces
        }
        
    }

        //Sidewall Far

    for(long int i= NODEID[6]; i< NODEID[7]; i++)
    {
        meshfile >>  COORX[i] >>  COORY[i]
        >>  COORZ[i] >>  SNX[i] >>  SNY[i]
        >>  SNZ[i] >>  SMX[i] >>  SMY[i]
        >>  SMZ[i] >>  SSX[i] >>  SSY[i]
        >>  SSZ[i] >> NODEGETY[0] >> NODEGETY[1];

         NODEID2[i]=7;
         NWALLID[1* LNODE+i]=1;
         NWALLID[0* LNODE+i]=3;

        //Top edge

        if (NODEGETY[0]==2)
        {
             NWALLID[1* LNODE+i]=-11;//Intersection of surfaces
        }

    }

    //Cylinder Nodes
    for(long int i= NODEID[7]; i< NODEID[1]; i++)
    {
        meshfile >>  COORX[i] >>  COORY[i]
        >>  COORZ[i] >>  SNX[i] >>  SNY[i]
        >>  SNZ[i] >>  SMX[i] >>  SMY[i]
        >>  SMZ[i] >>  SSX[i] >>  SSY[i]
        >>  SSZ[i] >> NODEGETY[0] >> NODEGETY[1];

         NODEID2[i]=9;

        //Bottom edge

        if (NODEGETY[0]==1)
        {
             NWALLID[2* LNODE+i]=9;//Pressure BC ID
        }

        /*output << COORX[i] << " " <<  COORY[i] << " "
        <<  COORZ[i] << " " <<  SNX[i] << " " <<  SNY[i]
        << " " <<  SNZ[i] << " " <<  SMX[i] << " " <<  SMY[i]
        << " " <<  SMZ[i] << " " <<  SSX[i] << " " <<  SSY[i]
        << " " <<  SSZ[i] << " " << NODEGETY[0] << " " << NODEGETY[1]
        << " " <<  NODEID[i+8] << " " <<  NWALLID[2* LNODE+i] << " ";*/
    }
    meshfile.close();

    // Ghost Nodes

    NGHST= NODEID[1]- NODEID[2];
     NODEID[0]= NODEID[1]+NGHST;
    for(long int i= NODEID[2]; i< NODEID[7]; i++)
    {
        long int j=i+ NODEID[1]- NODEID[2];
        if(j+1> NODEID[0])
        {
            mlpgTerOut << " [ERR] CHECK GHOST GENERATE NGHT > NODEID(0)" << endl;
        }
        RIAV = 0.3*DDL; //Keeping this lower than GENERATEGHOST(DDR)
        for(long int k=0; k<3; k++)
        {
             COORX[k* LNODE+j]= COORX[i]+ SNX[i]*RIAV;
             COORY[k* LNODE+j]= COORY[i]+ SNY[i]*RIAV;
             COORZ[k* LNODE+j]= COORZ[i]+ SNZ[i]*RIAV;
        }
         NODEID2[j]=-6;
         NWALLID[1* LNODE+j]=-10;
        /*for(long int k=0; k<3; k++)
        {
            output <<  COORX[k* LNODE+j] << " ";
        }
        for(long int k=0; k<3; k++)
        {
            output <<  COORY[k* LNODE+j] << " ";
        }
        for(long int k=0; k<3; k++)
        {
            output <<  COORZ[k* LNODE+j] << " ";
        }*/
        //output <<  NODEID[j] << " " <<  NWALLID[1* LNODE+j] << endl;
    }
    
    for(long int i= NODEID[7]; i< NODEID[1]; i++)
    {
        //long int j=i+ NODEID[7]+ NODEID[1]- NODEID[2];
        TMPR7=1/DRMIN;
        long int k=0;

        for(k= NODEID[7]; k< NODEID[1]; k++)
        {
            if(k!=i)
            {
                TMPR1= COORX[k]- COORX[i];
                TMPR2= COORY[k]- COORY[i];
                TMPR3= COORZ[k]- COORZ[i];
                TMPR4=sqrt(pow(TMPR1,2)+pow(TMPR2,2)+pow(TMPR3,2));
                if(TMPR4<TMPR7)
                {
                    TMPR7=TMPR4; 
                }
            }
        }
        if(k==0)
        {
            mlpgTerOut << "[ERR] CHECK CYLIND GHOST" << k+1 << endl;
            mlpgTerOut <<  COORX[k] << " " <<  COORY[k] << " " <<  COORZ[k] << endl;
        }
        TMPR7=0.8*TMPR7;
        long int j= NODEID[1]- NODEID[2]+i;
        if(j+1> NODEID[0])
        {
            mlpgTerOut << "[ERR] CHECK GHOST GENERATE NGHT > NODEID[0]" 
            << i << " "<<  NODEID[0] << endl;
        }
         COORX[j]= COORX[i]+ SNX[i]*TMPR7;
         COORY[j]= COORY[i]+ SNY[i]*TMPR7;
         COORZ[j]= COORZ[i];
         NODEID2[j]=-9;
         NWALLID[1* LNODE+j]=-10;
        //cout<< j << endl;
        mlpgTerOut << "[INF] CYL AND GHOST COOR" << endl;
        mlpgTerOut << "[---] " <<  COORX[i] << " " <<  COORY[i]
        << " " <<  COORZ[i] << " " << endl;
        mlpgTerOut << "[---] " <<  COORX[j] << " " <<  COORY[j]
        << " " <<  COORZ[j] << " " << endl;
    }
    mlpgTerOut.close();

    for(long int i=0;i<LNODE;i++)
    {
        COORX[1*LNODE+i]=COORX[i];
        COORY[1*LNODE+i]=COORY[i];
        COORZ[1*LNODE+i]=COORZ[i];
    }

    IX =  (long int)((DOMX[1]-DOMX[2])/DDL);
    IY =  (long int)((DOMY[1]-DOMY[2])/DDL);
    IZ =  (long int)((DOMZ[1]-DOMZ[2])/DDL);

    IXMAX = IX + 20;
    IYMAX = IY + 20;
    IZMAX = IZ + 20;

    //cout << IXMAX << " " << IYMAX << " " <<  IZMAX << " ";
}
