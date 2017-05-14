from dataset import getFromMongo
from implementation import Layer, TopNode
from config import CLASSCONFIG, CONFIG_L1, CONFIG_L2, SAVEPATH
import csv

# Generate the layers and classifier
LAYERONE = Layer(CONFIG_L1)
LAYERTWO = Layer(CONFIG_L2)
CLASSIFIER = TopNode(CLASSCONFIG)

def train_cb(row, TESTNUM):
    'Trains the system on the row'

    print "Performing traning {}".format(TESTNUM)

    # perform the given iterations
    for i in range(CONFIG_L1['numIterations']):

        # run learning and get cols as output
        LAYERONE.learn(row['raw'])

    # perform the given iterations
    # CONFIG_l1 contains globally set numIterations
    for i in range(CONFIG_L1['numIterations']):

        # get prediction from trained layer
        out_one = LAYERONE.predict(row['raw'], True)

        # run learning and get cols as output
        LAYERTWO.learn(out_one)

    # perform the given iterations
    # CONFIG_l1 contains globally set numIterations
    for i in range(CONFIG_L1['numIterations']):

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
WRITER.writerow(['Test number', 'Old BucketIndex', 'BucketIndex',
                 'Classification', 'Probability'])


def test_cb(row, TESTNUM):
    'test on the current row'

    out_one = LAYERONE.predict(row['raw'], True)
    out_two = LAYERTWO.predict(out_one, False)
    predictions = CLASSIFIER.predic(out_two, row['recordNum'])

    print "Performing classification {}".format(TESTNUM)

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

getFromMongo(CONFIG_L1['uintType'], train_cb, test_cb)

# print "DONE using {} test and {} traning samples".format(TESTLENGTH, STEPS)
# print "on {} subjects of {}".format(DATA_NUM_SUBJECTS,
# DATA_NUM_SUBJECTS_TOTAL)
