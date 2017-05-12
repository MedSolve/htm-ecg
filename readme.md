# HTM ECG implementation in MatLab and nupic
Data is prepared in matlab for encoding and processeing in nupic

Configuration needs to change to fit with datasource in and output. 
To improve the performance of this system we included MongoDB.

# Time
For ECG data with 10 seconds ECG on 50.000 trails it took roughly 6 days on a quard core i7 to prepare the dataset.

# Important
When performing any operations with this project stay in the project's root folder. This is because of the relative paths. Remember to install all nupic and python dependencies! See [nupic](http://nupic.docs.numenta.org/quick-start/index.html) docs. Remember to add the matlab folder to path in matlab!

# Getting started
Initially the data is prepared by matlab as follows:

* use generateSource() and select your datasource
* The script use imageMap() to create a binary encoding of ECG image
* These are stored in nupi.source.csv by default

Example ECG data is given in 'matlab/lib/ECGtest.xml'

The storage can be changed in 'generateSource()' but keep it mind that it will also need to be changed in 'config.py' under the nupic folder. In this file every configuration can be set.

Use 'run_get_data.py' to get the csv data and store it in MongoDB.

Use 'nupic/runner.py' to perfrom HTM on the data. This will generate an output that as default will be in 'data/nupic.res.csv'

Use this in any program you want to evaluate your system!

I have included a postProcessing.m file under the matlab folder to illustrate some of the things you could do!
