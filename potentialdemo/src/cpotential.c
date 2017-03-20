#include <math.h>

double kepler_energy(double t, double *pars, double *q, int n_dim) {
    /*  pars:
            G : Gravitational constant
            m : point-particle mass
    */
    double r = q[0]*q[0] + q[1]*q[1] + q[2]*q[2];
    return - pars[0] * pars[1] / r;
}

void kepler_gradient(double t, double *pars, double *q, int n_dim, double *grad) {
    /*  pars:
            G : Gravitational constant
            m : point-particle mass
    */
    double r = q[0]*q[0] + q[1]*q[1] + q[2]*q[2];
    double fac = pars[0] * pars[1] / (r*r*r);

    grad[0] = grad[0] + fac * q[0];
    grad[1] = grad[1] + fac * q[1];
    grad[2] = grad[2] + fac * q[2];
}


