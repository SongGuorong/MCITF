function [codeMap,P] = MRAELBP(grayim)
% Median Robust Adjacent Evaluation of Local Binary Pattern
% improved LBP texture feature

% code author: Guorong Song
% Email: grs59680@gmail.com
% Date: 1/4/2019

%% Radius and Neighborhood
R=2; P=16;    
%% Genearte mapping
% patternMappingriu2 = getmappingNew(P,'riu2');  % code patterns
load('./MRAELBP/R2.mat');

% if R == 1
%     load('.\\MRAELBP\\R1.mat'); 
% elseif R == 2
%     load('.\\MRAELBP\\R2.mat');
% else
%     load('.\\MRAELBP\\R3.mat');
% end

numLBPbins = patternMappingriu2.num;                       % numLBPbins = P+2
grayim = (grayim-mean(grayim(:)))/std(grayim(:))*20+128;   % image normalization to remove global intensity
grayim = padarray(grayim,[R+1 R+1],'symmetric','both');    % t-symmetric pad matrix (t=R+1)  
%% MRAELBP_C
% *********************************************************************
imgExt = padarray(grayim,[1 1],'symmetric','both'); 
imgblks = im2col(imgExt,[3 3],'sliding');           % w x w (3x3)
imgMedian = median(imgblks);                        % median filter
imgCurr = reshape(imgMedian,size(grayim));          
% *********************************************************************
CImg = imgCurr(R+2:end-(R+1),R+2:end-(R+1));   
CImg = CImg(:) >= mean(CImg(:));                

%% MRAELBP_S,MRAELBP_M
% each column of imgblks represent a feature vector
[SImg,MImg] = NILBP_Image(imgCurr,P,R,patternMappingriu2,'x');  
% codemap
codeMap = zeros(size(SImg));
CImg = double(CImg);
SIdx = cell(numLBPbins,1);
MIdx = cell(numLBPbins,1);
CIdx = cell(2,1);

for i = 1:numLBPbins
    SIdx{i} = find(SImg(:) == i-1);
    MIdx{i} = find(MImg(:) == i-1);
end
for j=1:2
    CIdx{j} = find(CImg(:) == j-1);
end

count = 0;
for k = 1:2
    for j = 1:numLBPbins
        for i = 1:numLBPbins
            pixels = intersect(intersect(SIdx{i},MIdx{j}),CIdx{k}); 
            codeMap(pixels) = count;
            count = count + 1;
        end
    end
end
 
end


