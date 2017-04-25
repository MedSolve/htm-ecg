from dataset import generateRandomSet
from implementation import Layer, TopNode
from config import CLASSCONFIG, CONFIG_L1, CONFIG_L2

# Ranudom row
RANROW = 10

# Generate random dataset
DATA_TEST = generateRandomSet(RANROW, CONFIG_L1['inputDimensions'], CONFIG_L1['uintType'])
DATA_TRAINING = generateRandomSet(RANROW, CONFIG_L1['inputDimensions'], CONFIG_L1['uintType'])

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

# Perform inherence on TEST data
for row in DATA_TRAINING:

    out_one = LAYERONE.predict(row['raw'], True)
    out_two = LAYERTWO.predict(out_one, False)
    predictions = CLASSIFIER.predic(out_two, row['recordNum'])

    for probability, value in predictions:
        print "Prediction of {} has probability of {}.".format(value, probability*100.0)
        