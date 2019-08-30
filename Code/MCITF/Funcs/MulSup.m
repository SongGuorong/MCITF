function superlabels = MulSup(image,multiscale)
% Im : input image
% imname : the name of input image
% multiscale : the number of superpixels in each scale
% superlabels : the label of superpixels in each scale
%------------------------------------------------------%
superlabels = cell(length(multiscale),1);  
for scale = 1:length(multiscale)
    spnumber = multiscale(scale);              % the number of superpixels
    gaus=fspecial('gaussian',3);
    I=imfilter(image,gaus);
    ratio=0.075;
    superpixels=LSC_mex(I,spnumber,ratio);
    superlabels{scale} = double(superpixels);  
end


end
