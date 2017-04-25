%%
% takes input in the form 
% ECG = [I II III aVR aVL aVF V1 V2 V3 V4 V5 V6]
function ECGstruct = ECG2StructFcn_v2(ECG)

% initial value only
if length(ECG) == 1
    I = zeros(600,1);II = zeros(600,1);III = zeros(600,1);
    aVR = zeros(600,1);aVL = zeros(600,1);aVF= zeros(600,1);
    V1 = zeros(600,1);V2 = zeros(600,1);V3 = zeros(600,1);
    V4= zeros(600,1);V5 = zeros(600,1);V6 = zeros(600,1);
else
    I = ECG(:,1);II = ECG(:,2);III = ECG(:,3);
    aVR = ECG(:,4);aVL = ECG(:,5);aVF = ECG(:,6);
    V1 = ECG(:,7);V2 = ECG(:,8);V3 = ECG(:,9);
    V4 = ECG(:,10);V5 = ECG(:,11);V6 = ECG(:,12);
end

% number of values
nObs = length(ECG);

ECG12Lead = [I,II, III, aVR, aVL, aVF, V1,V2,V3,V4,V5,V6];
cabreraLeads = [aVL,I,-aVR,II,aVF,III,V1,V2,V3,V4,V5,V6];

headersAll{1,1} = {'I','II','III','aVR','aVL','aVF','V1','V2','V3','V4','V5','V6'};
headersCabrera{1,1} = {'aVL','I','-aVR','II','aVF','III','V1','V2','V3','V4','V5','V6'};

% Used for plotting 12-lead ECG. Order will be:
% aVL I -aVR II aVF III V1-V6 assuming the use of ECG.cabrera
plotOrderCabrera=[1 4 7 10 2 5 8 11 3 6 9 12];

plotOrderStandard = [1 4 7 10 2 5 8 11 3 6 9 12];

ECGstruct = struct('ECG12Leads',ECG12Lead,'cabrera',cabreraLeads,'I',I,'II',II,...
    'III',III,'aVR',aVR,'aVL',aVL,'aVF',aVF,...
    'V1', V1,'V2',V2,'V3',V3,'V4',V4,'V5',V5,'V6',V6,...
    'headersECG12Lead',headersAll,'headersCabrera',headersCabrera,'nObs',nObs,...
    'plotOrderCabrera',plotOrderCabrera,...
    'plotOrderStandard',plotOrderStandard...
    );
    
