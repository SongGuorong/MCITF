function [ out ] = normalize( img )
% 将img按列归一化
size0 = size(img,2);
 for i = 1:size0 
     if max(img(:,i))==min(img(:,i))
         img(:,i) = img(:,i);
     else
        img(:,i) = (img(:,i)-min(img(:,i)))/(max(img(:,i))-min(img(:,i)));
     end
 end
 out = img;
 % out=(img-min(img(:)))/(max(img(:))-min(img(:))); % 对矩阵或向量的整体做归一化
end

