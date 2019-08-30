clear; clc;
addpath(genpath('.'));               
imgRoot='.\Image\';                  % path of test image
imnames=dir([imgRoot '*' '.bmp']);   
saldir = '.\OUT\';                   % path of saliency map
if ~isfolder(saldir)
    mkdir(saldir);
end
%% Parameter settings
multiscale = [150 250 350];   % 3 layers of superpixels 
segnum = 25;                  % the number of the segments in FNCut
% parameter of EdgeBoxes  
model=load('EdgeBox/models/forest/modelBsds'); model=model.model;
model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;
opts = edgeBoxes;     
opts.alpha = .65;     
opts.beta  = .75;     
opts.minScore = .01;  
opts.maxBoxes = 1e4;
% parameters of Bag-KI-SVM
para.gaussian = 0;  % 0 means liner kernel
para.ratio = 1;
para.im_ratio = 1;
para.C = 1;
% parameters of texture feature bank
filterKernel.filtext_RFS = makeRFSfilters;               % MR8 texture-response of filter bank
filterKernel.filtext_S = makeSfilters;                   % Schmid texture-response of filter bank
filterKernel.filtext_G5 = gaborFilterBank(5,8,39,39);    % Gabor max texture-response of filter bank

%% MCITF
parfor INum = 1:length(imnames)    % parallel computation
    % Read image
    disp(INum);
    imname = [imgRoot imnames(INum).name];    
    image = imread(imname);                  
    [w,h,dim] = size(image);                 
    img_out = ChangeFormat(image);          
    [Im,edw,sup_img] = removeframe(img_out);    % remove the frame of image 
    scale_map = zeros(w,h,length(multiscale));
    % generate superpixels using LSC; candidate object proposals using Edge Boxes
    [superlabels,bbs] = MulSupBoxes(sup_img,multiscale,model,opts); 
    %% Multiscale saliency maps
    for scale = 1:length(multiscale)
        superpixels = superlabels{scale};    
        %% Extract 83-dim texture features for each superpixel
        [inds,lab_vals,fgProb,sup_feat] = Features(Im,superpixels,filterKernel); 
        %% Select high score proposals based on two criteria
        [bbssel,bbssel_inds] = ProposalSel(Im,bbs,fgProb,superpixels,inds);
        %% Positive and Negative Bags Construction 
        [pos_bag,neg_bag,traindata,testdata] = BagCons(Im,bbssel,bbssel_inds,sup_feat,inds);  
        %% get estimated label of test samples using Bag-KI-SVM
        [test_bag_label, test_inst_label, test_bag_pre, test_ins_pre] = Bag_KI_SVM(para,traindata, testdata); 
        %% Diffusion function  
        [S1,H,fgWeight] = Diffusion(Im,segnum,superlabels,superpixels,lab_vals,inds,fgProb);
        %% Saliency assignment for single scale
        scale_map(:,:,scale) = SingleScaleSM(Im,edw,inds,test_inst_label,S1,H,fgWeight);
    end
    %% Final saliency map
    finalmap = mat2gray(sum(scale_map,3)); % Compute multi-scale saliency map
    imwrite(finalmap,[saldir,imname(9:end-4),'.jpg']);
    
end



