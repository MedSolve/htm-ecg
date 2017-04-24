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

# Perform actual learning
for row in len(DATA):

    out_one = LAYERONE.learn(DATA[row])
    out_two = LAYERTWO.learn(out_one)
    CLASSIFIER.learn(out_two) # this one can take active cells?

# Perform inherence
for row in len(DATA):

    out_one = LAYERONE.predict(DATA[row])
    out_two = LAYERTWO.predict(out_one)
    CLASSIFIER.predict(out_two) # this one can take active cells?
    