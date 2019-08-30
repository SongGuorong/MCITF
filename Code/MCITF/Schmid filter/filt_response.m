function filResponse = filt_response(grayim,filter)

filter_response = zeros(size(grayim,1)*size(grayim,2),size(filter,3));
for k = 1:size(filter,3)
    tmp = conv2(double(grayim),filter(:,:,k),'same');
    filter_response(:,k) = tmp(:);
end

L = sum(filter_response' .^2)';    
L = sqrt(L);
sc = log(1 + L / 0.03);
numerator = bsxfun(@times,filter_response,sc);
filter_response = bsxfun(@rdivide,numerator,L+eps);  

[rows,cols] = size(grayim);
filResponse = zeros(rows,cols,13);
for i = 1:13
    filResponse(:,:,i) = reshape(filter_response(:,i),[rows,cols]);
end
    
end

