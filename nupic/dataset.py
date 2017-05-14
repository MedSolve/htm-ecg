import csv
import numpy as np
import math
from pymongo import MongoClient
from config import SOURCE, TRANING, TEST, MONGOCONFIG

def getRealData():
    'Gets real dataset and store it in MongoDB'

    # connect and get db
    con = MongoClient(MONGOCONFIG)
    database = con.ecg_db
    collection = database.ecg_collection

    with open(SOURCE, 'rb') as csvfile:

        # get sourcereader
        sourcereader = csv.reader(csvfile, delimiter=',')

        print "Dataset now open"

        # skips the first since it is header information
        sourcereader.next()

        # init of holders
        sorted_data = {}
        rowcounter = 1
        person_id = 0

        # loop all he rows
        for row in sourcereader:

            # feedback
            print "processing row {}".format(rowcounter)
            rowcounter = rowcounter + 1

            # if personID do not exist for bucket then create one
            if sorted_data.has_key(row[1]) is False:

                sorted_data[row[1]] = person_id
                person_id = person_id + 1

            # insert the data
            collection.insert_one({
                'recordNum': row[0],
                'bucketIdx': sorted_data[row[1]],
                'old_bucketIdx': row[1],
                'actValue': row[2],
                'raw': row[3]
            })

        # print how much we lodaed
        print "a total number of {} subjects where detected".format(len(sorted_data))

    print 'Data Saved to MongoDB'

def getFromMongo(optimise, datatype, train_cb, test_cb):
    'Gets test and traning data from mongodb'

    # connect and get db
    con = MongoClient(MONGOCONFIG)
    database = con.ecg_db
    collection = database.ecg_collection

    # prepare to read only a specfic number of persons
    persons = collection.distinct('bucketIdx')
    length_persons = len(persons)
    trainto_person = int(math.ceil(TRANING * length_persons))
    rest = int(math.ceil((length_persons - trainto_person) * TEST))

    print "a total number of {} subjects where detected".format(length_persons)
    print "number of subjects for traning {} and test {}".format(trainto_person, rest)

    # check if optimisation data set should be set
    if optimise is True:
        spanrest = [trainto_person + rest + 1, length_persons]
    else:
        spanrest = [trainto_person + 1, trainto_person + rest]

    # find the dataset of persons to loop
    loop_these_persons = persons[:trainto_person] + persons[spanrest[0]:spanrest[1]]

    # find all the training data
    for person in loop_these_persons:

        # get data curser
        curs = collection.find({'bucketIdx': person}, no_cursor_timeout=True).batch_size(5)

        # prepare for each in row point in the person
        length = curs.count()
        trainto = int(math.ceil(TRANING * length))
        counter = 1

        # print feedback
        print "Sorting test and traning data for subject {}".format(person)

        # get the data for the person
        for person_data in curs:

            # empty array for raw value
            raw = np.zeros(len(person_data['raw']), datatype)

            # copy content to array
            for i in range(len(person_data['raw'])):
                raw[i] = int(person_data['raw'][i])

            # bind updated raw
            person_data['raw'] = raw

            # load traning data or append as test data
            if counter <= trainto:
                train_cb(person_data, counter)
            else:
                test_cb(person_data, counter)

            # increase the counter
            counter = counter + 1

    # return specifics
    #return [test, training, length_persons, trainto_person + rest]
