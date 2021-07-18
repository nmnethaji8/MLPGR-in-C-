#ifndef FNPTCOUPLING
#define FNPTCOUPLING
#include<string>
namespace FNPTCPLMOD
{
    class FNPTCPLTYP
    {
        public:long int FILE, NX, NY, NN;
        double DDL, X0, RLXLEN;
        std::string FILENAME;
        FNPTCPLTYP();
    };
}
#endif
