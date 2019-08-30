function gaborResponse = gabor_maxResponse(grayim,filtext_G5,options)

gabor_response = zeros(size(grayim,1)*size(grayim,2),size(filtext_G5,3));
for k = 1:size(filtext_G5,3)
    tmp = imfilter(double(grayim),filtext_G5(:,:,k),'replicate');
    gabor_response(:,k) = tmp(:);
end

if strcmp(options,'G5')        % strfind(options, 'G5') 
    gabor_response_G5 = zeros(size(grayim,1)*size(grayim,2),5);
    % pick the *absolute* maximum response
    gabor_response_G5(:,1) = max(abs(gabor_response(:,1:8)),[],2);
    gabor_response_G5(:,2) = max(abs(gabor_response(:,9:16)),[],2);
    gabor_response_G5(:,3) = max(abs(gabor_response(:,17:24)),[],2);
    gabor_response_G5(:,4) = max(abs(gabor_response(:,25:32)),[],2);
    gabor_response_G5(:,5) = max(abs(gabor_response(:,33:40)),[],2);
    
    gabor_response = gabor_response_G5;
end

L = sum(gabor_response' .^2)';    
L = sqrt(L);
sc = log(1 + L / 0.03);
numerator = bsxfun(@times,gabor_response,sc);
gabor_response = bsxfun(@rdivide,numerator,L+eps);  

[rows,cols] = size(grayim);
gaborResponse = zeros(rows,cols,5);
for i = 1:5
    gaborResponse(:,:,i) = reshape(gabor_response(:,i),[rows,cols]);
end


end