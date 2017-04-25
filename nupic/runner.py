from dataset import generateRandomSet, getRealData
from implementation import Layer, TopNode
from config import CLASSCONFIG, CONFIG_L1, CONFIG_L2, SAVEPATH
import numpy as np
import csv

# Generate random dataset
DATA_TEST = generateRandomSet(
    10, CONFIG_L1['inputDimensions'], CONFIG_L1['uintType'])
DATA_TRAINING = generateRandomSet(
    5, CONFIG_L1['inputDimensions'], CONFIG_L1['uintType'])

# get the real data source 
#DATA = getRealData(True)
#DATA_TEST = DATA[0]
#DATA_TRAINING = DATA[1]

# Generate the layers and classifier
LAYERONE = Layer(CONFIG_L1)
LAYERTWO = Layer(CONFIG_L2)
CLASSIFIER = TopNode(CLASSCONFIG)

# Perform actual learning on first layer
for row in DATA_TEST:

    # run learning and get cols as output
    LAYERONE.learn(row['raw'])

# Perform actual learning on second layer
for row in DATA_TEST:

    # get prediction from trained layer
    out_one = LAYERONE.predict(row['raw'], True)

    # run learning and get cols as output
    LAYERTWO.learn(out_one)

# Perform actual learning on third layer
for row in DATA_TEST:

    # get prediction from trained layers
    out_one = LAYERONE.predict(row['raw'], True)
    out_two = LAYERTWO.predict(out_one, False)

    # calculate meta
    bucketIdx = row['bucketIdx']
    actValue = row['actValue']
    recordNum = row['recordNum']

    # perform classification
    CLASSIFIER.learn(out_two, bucketIdx, actValue, recordNum)

# Open result write
WRITER = csv.writer(open(SAVEPATH, 'w'))

# Set labelse
WRITER.writerow(['Test number', 'BucketIndex',
                 'Classification', 'Probability'])

# Test number
TESTNUM = 0

# Perform inherence on TEST data
for row in DATA_TRAINING:

    # increment test
    TESTNUM = TESTNUM + 1

    out_one = LAYERONE.predict(row['raw'], True)
    out_two = LAYERTWO.predict(out_one, False)
    predictions = CLASSIFIER.predic(out_two, row['recordNum'])

    print predictions

    for probability, value in predictions:
        WRITER.writerow([TESTNUM, row['bucketIdx'], int(
            value), "{0:.2f}".format(probability * 100.0)])
