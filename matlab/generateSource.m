% configuration
storePath = 'data/nupi.source.csv';
samplingFreq = 500;
width = 185;
hight = 96;

% write csv start
fid = fopen(storePath, 'w') ;
fprintf(fid, '%s,', 'recordNum');
fprintf(fid, '%s,', 'bucketIdx');
fprintf(fid, '%s,', 'actValue');
fprintf(fid, '%s', 'raw');
fclose(fid);

% Get the folder for data source
source = uigetdir;

% get files of source
list = dir([source '/*.xml']);

% keep track of global sample number
sampleNumber = 0;

% loop the source
for i=1:length(list)
    
    % Get the xml struct
    XMLstruct = ParseXMLFcn([list(i).folder '/' list(i).name]);
    
    % The data source
    ecgSource = XMLstruct.RhythmECG.II;
    
    % get the spans
    spans = getComplex(ecgSource, samplingFreq, width, hight);
    
    %  determine person and set bucket index
    bucketIdx = str2num(XMLstruct.TestInfo.PatientID);
    
    % num spans
    numSpans = size(spans);
    
    % Loop the spans
    for j=1:numSpans(1)
        
        % increment sample number
        sampleNumber = sampleNumber + 1;
        
        % se variables and calculate actual value
        recordNum = sampleNumber;
        actValue = bucketIdx + 1/recordNum;
        
        % get the raw value
        raw = spans(j,:);
        
        % write result
        csvwrite(storePath,[recordNum, bucketIdx, actValue, raw],i+1);
    end
end

% Get complex spans from source
function res = getComplex(source, samplingFreq, width, hight)

% use pan tomking to get r wave
[~,idx,~] = pan_tompkin(source, samplingFreq, 0);

% close all plots
close all

% set pre and post and remove out of bounds CONFIGURABLE
pre = idx-width; pre = pre(pre>=1);
post = idx+width; post = post((1+length(post)-length(pre)):end);
post = post(post<=length(source));
pre = pre(1:length(post));

% the scale for encoding
top = max(source);
bot = min(source);

% create the empty span
res = zeros(length(pre),width*2*hight);

% loop all heart beats till end not above ()
for i=1:length(pre)
    
    % save the raw value notice the minux one because of index 0 correction
    out = imageMap(source(pre(i):(post(i)-1)), bot, top, hight);
    
    res(i,:) = out;
end
end