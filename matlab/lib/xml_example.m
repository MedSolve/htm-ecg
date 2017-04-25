% xml example 

clear
close all

addpath(genpath(pwd))
[filename, pathname ] = uigetfile({'*.xml'});

fullFileName = strcat(pathname,filename);

% 
XMLstruct = ParseXMLFcn(fullFileName);

% I xmlstruct er fielded