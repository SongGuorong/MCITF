function cand_y_set = Max_Violated_y_set(X,Y,inx,pos)

%%%%%%%%%%%%%%%%%%%%%%%%%
% input
% X:   d*n
% Y: 1*n_train
% inx: index_set
% pos: # of positive bags


[d,n] = size(X);
n_train = length(Y);
%y_theta = 0;

if size(Y,1) > 1
    Y = Y';
end

cand_y_set = zeros(2*d,n);
k = 1;
% knn = 1;
for i = 1:d
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % min
    y = ones(1,n);
    y(1:inx(pos+1)-1) = 0;
    for j = 1:pos
        tmpX = X(i,inx(j):inx(j+1)-1);
        [v,ix] = min(tmpX);
        y(inx(j)+ix-1) = 1;
    end
    cand_y_set(k,:) = y;
    k = k+1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %max
    y = ones(1,n);
    y(1:inx(pos+1)-1) = 0;
    for j = 1:pos
        tmpX = X(i,inx(j):inx(j+1)-1);
        [v,ix] = max(tmpX);
        y(inx(j)+ix-1) = 1;
    end
    cand_y_set(k,:) = y;
    k = k+1;
end


