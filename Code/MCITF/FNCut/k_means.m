function [R, M] = k_means(X, K, seed)
%KMEANS:  K-means clustering
%  idx = KMEANS(X, K) returns M with K columns, one for each mean.  Each
%      column of X is a datapoint.  K is the number of clusters
%  [idx, mu] = KMEANS(X, K) also returns mu, a row vector, R(i) is the
%      index of the cluster datapoint X(:, i) is assigned to.
%  idx = KMEANS(X,K) returns idx where idx(i) is the index of the cluster
%      that datapoint X(:,i) is assigned to.
%  [idx,mu] = KMEANS(X,K) also returns mu, the K cluster centers(聚类中心).
%
%  KMEANS(X, K, SEED) uses SEED (default 1) to randomise initial
%  assignments.(初始化)

if ~exist('seed', 'var'), seed = 1; end

%
%  Initialization
%
[D,N] = size(X);
% if D>N, warning(sprintf('K-means running on %d points in %d dimensions\n',N,D)); end;

M = zeros(D, K);
Dist = zeros(N, K);
M(:, 1) = X(:,seed); 
Dist(:, 1) = sum((X - repmat(M(:, 1), 1, N)).^2, 1)'; 
for ii = 2:K
  % maximum, minimum dist
  mindist = min(Dist(:,1:ii-1), [], 2);
  [junk, jj] = max(mindist);
  M(:, ii) = X(:, jj);
  Dist(:, ii) = sum((X - repmat(M(:, ii), 1, N)).^2, 1)';
end

% plotfig(X,M);
X2 = sum(X.^2,1)';
converged = 0;
R = zeros(N, 1);
while ~converged
  distance = repmat(X2,1,K) - 2 * X' * M + repmat(sum(M.^2, 1), N, 1);
  [junk, newR] = min(distance, [], 2);
  if norm(R-newR) == 0
    converged = 1;
  else
    R = newR;
  end
  total = 0;
  for ii = 1:K
    ix = find(R == ii);
    M(:, ii) = mean(X(:, ix), 2);
    total = total + sum(distance(ix, ii));
  end
% plotfig(X,M);
%   fprintf('Distance %f\n', total);
end
% pause; close all;
return

function plotfig(x,M),
	figure; plot(x(1,:),x(2,:),'go', 'MarkerFaceColor','g', 'LineWidth',1.5); hold on; plot(M(1,:),M(2,:),'rx','MarkerSize',12, 'LineWidth',2);
	w = 2.15; h = 2;
	for k=1:size(M,2),
		rectangle('Position',[M(1,k) M(2,k) 0 0]+w*[-1 -1 +2 +2], 'Curvature',[1 1], 'EdgeColor','r', 'LineWidth',2);
	end;
	xlim([floor(min(x(1,:))) ceil(max(x(1,:)))]);
	ylim([floor(min(x(2,:))) ceil(max(x(2,:)))]);
return


