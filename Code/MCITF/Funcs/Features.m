function [inds,lab_vals,fgProb,sup_feat] = Features(im,superpixels,filterKernel)

[w,h,dim] = size(im);               
input_vals = reshape(im, w*h, dim);   
spnum = max(superpixels(:));      

%% CIE-Lab color space
rgb_vals=zeros(spnum,1,3);
inds = cell(spnum,1);           
for i=1:spnum
    inds{i}=find(superpixels==i); 
    rgb_vals(i,1,:)=mean(input_vals(inds{i},:),1);
end
lab_vals = colorspace('Lab<-', rgb_vals);
lab_vals=reshape(lab_vals,spnum,3);

%% boundary probability Eq.10
bdIds = GetBndPatchIds(superpixels);
adjcMatrix = GetAdjMatrix(superpixels,spnum); 
colDistM = GetDistanceMatrix(lab_vals);
[~, ~, meanMin2] = GetMeanMinAndMeanTop(adjcMatrix, colDistM, 0.01); 
clipVal = meanMin2;
geoSigma = 7;       
bdCon = BoundaryConnectivity(adjcMatrix, colDistM, bdIds, clipVal, geoSigma, true);
bdConSigma = 1; % sigma for converting bdCon value to background probability 
fgProb = exp(-bdCon.^2 / (2 * bdConSigma * bdConSigma)); % Estimate fg probability
 
%% 83-dim texture features
imsegs.nseg=spnum;                                    % the number of superpixels
imsegs.segimage=superpixels;   
imsegs.adjmat=AdjcProcloop(superpixels,spnum);        % the adjacent matrix
imdata = drfiGetImageData(im,filterKernel);           % prepare data for feature generate
pbgdata = drfiGetPbgFeat(imdata);                     % data of the pesudo-background 
spdata = drfiGetSuperpixelData(imdata,imsegs);
sp_sal_data = drfiGetRegionSaliencyFeature(imsegs,spdata,imdata,pbgdata); % saliency feature of each superpixel
sup_feat = normalize(sp_sal_data);                                        % the feature matrix F


end

