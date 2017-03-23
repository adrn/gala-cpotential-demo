from potentialdemo.potential import KeplerPotential
import numpy as np

def test_thing():
    pot = KeplerPotential(m=1.)
    E = pot.energy([1.,0.1,-0.41])
    assert np.all(np.isfinite(E))
