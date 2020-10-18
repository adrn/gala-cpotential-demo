# coding: utf-8
# cython: boundscheck=False
# cython: nonecheck=False
# cython: cdivision=True
# cython: wraparound=False
# cython: profile=False

# Standard library
from collections import OrderedDict

# Third-party
import numpy as np
cimport numpy as np
np.import_array()

# Project
from gala.potential.potential.cpotential cimport CPotentialWrapper
from gala.potential.potential.cpotential cimport energyfunc, gradientfunc
from gala.potential import CPotentialBase, PotentialParameter

cdef extern from "src/potential.h":
    double kepler_energy(double t, double *pars, double *q, int n_dim) nogil
    void kepler_gradient(double t, double *pars, double *q, int n_dim, double *grad) nogil

__all__ = ['KeplerPotential']


cdef class KeplerWrapper(CPotentialWrapper):

    def __init__(self, G, parameters, q0, R):
        self.init([G] + list(parameters),
                  np.ascontiguousarray(q0),
                  np.ascontiguousarray(R))
        self.cpotential.value[0] = <energyfunc>(kepler_energy)
        self.cpotential.gradient[0] = <gradientfunc>(kepler_gradient)


class KeplerPotential(CPotentialBase):
    r"""
    Parameters
    ----------
    m : :class:`~astropy.units.Quantity`, numeric [mass]
        Particle mass.
    units : `~gala.units.UnitSystem` (optional)
        Set of non-reducable units that specify (at minimum) the
        length, mass, time, and angle units.

    """
    m = PotentialParameter('m', physical_type='mass')
    Wrapper = KeplerWrapper
