#!/usr/bin/python

import random
import numpy as np

# init random
random.seed(1)

# creates a random dataset
def generateSet(dim, datatype):

    # set size
    size = dim[0]*dim[1]

    # init empty space for input
    data = np.zeros(size, datatype)

    # loop the set of cols
    for col in range(size):

        # save the random data as either 0 or 1
        data[col] = random.randrange(2)

    # return the resulting random set
    return data
