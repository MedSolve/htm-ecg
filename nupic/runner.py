from dataset import generateRandomSet
from implementation import Layer, TopNode
from config import CLASSCONFIG, CONFIG_L1, CONFIG_L2

# Generate random dataset
DATA = generateRandomSet(CONFIG_L1['inputDimensions'], CONFIG_L1['uintType'])

# Generate the layers and classifier
LAYERONE = Layer(CONFIG_L1)
LAYERTWO = Layer(CONFIG_L2)
CLASSIFIER = TopNode(CLASSCONFIG)

# Perform actual learning

# Perform inherence
