#ifndef NODELINKNEW
#define NODELINKNEW
namespace NODELINKMOD
{
    class NODELINKTYP
    {
        public:
        long int CS1;
        long int *CELL;
        long int CELLX, CELLY, CELLZ, CELLN;
        double REFBL[3],REFTR[3],CELLR;
        void INITCELL(int, int, int ,int );
        void FILLCELL(int, int, int ,int );
        void FINDCELL(int, int, int ,int );
        void ENDCELL(int, int, int ,int );
    };
}
#endif
