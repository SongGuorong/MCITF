function K = normalization_gaussian(ratio,x,xx)

% x: d*n1
% xx: d*n2
% K: n1*n2

[d,n] = size(x);

sigma_mean = sum(sum(repmat(sum(x'.*x',2)',n,1) + repmat(sum(x'.*x',2),1,n) ...
                - 2*x'*x))/n^2;
            
if nargin < 3
    [d,n] = size(x);
    % distance_matrix = repmat(sum(x'.*x',2)',n,1) + repmat(sum(x'.*x',2),1,n) ...
    %             - 2*x'*x;
    % 
    % sigma_mean = sum(sum(distance_matrix))/n^2;

    

    sigma_mean = sigma_mean^0.5;

    sigma = ratio * sigma_mean;

    % x = exp(-distance_matrix/(2*sigma^2));
    K = exp(-(repmat(sum(x'.*x',2)',n,1) + repmat(sum(x'.*x',2),1,n) ...
                 - 2*x'*x)/(2*sigma^2));
else
    [d,n1] = size(x);
    [d,n2] = size(xx);       
    sigma_mean = sigma_mean^0.5;

    sigma = ratio * sigma_mean;

    % x = exp(-distance_matrix/(2*sigma^2));
    K = exp(-(repmat(sum(x'.*x',2),1,n2) + repmat(sum(xx'.*xx',2)',n1,1) ...
                 - 2*x'*xx)/(2*sigma^2));
    
end
%x = 2*x-1;

