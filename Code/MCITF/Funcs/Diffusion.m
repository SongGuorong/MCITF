function [S,H,fgWeight] = Diffusion(im,segnum,superlabels,superpixels,lab_vals,inds,fgProb)
%% get segments by FNCut (larger blocks)
[fncut_label,~] = FNCut(im,segnum,superlabels);
%% affinity entry W_ij 
spnum=max(superpixels(:));          
adjloop=AdjcProcloop(superpixels,spnum); 
edges=[];
for i=1:spnum
    indext=[];
    ind=find(adjloop(i,:)==1);  
    for j=1:length(ind)
        indj=find(adjloop(ind(j),:)==1); 
        indext=[indext,indj];
    end
    indext=[indext,ind];       
    indext=indext((indext>i));  
    indext=unique(indext);  
    if(~isempty(indext))
        ed=ones(length(indext),2);
        ed(:,2)=i*ed(:,2);  
        ed(:,1)=indext;     
        edges=[edges;ed];
    end
end
theta=10; % Sigma_c.^2 =0.05 
weights = makeweights(edges,lab_vals,theta); 
W = adjacency(edges,weights,spnum);
%% the new affinity matrix V
b=zeros(spnum,spnum);
merged_supNum = max(max(fncut_label));  
merged_regions = calculateRegionProps(merged_supNum,fncut_label);
allregions(1) = {inds};      
allregions(2) = {merged_regions}; 
allsulabel(1) = {superpixels};  
allsulabel(2) = {fncut_label};
connections = findHierarchy(allregions,allsulabel); 
for i=1:merged_supNum
    temp=connections{i};
   for j=1:length(temp)
       for jj=1:length(temp)
           if temp(j)~=temp(jj)
              b(temp(j),temp(jj))=1;  % the same subregion
           end
       end
   end
end
%% Mid-level feature
[w,h] = size(superpixels); 
colDistM = GetDistanceMatrix(lab_vals);
meanPos = GetNormedMeanPos(inds, w, h); 
posDistM = GetDistanceMatrix(meanPos); 
posDistM(posDistM > 3 * 0.4) = Inf;                % cut off > 3 * sigma distances
posWeight = exp(-posDistM.^2 ./ (2 * 0.4 * 0.4));  % Sigma_r=0.4
H = colDistM .* posWeight * ones(spnum, 1);
H = (H - min(H)) / (max(H) - min(H) + eps);        % normalize to [0,1]
D_h = diag(H);
%% object constraint 
fgWeight = CalWeightedContrast(colDistM,posDistM,fgProb);  % U 
%% Saliency assignment
V = W + b;           % affinity matrix V
dii = sum(V,2);  
D_V = diag(dii,0);   % the degree matrix
L_M = D_V - V;       % Laplacian matrix  
Miu = 5;
Lamda = 1;
Gama = 1;
Theta = 4;
bgProb = 1-fgProb;      % background probability 
Bg = diag(bgProb,0);    % D_q
Fg = diag(fgWeight,0);  % D_u
S = eye(spnum) + Miu*L_M + Gama*Bg + Theta*Fg + Lamda*D_h;

end



