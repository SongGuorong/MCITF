function weights=makeweights(edges,vals,valScale)
% 计算相邻超像素的vals特征距离
% n=size(vals,2);
% for i=1:n
%     vals(:,i)=normalize(vals(:,i));
% end
% valDistances=0.3*normalize(sqrt(sum((vals(edges(:,1),:)-vals(edges(:,2),:)).^2,2)))+0.7*normalize(sqrt(sum((rgb_vals(edges(:,1),:)-rgb_vals(edges(:,2),:)).^2,2)));
valDistances=sqrt(sum((vals(edges(:,1),:)-vals(edges(:,2),:)).^2,2));
valDistances=normalize(valDistances); %Normalize to [0,1]
weights=exp(-valScale*valDistances);
