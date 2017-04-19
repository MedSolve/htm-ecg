#!/usr/bin/env python

from nupic.encoders.sparse_pass_through_encoder import SparsePassThroughEncoder
import model_params

# SOME HELPER: http://nbviewer.jupyter.org/github/numenta/nupic/blob/master/examples/NuPIC%20Walkthrough.ipynb

# encode the image
enc = SparsePassThroughEncoder()

# LEVEL 1
    # run spatial pooling

    # run temporal poolin

# LEVEL 2
    # run spatial pooling

    # run temporal pooling

# Level 3 (Classification)
    
