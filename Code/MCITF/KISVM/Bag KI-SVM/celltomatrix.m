function [x,y,inx,pos,inx2] = celltomatrix(data)
%celltomatrix process the input data
%    Syntax
%
%       function [x,y,inx,pos,inx2] = celltomatrix(data)
%
%    Description 
%       celltomatrix takes
%         data:         An N * 2 cell

%    and returns
%          x:    An d*n instance, instance matrix, where d is the dimension and
%                ninstance is the number of instances
%          y:    labels, ninstance*1
%          pos:  the number of positive bags
%          inx:  An 1*(ninstance-pos+1) array. 
%          inx2: An 1*(nbag+1) array, the indeces of bags. inx(1) = 1; inx(i+1)=
%               inx(i) + n_i; where n_i is the number of instance in ith
%               bag

nbag = size(data,1);    
ninstance = 0;          

pos = 0;                
inx(1) = 1;
k = 1;
inx2 = zeros(1,nbag+1);
inx2(1) = 1;
for i = 1:nbag
    [tmpn,d] = size(data{i,1});
    ninstance = ninstance + tmpn;
    inx2(i+1) = inx2(i) + tmpn;
    
    if data{i,2} > 0
        pos = pos+1;
        inx(k+1) = inx(k)+tmpn;
        k = k+1;
    else
        inx(k+1:k+tmpn) = inx(k)+(1:tmpn);
        k = k+tmpn;
    end
end

x = zeros(ninstance, d);
y = zeros(ninstance, 1);

for i = 1:nbag
    x(inx2(i):inx2(i+1)-1,:) = data{i,1};
    if data{i,2} == 0
        y(inx2(i):inx2(i+1)-1) = -1;
    end
end
