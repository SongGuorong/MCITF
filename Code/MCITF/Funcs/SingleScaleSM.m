function salmap_single = SingleScaleSM(im,edw,inds,test_inst_label,S1,H,fgWeight)

Y = (test_inst_label{1})';      
Lamda = 1;
Theta = 4;
S = S1\(Y+Theta*fgWeight+Lamda*H);  % Eq.15

S = normalize(S);  % normalize to [0,1]

[w,h,~]=size(im);  
spnum = size(inds,1); 
salmap = zeros(w,h);
for i=1:spnum
    salmap(inds{i})=S(i);  
end

salmap_single = zeros(edw(1),edw(2));
salmap_single(edw(3):edw(4),edw(5):edw(6)) = salmap;

end
