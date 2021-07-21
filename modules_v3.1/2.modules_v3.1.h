#ifndef PROBESMOD_H
#define PROBESMOD_H
class PROBETYP
{
    public:long int NP, NVAR, FILE;
    double *XYZ, *DATA;
    void INITPROBE(long int, long int, long int);
};
#endif
