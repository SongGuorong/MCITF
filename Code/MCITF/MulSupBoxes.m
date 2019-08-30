function [superlabels,bbs] = MulSupBoxes(image,multiscale,model,opts)

img_out = ChangeFormat(image);     
Im = im2double(img_out);                   % input_im(double)[0,1]
bbs = edgeBoxes(Im,model,opts);    
superlabels = MulSup(img_out,multiscale);  % generate superixel by LSC
if isempty(bbs)
    DAMF_I = DAMF(image);             % reduce the effect of high-density noise
    DAMF_out = ChangeFormat(DAMF_I);  
    DAMF_Im = im2double(DAMF_out);
    bbs = edgeBoxes(DAMF_Im,model,opts);
    superlabels = MulSup(DAMF_out,multiscale);
end

end