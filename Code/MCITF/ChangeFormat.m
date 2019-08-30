function img_out = ChangeFormat(img_in)
% change to 3 channels
[~,~,dim] = size(img_in);
if dim~=3
    img_out = cat(3,img_in,img_in,img_in);
else
    img_out = img_in;
end