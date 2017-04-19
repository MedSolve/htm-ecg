% Read source image and return a bitmap of that
function bitmap = imageMap(src) 

    % get data from src
    data = imread(src);
    
    % get size bounderies
    [yM, xM] = size(data);
    
    % create reference to bitmap
    bitmap = zeros(1, yM*xM);
    clc
    %create a vector by loop the dataset
    for i = 1:yM
        bitmap((i-1)*xM+1:i*xM) = data(i,:);
    end
end