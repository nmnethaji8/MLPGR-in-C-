#include"modCommon.h"
namespace COMMONMOD
{
    long int LNODE = 0;
    long int *NODEID = NULL, *NWALLID = NULL;
    double *COORX = NULL, *COORY = NULL, *COORZ = NULL;
    double *SNX = NULL, *SNY = NULL, *SNZ = NULL;
    double *SMX = NULL, *SMY = NULL, *SMZ = NULL;
    double *SSX = NULL, *SSY = NULL, *SSZ = NULL;
    double *TANK_A = NULL;
    void INITCOMMONMOD()
    {
        NODEID = new long int[8+LNODE]();
        NWALLID = new long int[LNODE*4]();
        COORX = new double[LNODE*3]();
        COORY = new double[LNODE*3]();
        COORZ = new double[LNODE*3]();
        SNX = new double[LNODE]();
        SNY = new double[LNODE]();
        SNZ = new double[LNODE]();
        SMX = new double[LNODE]();
        SMY = new double[LNODE]();
        SMZ = new double[LNODE]();
        SSX = new double[LNODE]();
        SSY = new double[LNODE]();
        SSZ = new double[LNODE]();
        TANK_A = new double[LNODE*3]();
    }
}
