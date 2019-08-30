%function adjcMerge = AdjcProcloop(M,N)
function edges = Adjc(M,N)
% $Description:
%    -compute the adjacent matrix
% $Agruments
% Input;
%    -M: superpixel label matrix     标示每个像素属于哪个超像素的矩阵
%    -N: superpixel number 
% Output:
%    -adjcMerge: adjacent matrix     
%                大小为N*N,第i行标示第i个超像素和哪些相邻，若为1，则标示相邻.(这是一个对角矩阵）

% adjcMerge = zeros(N,N);
%adjcMerge = zeros(N,2);
[m n] = size(M);
edges0 = [];

for i = 1:m-1
    for j = 1:n-1
      if M(i,j)~=0
        if(M(i,j)~=M(i,j+1))&&(M(i,j+1)~=0)
            ed =[M(i,j) M(i,j+1)];
            edges0 =[edges0;ed];
        end;
        if(M(i,j)~=M(i+1,j))&&(M(i+1,j)~=0)
            ed =[M(i,j) M(i+1,j)];
            edges0 =[edges0;ed];
        end;
        if(M(i,j)~=M(i+1,j+1))&&(M(i+1,j+1)~=0)
            ed =[M(i,j) M(i+1,j+1)];
            edges0 =[edges0;ed];
        end;
        if(M(i+1,j)~=M(i,j+1))&&(M(i,j+1)~=0)&&(M(i+1,j)~=0)
            ed =[M(i+1,j) M(i,j+1)];
            edges0 =[edges0;ed];
        end;
      end
    end;
end;    
if isempty(edges0)
     edges = 0;
else
     uedges0 = unique(edges0,'rows');
     uinds = find((uedges0(:,1)<uedges0(:,2)));
     edges = uedges0(uinds,:);
end
% for i = 1:m-1
%     for j = 1:n-1
%       if M(i,j)~=0
%         if(M(i,j)~=M(i,j+1))&&(M(i,j+1)~=0)
%             adjcMerge(M(i,j),M(i,j+1)) = 1;
%             adjcMerge(M(i,j+1),M(i,j)) = 1;
%         end;
%         if(M(i,j)~=M(i+1,j))&&(M(i+1,j)~=0)
%             adjcMerge(M(i,j),M(i+1,j)) = 1;
%             adjcMerge(M(i+1,j),M(i,j)) = 1;
%         end;
%         if(M(i,j)~=M(i+1,j+1))&&(M(i+1,j+1)~=0)
%             adjcMerge(M(i,j),M(i+1,j+1)) = 1;
%             adjcMerge(M(i+1,j+1),M(i,j)) = 1;
%         end;
%         if(M(i+1,j)~=M(i,j+1))&&(M(i,j+1)~=0)&&(M(i+1,j)~=0)
%             adjcMerge(M(i+1,j),M(i,j+1)) = 1;
%             adjcMerge(M(i,j+1),M(i+1,j)) = 1;
%         end;
%       end
%     end;
% end;    
% % 边界超像素，还得计算其与边界四周的相邻关系
% bd=unique([M(1,:),M(m,:),M(:,1)',M(:,n)']);
% for i=1:length(bd)
%     for j=i+1:length(bd)
%         adjcMerge(bd(i),bd(j))=1;
%         adjcMerge(bd(j),bd(i))=1;
%     end
% end
    