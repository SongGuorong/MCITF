function imdata = drfiGetImageData(image,filterKernel) 

%% texture MR8/Schmid(S)/MRAELBP
    % MR8 texture-response of filter bank
%     filtext_RFS = makeRFSfilters;   
    ntext_MR8 = 8;                    
    imdata.ntext_MR8 = ntext_MR8;    
    
    grayim = rgb2gray( image );      
    
    imtext_MR8 = im2filter_response(grayim,filterKernel.filtext_RFS,'MR8');
    imdata.imtext_MR8 = imtext_MR8;
    
    % Schmid texture-response of filter bank
%     filtext_S = makeSfilters;     
    ntext_S = 13;                 
    imdata.ntext_S = ntext_S;      
    
    imtext_S = filt_response(grayim,filterKernel.filtext_S);
    imdata.imtext_S = imtext_S;
    
    % Gabor max texture-response of filter bank
%     filtext_G5 = gaborFilterBank(5,8,39,39);   
    ntext_G5 = 5;                              
    imdata.ntext_G5 = ntext_G5;              
    
    imtext_G5 = gabor_maxResponse(grayim,filterKernel.filtext_G5,'G5'); 
    imdata.imtext_G5 = imtext_G5;
    
    % Gabor & Schmid filter max response histogram of the texture
    imtext_SG = cat(3,imtext_S,imtext_G5);
    ntext_SG = 18;
    imdata.ntext_SG = ntext_SG;
    [~, texthist] = max(imtext_SG, [], 3); 
    imdata.texthist = texthist;         % Gabor & Schmid filter max response histogram
    
    % texture - MRAELBP  
    [imMRAElbp,P] = MRAELBP(grayim);    % range [0,2*(P+2)*(P+2)-1] 
    imdata.nMRAElbp = 2*(P+2)*(P+2);            
    imdata.imMRAElbp = imMRAElbp;

    [imh, imw, ~] = size(image);    
    imdata.imh = imh;  
    imdata.imw = imw;  
   
end





