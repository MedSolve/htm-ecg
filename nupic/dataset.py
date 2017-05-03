import random
import csv
import numpy as np
import math
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

def getRealData(optimise, datatype):

    # output holder
    training = []
    test = []

    with open(SOURCE, 'rb') as csvfile:

        # get sourcereader
        sourcereader = csv.reader(csvfile, delimiter=',')

        print "Dataset now open"

        # skips the first since it is header information
        sourcereader.next()

        # get length of source
        data = list(sourcereader)
        rowcounter = 1
        rowlength = len(data)
        # sorted data
        sortedData = {}

        # loop all he rows
        for row in data:

            print "processing row {} of {} for subject {}".format(rowcounter, rowlength, row[1])

            rowcounter = rowcounter + 1
            # empty raw array
            raw = np.zeros(len(row[3]), datatype)

            # copy content to array
            for i in range(len(row[3])):
                raw[i] = int(row[3][i])

            # put into sorted
            if row[1] in sortedData:

                # saved sorted data by bucketidx
                sortedData[row[1]].append({
                    'recordNum': row[0],
                    'bucketIdx': row[1],
                    'actValue': row[2],
                    'raw': raw
                })
            else:
                # create empty array and then append
                sortedData[row[1]] = []
                sortedData[row[1]].append({
                    'recordNum': row[0],
                    'bucketIdx': row[1],
                    'actValue': row[2],
                    'raw': raw
                })

        # prepare to read only a specfic number of persons
        lengthPersons = len(sortedData)
        traintoPerson = int(math.ceil(TRANING * lengthPersons))
        rest = int(math.ceil((lengthPersons - traintoPerson) * TEST))
        counterPerson = 1

        print "a total number of {} subjects where detected".format(lengthPersons)
        print "number of subjects for traning {} and test {}".format(traintoPerson, rest)

        # check if optimisation data set should be set
        if optimise is True:
            spanrest = [traintoPerson + rest + 1, lengthPersons]
        else:
            spanrest = [traintoPerson + 1, traintoPerson + rest]

        # put data into traning and test data and assign custom person id
        personID = 0
        for personData in sortedData:

            print "Sorting test and traning data for subject {}".format(personData)

            # check if the person is traning and or row data
            if counterPerson <= traintoPerson or (counterPerson >= spanrest[0] and counterPerson <= spanrest[1]):

                # prepare for each in row point in the person
                length = len(sortedData[personData])
                trainto = int(math.ceil(TRANING * length))
                counter = 1

                print length
                print trainto

                for row in sortedData[personData]:

                    # set the fixed bucketidx
                    row['old_bucketIdx'] = row['bucketIdx']
                    row['bucketIdx'] = personID

                    # load traning data or append as test data
                    if counter <= trainto:
                        training.append(row)
                    else:
                        test.append(row)

                    # increase the counter
                    counter = counter + 1

                # increment personid
                personID = personID + 1

            # increase the number counter for persons
            counterPerson = counterPerson + 1

    return [test, training, lengthPersons, personID]

DATA = getRealData(True, 'uint32')

DATA_TEST = DATA[0]
DATA_TRAINING = DATA[1]
DATA_NUM_SUBJECTS = DATA[3]
DATA_NUM_SUBJECTS_TOTAL = DATA[2]

print len(DATA_TEST)
print len(DATA_TRAINING)
print DATA_NUM_SUBJECTS
print DATA_NUM_SUBJECTS_TOTAL
