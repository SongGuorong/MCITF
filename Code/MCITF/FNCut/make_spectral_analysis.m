function [B,evec,evals,DD2_i] = make_spectral_analysis(W,L,lambda)

N=size(W,1); 

%% compute the matrix B
dd = sum(W); D = sparse(1:N,1:N,dd); clear dd; % D-degree matrix

% (1-lambda)*(D-lambda*W)^-1
dd = (1-lambda)*(D-lambda*W)\ones(N,1); 
dd = sqrt(dd); 
DD2_i = sparse(1:N,1:N,1./dd); 
DD2 = sparse(1:N,1:N,dd);      
clear dd;                     
B = DD2*(D-lambda*W)*DD2; 

%% compute eigenvectors 
opts.isreal = 1; 
opts.disp = 0; 
opts.p = 2*L;   % added parameter
mn_set = 0;

[V,ss] = eigs(B,L,mn_set,opts); 
s = real(diag(ss)); 
[x,y] = sort(s);    
evals = 1./abs(x);
evec = V(:,y);

end

