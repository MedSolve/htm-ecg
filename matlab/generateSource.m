% storage path
storePath = 'data/nupi.source.csv';

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

% loop the source
for i=1:length(list)
    
    % Get the xml struct
    XMLstruct = ParseXMLFcn([list(i).folder '/' list(i).name]);
    
    data = XMLstruct;
    
    % Write results
    %csvwrite(storePath,data,i+1)
end
