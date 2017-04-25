#!/usr/bin/python

import random
import numpy as np
import csv
from config import SOURCE, TRANING, TEST

# init random
random.seed(1)

# creates a random dataset


def generateRandomSet(rows, dim, datatype):
    """Generate 10 random dataset"""

    # set size
    size = dim[0] * dim[1]

    # init empty space for input
    data = np.zeros(size, datatype)

    # output holder
    out = []

    # loop the set of rows
    for row in range(rows):

        # loop the set of cols
        for col in range(size):

            # save the random data as either 0 or 1
            data[col] = random.randrange(2)

        # save ref to output
        out.append({
            'recordNum': row,
            'bucketIdx': row,
            'actValue': row,
            'raw': data
        })

    # return the resulting random set
    return out


def getRealData(optimise):

    # output holder
    training = []
    test = []

    with open(SOURCE, 'rb') as csvfile:

        # get sourcereader
        sourcereader = csv.reader(csvfile, delimiter=',')

        # get length of source
        length = len(sourcereader)
        counter = 1

        # read up to here
        trainto = int(TRANING * length)
        rest = int((length - trainto) * TEST)

        if optimise is True:
            spanrest = [trainto + rest, length]
        else:
            spanrest = [trainto + 1, trainto + rest + 1]

        # skips the first since it is header information
        sourcereader.readline()
        for row in sourcereader:

            # load traning data
            if counter >= trainto:
                training.append({
                    'recordNum': row[0],
                    'bucketIdx': row[1],
                    'actValue': row[2],
                    'raw': row[3]
                })

            # load test data if current row is within span
            if counter >= spanrest[0] or counter <= spanrest[1]:
                training.append({
                    'recordNum': row[0],
                    'bucketIdx': row[1],
                    'actValue': row[2],
                    'raw': row[3]
                })
    return [test, training]
