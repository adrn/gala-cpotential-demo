#!/bin/bash -x

# http://conda.pydata.org/docs/travis.html#the-travis-yml-file
if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
  wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh;
else
  wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
fi
bash miniconda.sh -b -p $HOME/miniconda
export PATH="$HOME/miniconda/bin:$PATH"

# Conda Python
hash -r
conda config --set always_yes yes --set changeps1 no
conda update -q conda
conda info -a
conda create --yes -n test python=$PYTHON_VERSION
source activate test
conda install -c conda-forge numpy=$NUMPY_VERSION cython pytest

if [[ "$GALA_VERSION" == "dev" ]]; then
  pip install git+https://github.com/adrn/gala.git
else
  pip install astro-gala=$GALA_VERSION
fi

# Build the extension
python setup.py install $BUILD_ARGS