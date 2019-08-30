function [test_bag_label, test_inst_label, test_bag_pre, test_ins_pre] = Bag_KISVM_prediction(alpha, y,y_set, beta, inx_train, K_test, inx_test)

%Bag_KISVM_prediction is a convex method for locating Region Of Interest(ROI) with multi-instance learning 
%
%N.B.: Bag_KISVM_prediction employs a new Matlab software (libsvm-mat-2.88-MI-SVM)
%
%    Syntax
%
%       function [test_bag_label, test_inst_label, test_bag_pre,test_ins_pre] = Bag_KISVM_prediction(alpha, y, y_set, beta, inx_train, K_test, inx_test)
%
%    Description
%
%       Bag_KISVM_prediction takes,
%           alpha  - the dual variables of svm  
%           y_set  - An T*N array, where T is number of generated labels of
%           instances and N is the number of instances
%           beta   - A 1*T array, the coefficients of the generated labels 
%           inx_train - the index array of training bags 
%           K_test - kernel matrix between training and testing instances
%           inx_test -  the index array of testing bags
%      and returns,
%           test_bag_label    - An M*1 array, the predicted label of the ith testing bags is stored
%                               in test_bag_label(i)
%           test_inst_label   - An Mx1 cell,  the predicted label of the
%                               jth instance of the ith training bag is stored in the test_inst_label{i,1}(j) 
%           test_bag_pre      - An M*1 array, the prediction of the ith testing bags is stored
%                               in test_bag_label(i)
%           test_ins_pre      - An Mx1 cell,  the prediction label of the
%                               jth instance of the ith training bag is
%                               stored in the test_inst_label{i,1}(j)                             
%
% [1] Y.-F. Li, J. T. Kwok, I. W. Tsang, and Z.-H. Zhou. A convex method for locating regions of interest with multi-instance learning. In: Proceedings of the 20th European Conference on Machine Learning (ECML'09), Bled, Slovenia, 2009. 

n = size(alpha,1);        
n_test = size(K_test,2); 

K_tt = zeros(n,n_test);
for i = 1:length(beta)
    if beta(i) ~= 0
        tmpK = zeros(n,n_test);
        for i1 = 1:n
            tmpinx = find(y_set(i,inx_train(i1):inx_train(i1+1)-1));                
             for i3 = 1:length(tmpinx)
                 tmpK(i1,1:n_test) = tmpK(i1,1:n_test) + y_set(i,inx_train(i1)+tmpinx(i3)-1)*K_test(inx_train(i1)+tmpinx(i3)-1,1:n_test); 
            end
        end
        
        K_tt = K_tt + beta(i)*tmpK;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prediction

y2 = (alpha'.*y)*K_tt;
n_test = length(inx_test)-1;
test_bag_label = zeros(1,n_test);  
test_inst_label = cell(1,n_test); 
test_bag_pre  = zeros(1,n_test);   
test_ins_pre  = cell(1,n_test);   

for i = 1:n_test
    test_ins_pre{i} = zeros(1,inx_test(i+1)-inx_test(i));
    test_inst_label{i} = zeros(1,inx_test(i+1)-inx_test(i));
    
    test_ins_pre{i} = y2(inx_test(i):inx_test(i+1)-1);
    test_inst_label{i} = sign(y2(inx_test(i):inx_test(i+1)-1));  
    
    test_bag_pre(i) = max(y2(inx_test(i):inx_test(i+1)-1));      
    test_bag_label(i) = sign( max(y2(inx_test(i):inx_test(i+1)-1)) );
end


