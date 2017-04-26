% Read source and return a bitmapish of that normalized to top and bot
% This is not very effective but does it purpose of creating an image
% the breaking it down into the bitmapish
function bitmap = imageMap(src, bot, top, xM)

% get length of source
yM = length(src);

% create empty data matrix
data = zeros(yM, xM);

% create search space and scale
scale = (top-bot)/xM;
space = (bot+1):scale:top; % +1 to secure correct number of steps

% create image by going through all pixels
for i = 1:yM
    
    % get the index
    idx = encodeBit(src(i), space);
    % set the binery value to 1
    data(i,idx) = 1;
end

% get size bounderies
[yM, xM] = size(data);

% create reference to bitmap
bitmap = zeros(1, yM*xM);

%create a vector by loop the dataset
for i = 1:yM
    bitmap((i-1)*xM+1:i*xM) = data(i,:);
end
end

% encodes the bit to its corrospoinding y value with a given resolution
function idx = encodeBit(bit, space)

    tmp = abs(space-bit);
    [~, idx] = min(tmp); %index of closest value

end
