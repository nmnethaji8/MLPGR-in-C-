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
        void INITCELL(long int, long int, long int, long int);
        void FILLCELL(long int, long int, long int, long int);
        void FINDCELL(long int, long int, long int, long int);
        void ENDCELL(long int, long int, long int, long int);
    };
}
#endif
