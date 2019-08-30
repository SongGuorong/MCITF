function B = ReadDAT(image_size,data_path)
% $Description:
%    -read the superpixel labels from .dat file
% $Agruments
% Input;
%    -image_size: [width height]
%    -data_path: the path of the .dat file 
% Output:
%    -label matrix width*height 标签矩阵

row = image_size(1);
colomn = image_size(2);
fid = fopen(data_path,'r'); % 以只读的方式打开文件
A = fread(fid, row * colomn, 'uint32')'; % A(1*(row*colomn))double(从0开始)转置
A = A + 1;  % mex文件从0-(multiscale-1)，matlab从1开始
B = reshape(A,[colomn, row]); % C按行读取，matlab按列读取
B = B';                       % 转置成图片大小
fclose(fid);