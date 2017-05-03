from dataset import generateRandomSet, getRealData, getFromMongo
from implementation import Layer, TopNode
from config import CLASSCONFIG, CONFIG_L1, CONFIG_L2, SAVEPATH
import csv

# Generate random dataset
# DATA_TEST = generateRandomSet(
#    10, CONFIG_L1['inputDimensions'], CONFIG_L1['uintType'])
# DATA_TRAINING = generateRandomSet(
#    5, CONFIG_L1['inputDimensions'], CONFIG_L1['uintType'])

# get the real data source
getRealData(CONFIG_L1['uintType'])
DATA = getFromMongo(False)
DATA_TEST = DATA[0]
DATA_TRAINING = DATA[1]
DATA_NUM_SUBJECTS_TOTAL = DATA[2]
DATA_NUM_SUBJECTS = DATA[3]

# Generate the layers and classifier
LAYERONE = Layer(CONFIG_L1)
LAYERTWO = Layer(CONFIG_L2)
CLASSIFIER = TopNode(CLASSCONFIG)

# Get length to calculate percentage done CONFIG_l1 contains globally set numIterations
STEPS = len(DATA_TRAINING)*CONFIG_L1['numIterations']*3
CURRENT_STEP = 1

# perform the given iterations
for i in range(CONFIG_L1['numIterations']):

    # Perform actual learning on first layer
    for row in DATA_TRAINING:

        # run learning and get cols as output
        LAYERONE.learn(row['raw'])

        print "Performing operation {} of {}".format(CURRENT_STEP, STEPS)

        CURRENT_STEP = CURRENT_STEP + 1

# perform the given iterations
for i in range(CONFIG_L1['numIterations']): #CONFIG_l1 contains globally set numIterations

    # Perform actual learning on second layer
    for row in DATA_TRAINING:

        # get prediction from trained layer
        out_one = LAYERONE.predict(row['raw'], True)

        # run learning and get cols as output
        LAYERTWO.learn(out_one)

        print "Performing operation {} of {}".format(CURRENT_STEP, STEPS)

        CURRENT_STEP = CURRENT_STEP + 1

# perform the given iterations
for i in range(CONFIG_L1['numIterations']):  #CONFIG_l1 contains globally set numIterations

    # Perform actual learning on third layer
    for row in DATA_TRAINING:

        # get prediction from trained layers
        out_one = LAYERONE.predict(row['raw'], True)
        out_two = LAYERTWO.predict(out_one, False)

        # calculate meta
        bucketIdx = row['bucketIdx']
        actValue = row['actValue']
        recordNum = row['recordNum']

        # perform classification
        CLASSIFIER.learn(out_two, bucketIdx, actValue, recordNum)

        print "Performing operation {} of {}".format(CURRENT_STEP, STEPS)

        CURRENT_STEP = CURRENT_STEP + 1

# Open result write
WRITER = csv.writer(open(SAVEPATH, 'w'))

# Set labelse
WRITER.writerow(['Test number', 'Old BucketIndex', 'BucketIndex',
                 'Classification', 'Probability'])

# Test number
TESTNUM = 0
TESTLENGTH = len(DATA_TEST)

# Perform inherence on TEST data
for row in DATA_TEST:

    # increment test
    TESTNUM = TESTNUM + 1

    out_one = LAYERONE.predict(row['raw'], True)
    out_two = LAYERTWO.predict(out_one, False)
    predictions = CLASSIFIER.predic(out_two, row['recordNum'])

    print "Performing classification {} of {}".format(TESTNUM, TESTLENGTH)

    for probability, value in predictions:
        WRITER.writerow(
            [
                TESTNUM,
                row['old_bucketIdx'],
                row['bucketIdx'],
                value,
                "{0:.2f}".format(probability * 100.0)
            ]
        )

print "DONE using {} test and {} traning samples".format(TESTLENGTH, STEPS)
print "on {} subjects of {}".format(DATA_NUM_SUBJECTS, DATA_NUM_SUBJECTS_TOTAL)
