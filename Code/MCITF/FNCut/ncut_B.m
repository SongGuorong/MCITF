function [labels,new_evec] = ncut_B(evec,DD2_i,L,N)
%% sort eigenvectors & eigenvalues
%% k-means clustering for only pixel layer 
evec = DD2_i * evec; 
new_evec = evec(1:N,:); 
for i=1:size(new_evec,1)
    new_evec(i,:)=new_evec(i,:)/(norm(new_evec(i,:))+1e-10);
end
labels = k_means(new_evec',L);  

end