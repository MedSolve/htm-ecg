#!/usr/bin/python

import numpy as np
from nupic.research.spatial_pooler import SpatialPooler
from nupic.research.temporal_memory import TemporalMemory
from demoData import generateSet

# Configuration
CONFIG = {
    'uintType': 'uint32',           # Data type supporting binery 0 and 1
    'amountActiveCols': 0.02,       # Percentage of columns active in a layer
    'inputDimensions': (30, 40),  # Dimentions of the input space
    'columnDimensions': (20, 20),  # Dimentions of the column space
    'potentialRadius': 0.5,         # Amount of the source seen by columns
    'inhibition': True,             # Enable the spares distribution by inhibitory effects
    'permIncrease': 0.01,           # Amount of increase in synaps as they are active
    'permDecrease': 0.008,          # Amount of decrease in synaps as they are inactive
    'boostStrength': 0              # Disable boost
}

# random data test
DATA = generateSet(CONFIG['inputDimensions'], CONFIG['uintType'])

# Calculate the size of input and col space
INPUTSIZE = np.array(CONFIG['inputDimensions']).prod()
COLSIZE = np.array(CONFIG['columnDimensions']).prod()

# setup the pooler and reference to active column holder
SP = SpatialPooler(
    inputDimensions=CONFIG['inputDimensions'],
    columnDimensions=CONFIG['columnDimensions'],
    potentialRadius=int(CONFIG['potentialRadius'] * INPUTSIZE),
    numActiveColumnsPerInhArea=int(CONFIG['amountActiveCols'] * COLSIZE),
    globalInhibition=CONFIG['inhibition'],
    synPermActiveInc=CONFIG['permIncrease'],
    synPermInactiveDec=CONFIG['permDecrease']
)

# find colsize do alculate a length for acitive columns
COLDIMSIZE = CONFIG['columnDimensions'][0] * CONFIG['columnDimensions'][1]

# reference to active columns
ACTIVECOLUMNS = np.zeros(COLDIMSIZE, CONFIG['uintType'])

# RUN THE TP
SP.compute(
    DATA,
    False,
    ACTIVECOLUMNS
)

tm = TemporalMemory(
    # Must be the same dimensions as the SP
    columnDimensions=(2048, ),
    # How many cells in each mini-column.
    cellsPerColumn=32,
    # A segment is active if it has >= activationThreshold connected synapses
    # that are active due to infActiveState
    activationThreshold=16,
    initialPermanence=0.21,
    connectedPermanence=0.5,
    # Minimum number of active synapses for a segment to be considered during
    # search for the best-matching segments.
    minThreshold=12,
    # The max number of synapses added to a segment during learning
    maxNewSynapseCount=20,
    permanenceIncrement=0.1,
    permanenceDecrement=0.1,
    predictedSegmentDecrement=0.0,
    maxSegmentsPerCell=128,
    maxSynapsesPerSegment=32,
    seed=1960
)

# debug
print ACTIVECOLUMNS
