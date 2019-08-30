function [y,best_value] = Find_y_linear(alpha,y_train,X,cand_y_set,inx,pos)


if size(cand_y_set,1) > 1000
    rp = randperm(size(cand_y_set,1));
    rp = rp(1:1000);
else
    rp = 1:size(cand_y_set,1);
end

for i = 1:length(rp)
    tmpy = cand_y_set(rp(i),:);
    value = cal_value(alpha,y_train,X,inx,tmpy,1,pos);
    
    if i == 1
        best_value = value;
        y = cand_y_set(rp(i),:);
    elseif value > best_value
        best_value = value;
        y = cand_y_set(rp(i),:);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% greedy search
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tic
times = 1;
t = 1;
ff = 1;
while t<= times && ff == 1
    ff = 0;
    for i = 1:pos
        ix1 = find(y(inx(i):inx(i+1)-1));
        y(inx(i)+ix1-1)  = 0;
        tmax = cal_matrix(alpha,y_train,X,inx,i,y);
        [v,ix2] = max(tmax);
        y(inx(i)+ix2-1)  = 1;
        
        value = cal_value(alpha,y_train,X,inx,y,1,pos);
        
        if ix1 ~= ix2
            ff = 1;
%             disp(value);
        end
    end
    
    t = t+1;
end

    function value = cal_value(alpha,y_train,X,inx,tmpy,sp,ep)
        ay = alpha'.* y_train;
        n = length(ay);
        inxx = find(tmpy);
        value1 = ay*X(:,inxx)';
        value = value1*value1';
        
    end
    



    function tmax = cal_matrix(alpha,y_train,X,inx,i,tmpy)
        ay = alpha'.* y_train;
        n = length(ay);
        mt = inx(i+1)-inx(i);
        subXA = X(:,inx(i):inx(i+1)-1);
        inxx  = find(tmpy);
        subXB = X(:,inxx);
        subay = ay;
        subay(i) = [];
        tmax = 2*subXA'*subXB*subay'*ay(i);
        for i1 = 1:mt
            tmax(i1) = tmax(i1) + ay(i)*ay(i)*X(:,inx(i)+i1-1)'*X(:,inx(i)+i1-1);
        end
        
    end

end
