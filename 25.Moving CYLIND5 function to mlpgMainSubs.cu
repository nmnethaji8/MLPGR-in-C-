#include<iostream>
#include<fstream>
#include<string>
#include<vector>
#include<math.h>

#include"modules_v3.1.h"
#include"fnptCoupling.h"
#include"modCommon.h"
#include"nodelinkNew_v2.3.h"
#include"mlpgMainSubs.h"

using namespace std;
using namespace PROBESMOD;
using namespace FNPTCPLMOD;
using namespace COMMONMOD;
using namespace NODELINKMOD;

void NODEGRID(string MESHFILE, long int &FSNOD1, long int &FSNOD2,
double *DOMX, double *DOMY, double *DOMZ, double CYLX, double CYLY,
double CYLR, double DDL )
{
    long int I, J, NGHST, IEND;
    CYLIND5(MESHFILE, FSNOD1, FSNOD2, DOMX, DOMY, DOMZ, 
    CYLX, CYLY, CYLR, DDL);

    ofstream mlpgTerOut;
    mlpgTerOut.open("mlpgTerOut.dat", ofstream::app);
    mlpgTerOut << "TOTAL WATER PARTICLE NUMBER IS,\t" << NODEID[2] << endl;
    mlpgTerOut << "TOTAL WATERANDINNER WALL PARTICLE NUMBER,\t" << NODEID[1] << endl;
    mlpgTerOut << "TOTAL  PARTICLE NUMBER IS,\t" << NODEID[0] << endl;
    if(NODEID[0]>LNODE)
    {
        cout<<"ERROR IN ALLOCATION OF NUMBER OF NODES"<<endl;
    }

    // Finding unique boundary nodes
    for(long int i=NODEID[2];i<NODEID[0];i++)
    {
        for(long int j=i+1;j<NODEID[0];j++)
        {
            if((COORX[i]==COORX[j])&&(COORY[i]==COORY[j])&&(COORZ[i]==COORZ[j]))
            {
                cout << "unique node found\t" << i+1 << " " << j+1 << " "
                << NODEID2[i] << " " << NODEID2[j] << " " << endl;

                cout << COORX[i] << " " << COORY[i] << " "
                << COORZ[i] << endl;

                cout << COORX[j] << " " << COORY[j] << " "
                << COORZ[j] << endl;
            }
        }
    }

    ICELLX = (long int)(IXMAX/RCELL)+1;
    ICELLY = (long int)(IYMAX/RCELL)+1;
    ICELLZ = (long int)(IZMAX*2/RCELL)+1;

    mlpgTerOut << "CELL SIZES" << " " << ICELLX << " " 
    << ICELLY << " " <<  ICELLZ << endl;
    mlpgTerOut.close();

    NGHST=0;
    ofstream OutputXY_FLUENT;
    OutputXY_FLUENT.open("Output/XY_FLUENT.DAT"); //
    for(long int i=NODEID[1];i<NODEID[0];i++)
    {
        if(NODEID2[i]==-9)
        {
            NGHST++;
        }
    }
    OutputXY_FLUENT << NODEID[1]+NGHST << endl;
    OutputXY_FLUENT << "TIME=" << 0 << endl;
    for(long int i=0;i<NODEID[1];i++)
    {
        if((fabs(COORX[i])<=70)&&(fabs(COORY[2*LNODE+i])<=70)&&(fabs(COORZ[2*LNODE+i])<=70))
        {
            OutputXY_FLUENT << COORX[i] << " " << COORY[i] << " "
            << COORZ[i] << " " << " 0 " << " " << SNX[i] << " " << SNY[i] << " "
            << SNZ[i] << " " << NODEID2[i] << endl;
        }
        else
        {
            OutputXY_FLUENT << "-10 -10 -10 0 0 0 0 " << NODEID2[i] << endl;
        }   
    }

    for(long int i=NODEID[1];i<NODEID[0];i++)
    {
        if(NODEID2[i]==-9)
        {
            OutputXY_FLUENT << COORX[i] << " " << COORY[i] << " "
            << COORZ[i] << " 0 0 0 0 " << NODEID2[i] << endl;
        }
    }
    OutputXY_FLUENT.close();
}
int main()
{
    //declaring and initializing variables from mlpgrInput.dat file
    double H0=0.7;                  //Water depth
    double DDL=0.04375;             //Avg.distance between the nodes
    double SCALE=1.55;              //Scale factor to determine the domain of influence 
    long int KW=1;                  //Coefficient for Gauss Weight Function
    long int MBAS=4;                //Number of components in base function
    double DT=0.0075, TOTAL_TIME=0; //Time-Step (s), Starting time (s)
    long int NSTEPS=5500;           //Number of time-steps

    /*READ RECORD DATA TIME,THE FREQUENCY OF PRINT OUT IN THE NUMBER OF TYPE STEPS 
    RECORD THE TIME STEP, BEFORE THAT TIME, THE RECORD FREQUENCY IS EVRSTEP,AFTER
    THAT TIME, THE RECORD FREQUENCY IS EVRSTEP1*/

    long int IPRINT=5500, I_PF=120, I_PF1=40;//Freq1, Freq1, Freq2
    long int RESFREQ=800;           //Resume file interval (number of time-step)
    bool RESUMECHK=0;
    string RESUMEFILE="Output/Resume_000000800.dat";
    long int I_CAL_V=0;             //Viscosity On? (0/1)
    double VCOEFF=0.000001;         //Kinematic viscosity
    long int I_WM=15;               //Wave-maker type (0-No wavemaker, 1-Flap, 2-piston, 15-FNPT)
    long int IFSI=0;                //Enable elastic structure? (0/1)
    long int NTHR=8;                //Number of OpenMP Threads
    long int II=170000;       //Maximum number of nodes (LNODE)
    string MESHFILE="EmptyTank_L21_dr043_botFul3.dat";//Name of mesh-file
    double DOMX[2]={0,21},DOMY[2]={0,0.7},DOMZ[2]={0,0.7};//Domain coordinates
    double CYLX=6.5,CYLY=0.7,CYLR=0.04375;//Cylinder coordinates
    double SPONGEX=13;              //X Location of Sponge layer start (before right-wall)
    long int REMESHFREQ=30;         //Remeshing Freq (=0 to disable)
    long int NP=9;

    //checking the input data
    ofstream mlpgTerOut;
    mlpgTerOut.open("mlpgTerOut.dat");
    mlpgTerOut<<"3D WATER WAVE PROBLEM WITH MLPGR METHOD\n"
    <<H0<<"\n"<<DDL<<"\n"<<SCALE<<"\n"<<KW<<"\n"<<MBAS<<"\n"
    <<DT<<"\t"<<TOTAL_TIME<<"\t"<<NSTEPS<<"\n"<<IPRINT<<"\t"<<I_PF
    <<"\t"<<I_PF1<<"\n"<<I_CAL_V<<"\t"<<VCOEFF<<"\n"<<I_WM<<"\n"
    <<IFSI<<"\n"<<NTHR<<"\n"<<MESHFILE<<"\n"<<DOMX[0]<<"\t"<<DOMY[0]<<"\t"
    <<DOMZ[0]<<"\n"<<DOMX[1]<<"\t"<<DOMY[1]<<"\t"<<DOMZ[1]<<"\n"
    <<CYLX<<"\t"<<CYLY<<"\t"<<CYLR<<"\n"<<SPONGEX<<endl;
    mlpgTerOut.close();

    //<<REMESHFREQ<<"\n"<<"\n"<<RESFREQ<<"\t"<<RESUMECHK<<"\n"<<RESUMEFILE<<II<<"\n"
    FNPTCPLTYP FP;
    NODELINKTYP MLDOM, FSDOM, BOTOM;
    PROBETYP WP,PP;

    WP.INITPROBE(NP, 1, 602);       //Number of wave probes
    //WP.FILE=602;
    ifstream mlpgrInput;
    mlpgrInput.open("mlpgrInput.dat");
    /*for(long int i=0; i<NP; i++)
    {
        for(long int j=0; j<3; j++)
        {
            cout << WP.XYZ[i*3+j] << " " ;
        }
        cout << "\n" << endl;
    }*/
    for(long int i=0; i<NP; i++)
    {
        for(long int j=0; j<2; j++)
        {
            mlpgrInput >> WP.XYZ[i*2+j];
            //cout << WP.XYZ[i*2+j] << " " ;
        }
        //cout << "\n" << endl;
    }
    //cout << WP.FILE << endl;
    mlpgrInput >> NP;
    PP.INITPROBE(NP, 1, 603);
    for(long int i=0; i<NP; i++)
    {
        for(long int j=0; j<3; j++)
        {
            mlpgrInput >>PP.XYZ[i*3+j];
        }
    }
    mlpgrInput.close();
    FP.FILENAME="/Output PHIT2 23001.dt0075.S18.dat";
    //cout<<FP.FILENAME<<endl;
    FP.NX=121;
    //cout<<FP.NX<<endl;
    FP.NY=21;
    //cout<<FP.NY<<endl;
    FP.DDL=0.05;
    //cout<<FP.DDL<<endl;
    FP.X0=18.38;
    //cout<<FP.X0<<endl;
    FP.RLXLEN=1;
    //cout<<FP.RLXLEN<<endl;
    FP.FILE=601;
    //cout<<FP.FILE<<endl;
    FP.NN=(FP.NX)*(FP.NY);
    //cout<<FP.NN<<endl;
     LNODE=II;
     INITCOMMONMOD();

    //Variables in malpgrMain

    double *FB = NULL, *PTMP = NULL, *P = NULL;
    FB = new double[ LNODE]();
    PTMP = new double[ LNODE]();
    P = new double[ LNODE]();
    double *UN = NULL, *UM = NULL;
    UN = new double[ LNODE*3]();
    UM = new double[ LNODE]();
    double *CSUXT1 = NULL, *CSUYT1 = NULL, *CSUZT1 = NULL;
    CSUXT1 = new double[ LNODE]();
    CSUYT1 = new double[ LNODE]();
    CSUZT1 = new double[ LNODE]();
    double *ERRTMP = NULL, *MMTOIM = NULL;
    ERRTMP = new double[LNODE], MMTOIM = new double[LNODE];
    long int FSNOD1 = 0, FSNOD2 = 0;
    long int NODN = 0;
    ofstream output;
    output.open("output2.txt");
    mlpgTerOut.open("mlpgTerOut.dat",ofstream::app);

    //Generate Nodes

    NODEGRID(MESHFILE, FSNOD1, FSNOD2, DOMX, DOMY, DOMZ, CYLX, CYLY, CYLR, DDL);
    for(long int i=0;i<LNODE;i++)
    {
        COORX[1*LNODE+i]=COORX[i];
        COORY[1*LNODE+i]=COORY[i];
        COORZ[1*LNODE+i]=COORZ[i];
    }

    NODN = NODEID[0];   //Total Number of Nodes
    cout << NODEID[0];

    mlpgTerOut << "[INF] FREE SURFACE REFERENCE NODES\n"
    << FSNOD1 << " " << COORX[FSNOD1-1] << " " << COORY[FSNOD1-1] << " "
    << COORZ[FSNOD1-1] << endl;
    mlpgTerOut << FSNOD2 << " " << COORX[FSNOD2-1] << " " << COORY[FSNOD2-1] << " "
    << COORZ[FSNOD2-1] << endl;

    /*MLDOM.INITCELL(ICELLX, ICELLY, ICELLZ, 500);
    FSDOM.INITCELL(ICELLX, ICELLY, 1, 100);
    BOTOM.INITCELL(ICELLX, ICELLY, 1, 100);*/

    //STORING BNDNODES FOR FORCED ADJUSTMENT IN NEWCOOR


    mlpgTerOut.close();
    return 0;
}
