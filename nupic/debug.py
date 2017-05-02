from implementation import Layer, TopNode
from config import CLASSCONFIG, CONFIG_L1, CONFIG_L2, SAVEPATH
from nupic.encoders.random_distributed_scalar import RandomDistributedScalarEncoder

# FOUND ERROR TWO HIGH PATIENT IDS
CLASSIFIER = TopNode(CLASSCONFIG)
bucketIdx = 25000
actValue = 908840557.1382
recordNum = 1382
out_two = [0, 1, 2, 3, 4, 5, 6, 7]

CLASSIFIER.learn(out_two, bucketIdx, actValue, recordNum)
