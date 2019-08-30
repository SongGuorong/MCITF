function [y,best_value] = Find_y(alpha,y_train,K_train,cand_y_set,inx,pos)


for i = 1:size(cand_y_set,1)
    tmpy = cand_y_set(i,:);
    value = cal_value(alpha,y_train,K_train,inx,tmpy,1,pos);
    
    if i == 1
        best_value = value;
        y = cand_y_set(i,:);
    elseif value > best_value
        best_value = value;
        y = cand_y_set(i,:);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% greedy search
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

times = 1;
t = 1;
ff = 1;
while t<= times && ff == 1
    ff = 0;
    for i = 1:pos
        ix1 = find(y(inx(i):inx(i+1)-1));
        y(inx(i)+ix1-1)  = 0;
        tmax = cal_matrix(alpha,y_train,K_train,inx,i,y);
        [v,ix2] = max(tmax);
        y(inx(i)+ix2-1)  = 1;
        
        value = cal_value(alpha,y_train,K_train,inx,y,1,pos);
        
        if ix1 ~= ix2
            ff = 1;
%             disp(value);
        end
    end    
    t = t+1;
end

    function value1 = cal_value(alpha,y_train,K,inx,tmpy,sp,ep)
        
        ay = alpha'.* y_train;
        n = length(ay);
        inxx = find(tmpy);
        value1 = ay*K(inxx,inxx)*ay';        
    end
    


    function tmax = cal_matrix(alpha,y_train,K_train,inx,i,tmpy)
        ay = alpha'.* y_train;
        n = length(ay);
        mt = inx(i+1)-inx(i);
        inxx  = logical(tmpy);
        subay = ay;
        subay(i) = [];
        tmax = 2*K_train(inx(i):inx(i+1)-1,inxx)*subay'*ay(i);
        for i1 = 1:mt
            tmax(i1) = tmax(i1) + ay(i)*ay(i)*K_train(inx(i)+i1-1,inx(i)+i1-1);
        end
    end

end
