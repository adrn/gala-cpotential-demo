# coding: utf-8
# cython: boundscheck=False
# cython: nonecheck=False
# cython: cdivision=True
# cython: wraparound=False
# cython: profile=False

from __future__ import division, print_function

# Standard library
from collections import OrderedDict

# Third-party
import numpy as np
cimport numpy as np
np.import_array()
import cython
cimport cython

# Project
from gala.potential.potential.cpotential cimport CPotentialWrapper
from gala.potential.potential.cpotential import CPotentialBase
from gala.units import galactic

cdef extern from "potential/potential/src/funcdefs.h":
    ctypedef double (*energyfunc)(double t, double *pars, double *q, int n_dim) nogil
    ctypedef void (*gradientfunc)(double t, double *pars, double *q, int n_dim, double *grad) nogil

cdef extern from "potential/potential/src/cpotential.h":
    enum:
        MAX_N_COMPONENTS = 16

    ctypedef struct CPotential:
        int n_components
        int n_dim
        energyfunc value[MAX_N_COMPONENTS]
        gradientfunc gradient[MAX_N_COMPONENTS]
        int n_params[MAX_N_COMPONENTS]
        double *parameters[MAX_N_COMPONENTS]

cdef extern from "src/cpotential.h":
    double kepler_energy(double t, double *pars, double *q, int n_dim) nogil
    void kepler_gradient(double t, double *pars, double *q, int n_dim, double *grad) nogil

__all__ = ['KeplerPotential']

cdef class KeplerWrapper(CPotentialWrapper):

    def __init__(self, G, parameters):
        cdef CPotential cp

        # This is the only code that needs to change per-potential
        cp.value[0] = <energyfunc>(kepler_energy)
        cp.gradient[0] = <gradientfunc>(kepler_gradient)
        # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

        cp.n_dim = 3
        cp.n_components = 1
        self._params = np.array([G] + list(parameters), dtype=np.float64)
        self._n_params = np.array([len(self._params)], dtype=np.int32)
        cp.n_params = &(self._n_params[0])
        cp.parameters[0] = &(self._params[0])

        self.cpotential = cp

class KeplerPotential(CPotentialBase):
    r"""
    KeplerPotential(m, units=None)

    Parameters
    ----------
    m : :class:`~astropy.units.Quantity`, numeric [mass]
        Particle mass.
    units : `~gala.units.UnitSystem` (optional)
        Set of non-reducable units that specify (at minimum) the
        length, mass, time, and angle units.

    """
    def __init__(self, m, units=None):
        parameters = OrderedDict()
        ptypes = OrderedDict()

        parameters['m'] = m
        ptypes['m'] = 'mass'

        super(KeplerPotential, self).__init__(parameters=parameters,
                                              parameter_physical_types=ptypes,
                                              units=units,
                                              Wrapper=KeplerWrapper)
