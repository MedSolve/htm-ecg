# classifier configuration
CLASSCONFIG = {
}

# path to csvs
SAVEPATH = './data/nupi.res.csv'
SOURCE = './data/nupi.source.csv'

# Data source split
TRANING = 0.05       # Percentage of total data set
OFFSET = 0;          # Offset in dataset (optimisation)
TEST = 0.2           # Percentage of rest data after traning

# MONGODB 
MONGOCONFIG = 'ss'

# global configuration for layers
CONFIG = {
    'uintType': 'uint32',           # Data type supporting binery 0 and 1
    'amountActiveCols': 0.02,       # Percentage of columns active in a layer
    'potentialRadius': 0.0125,      # Amount of the source seen by columns
    'inhibition': True,             # Enable the spares distribution by inhibitory effects
    'boostStrength': 0.1,           # Enable a little boost
    'cellsPerColumn': 4,            # How many cells in each mini-columns
    'numIterations': 10000          # Number of iterations
}

# set config for l1
CONFIG_L1 = {
    'inputDimensions': (96, 384),   # Dimentions of the input space
    'columnDimensions': (12, 48),   # Dimentions of the column space
}

# set config for l2
CONFIG_L2 = {
    'inputDimensions': CONFIG_L1['columnDimensions'],  # Dimentions of the input space
    'columnDimensions': (3, 12),                       # Dimentions of the column space
}

# update configs to contain shared
CONFIG_L1.update(CONFIG)
CONFIG_L2.update(CONFIG)
