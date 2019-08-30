function filResponse = im2filter_response(grayim,filter,options)

filter_response = zeros(size(grayim,1)*size(grayim,2),size(filter,3));
for k = 1:size(filter,3)
    tmp = conv2(double(grayim),filter(:,:,k),'same');
    filter_response(:,k) = tmp(:);
end
if strcmp(options,'MR8')        % strfind(options, 'MR8') 
    filter_response_MR8 = zeros(size(grayim,1)*size(grayim,2),8);
    % pick the *absolute* maximum response
    filter_response_MR8(:,1) = max(abs(filter_response(:,1:6)),[],2);
    filter_response_MR8(:,2) = max(abs(filter_response(:,7:12)),[],2);
    filter_response_MR8(:,3) = max(abs(filter_response(:,13:18)),[],2);
    filter_response_MR8(:,4) = max(abs(filter_response(:,19:24)),[],2);
    filter_response_MR8(:,5) = max(abs(filter_response(:,25:30)),[],2);
    filter_response_MR8(:,6) = max(abs(filter_response(:,31:36)),[],2);
    
    filter_response_MR8(:,7:8) = filter_response(:,37:38);
    filter_response = filter_response_MR8;
end
L = sum(filter_response' .^2)';   
L = sqrt(L);
sc = log(1 + L / 0.03);
numerator = bsxfun(@times,filter_response,sc);
filter_response = bsxfun(@rdivide,numerator,L+eps);   

[rows,cols] = size(grayim);
filResponse = zeros(rows,cols,8);
for i = 1:8
    filResponse(:,:,i) = reshape(filter_response(:,i),[rows,cols]);
end
    
end

