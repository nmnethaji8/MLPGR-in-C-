#ifndef MODCOMMON
#define MODCOMMON
namespace COMMONMOD
{
    extern long int LNODE;

    extern long int *NODEID, *NWALLID;
    extern long int ICELLX, ICELLY, ICELLZ;
    extern long int IXMAX, IYMAX, IZMAX;

    extern double *COORX, *COORY, *COORZ;
    extern double *SNX, *SNY, *SNZ;
    extern double *SMX, *SMY, *SMZ;
    extern double *SSX, *SSY, *SSZ;
    extern double *TANK_A;

    extern double RCELL;
    void INITCOMMONMOD();
}
#endif
