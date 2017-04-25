# HTM ECG implementation in MatLab and nupic
Data is prepared in matlab for encoding and processeing in nupic

(NOT DONE YET)

# Important
When performing any operations with this project stay in the project's root folder. This is because of the relative paths. Remember to install all nupic and python dependencies! See [nupic](http://nupic.docs.numenta.org/quick-start/index.html) docs.

# Getting started
Initially the data is prepared by matlab as follows:

* use generateSource() and select your datasource
* The script use imageMap() to create a binary encoding
* These are stored in nupi.source.csv by default

The storage can be changed in 'generateSource()' but keep it mind that it will also need to be changed in 'config.py' under the nupic folder. In this file every configuration can be set.

Use 'nupic/runner.py' to perfrom HTM on the data. This will generate an output that as default will be in 'data/nupic.res.csv'

Use this in any program you want to evaluate your system!