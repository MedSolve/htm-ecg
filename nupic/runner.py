from dataset import generateRandomSet
from implementation import Layer, TopNode
from config import CLASSCONFIG, CONFIG_L1, CONFIG_L2

# Ranudom row
RANROW = 10

# Generate random dataset
DATA = generateRandomSet(RANROW, CONFIG_L1['inputDimensions'], CONFIG_L1['uintType'])

# Generate the layers and classifier
LAYERONE = Layer(CONFIG_L1)
LAYERTWO = Layer(CONFIG_L2)
CLASSIFIER = TopNode(CLASSCONFIG)

# Perform actual learning on first layer
for row in len(DATA):

    # run learning and get cols as output
    LAYERONE.learn(DATA[row])

# Perform actual learning on second layer
for row in len(DATA):

    # get prediction from trained layer
    out_one = LAYERONE.predict(DATA[row], True)

    # run learning and get cols as output
    LAYERTWO.learn(out_one)

# Perform actual learning on third layer
for row in len(DATA):

    # get prediction from trained layer
    out_one = CLASSIFIER.learn(DATA[row]) # Calculate meta 

    # run learning and get cols as output
    LAYERTWO.learn(out_one)

# Perform inherence
for row in len(DATA):

    out_one = LAYERONE.predict(DATA[row], True)
    out_two = LAYERTWO.predict(out_one, False)
    CLASSIFIER.predict(out_two) # Calculate meta
    