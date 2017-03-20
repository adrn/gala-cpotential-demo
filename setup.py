#!/usr/bin/env python

from collections import defaultdict
import os
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

# Build the C / Cython code
extensions = []

# Get Gala path, Numpy path
import gala
gala_base_path = os.path.split(gala.__file__)[0]

import numpy
numpy_base_path = os.path.split(numpy.__file__)[0]

cfg = defaultdict(list)
cfg['include_dirs'].append(os.path.join(numpy_base_path, 'core', 'include'))
cfg['include_dirs'].append(os.path.join(gala_base_path, 'potential'))
cfg['extra_compile_args'].append('--std=gnu99')
cfg['sources'].append('potentialdemo/cpotential.pyx')
cfg['sources'].append('potentialdemo/src/potential.c')
extensions.append(Extension('potentialdemo.potential', **cfg))

pkg_data = dict()
pkg_data[""] = ["LICENSE", "AUTHORS"]
pkg_data["potentialdemo"] = ["src/*.h", "src/*.c"]

print(extensions)

setup(name='gala_cpotential_demo',
      version='0.1',
      description='Demonstration of how to define a new potential class implemented in C that '
                  'works with the Gala dynamics machinery.',
      install_requires=['numpy', 'astro-gala'],
      author='adrn',
      author_email='adrn@astro.princeton.edu',
      license='MIT',
      url='https://github.com/adrn/gala-cpotential-demo',
      cmdclass={'build_ext': build_ext},
      package_data=pkg_data,
      ext_modules=extensions)
