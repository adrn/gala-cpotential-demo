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
from gala.potential.potential.cpotential cimport CPotentialWrapper, energyfunc, gradientfunc
from gala.potential.potential.cpotential import CPotentialBase
from gala.units import galactic

cdef extern from "src/potential.h":
    double kepler_energy(double t, double *pars, double *q, int n_dim) nogil
    void kepler_gradient(double t, double *pars, double *q, int n_dim, double *grad) nogil

__all__ = ['KeplerPotential']

cdef class KeplerWrapper(CPotentialWrapper):

    def __init__(self, G, parameters):
        self.init([G] + list(parameters))
        self.cpotential.value[0] = <energyfunc>(kepler_energy)
        self.cpotential.gradient[0] = <gradientfunc>(kepler_gradient)

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
