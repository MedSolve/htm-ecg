function postProcesseing()

% number of predictions made per class
numPred = 3;

% load datasorce
[FileName,PathName,~] = uigetfile('*.csv');

% load csv information
M = csvread([PathName FileName], 1,0);

% Convert the row for to subject id
M(:,4) = floor(M(:,4));

% Check if match is found within the first three probablilities
matchFound = M(:,4) == M(:,2);

% calculate sum math found
sumMatchFound = sum(matchFound);

% display resulting match found
disp(['Number of matches found: ' mat2str(sumMatchFound)])

% Classification accuracy wher
accTotal = (sumMatchFound/length(matchFound))*100;
accCorrected = (sumMatchFound/(length(matchFound)/numPred))*100;

disp(['Accuracy ' sprintf('%.2f',accTotal) ...
    ' Corrected Accuracy ' sprintf('%.2f', accCorrected)
    ])
