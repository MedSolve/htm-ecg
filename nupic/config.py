# classifier configuration
CLASSCONFIG = {
}

# path to csv
SAVEPATH = './data/nupi.res.csv'

# global configuration for layers
CONFIG = {
    'uintType': 'uint32',           # Data type supporting binery 0 and 1
    'amountActiveCols': 0.02,       # Percentage of columns active in a layer
    'potentialRadius': 0.0125,      # Amount of the source seen by columns
    'inhibition': True,             # Enable the spares distribution by inhibitory effects
    'boostStrength': 0.5,           # Enable a little boost
    'cellsPerColumn': 4,            # How many cells in each mini-columns
    'numIterations': 35000          # Number of iterations
}

# set config for l1
CONFIG_L1 = {
    'inputDimensions': (80, 80),    # Dimentions of the input space
    'columnDimensions': (40, 40),   # Dimentions of the column space
}

# set config for l2
CONFIG_L2 = {
    'inputDimensions': CONFIG_L1['columnDimensions'],   # Dimentions of the input space
    'columnDimensions': (20, 20),                       # Dimentions of the column space
}

# update configs to contain shared
CONFIG_L1.update(CONFIG)
CONFIG_L2.update(CONFIG)
