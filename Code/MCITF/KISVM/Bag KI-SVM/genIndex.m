function [train_indces, test_indces] = genIndex(y)

positive = find(y==1);
negative = find(y~=1);

train_indces = cell(1,10);
test_indces = cell(1,10);

CV=10;
bagLen=length(positive)+length(negative);

CV_size=round(bagLen/CV-0.5);
CV_size_last=bagLen-CV_size*(CV-1);

if CV_size_last>CV_size
    CV_size=CV_size+1;
end

pos_size=length(positive);
neg_size=length(negative);
pos_random=randperm(pos_size);
neg_random=randperm(neg_size);

pos_CV_size=round(pos_size/bagLen*double(CV_size));
neg_CV_size=round(neg_size/bagLen*double(CV_size));

if pos_CV_size+neg_CV_size>CV_size
    flag=1;
    neg_CV_size=neg_CV_size-1;
else
    flag=0;
end

for i=1:CV
    if i~=CV
        if flag==0
            pos_index = positive(pos_random((i-1)*pos_CV_size+1:i*pos_CV_size));
            neg_index = negative(neg_random((i-1)*neg_CV_size+1:i*neg_CV_size));
        else
            pos_index = positive(pos_random((round(i/2)-1)*CV_size+(1-(-1)^(2*(i/2-0.5)))/2*pos_CV_size+1:(round(i/2-0.5))*CV_size+(1+(-1)^(2*(i/2-0.5)))/2*pos_CV_size));
            neg_index = negative(neg_random((round(i/2)-1)*CV_size+(1-(-1)^(2*(i/2-0.5)))/2*neg_CV_size+1:(round(i/2-0.5))*CV_size+(1+(-1)^(2*(i/2-0.5)))/2*neg_CV_size));
        end
    else
        if flag==0
            pos_temp=double((i-1)*pos_CV_size+1);
            neg_temp=double((i-1)*neg_CV_size+1);
            pos_index = positive(pos_random(pos_temp:end));
            neg_index = negative(neg_random(neg_temp:end));
        else
            pos_temp=double((round(i/2)-1)*CV_size+(1-(-1)^(2*(i/2-0.5)))/2*pos_CV_size+1);
            neg_temp=double((round(i/2)-1)*CV_size+(1-(-1)^(2*(i/2-0.5)))/2*neg_CV_size+1);
            pos_index = positive(pos_random(pos_temp:end));
            neg_index = negative(neg_random(neg_temp:end));
        end
    end
    
    testIndex=[pos_index, neg_index];
    testIndex = sort(testIndex);
    trainIndex=1:bagLen;
    trainIndex(testIndex)=[];
    %save(['index',num2str(i),'.mat'],'trainIndex','testIndex');
    
    train_indces{i} = trainIndex;
    test_indces{i} = testIndex;
end