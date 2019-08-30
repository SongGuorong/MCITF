function [SImg,MImg] = NILBP_Image(img,lbpPoints,lbpRadius,mapping,mode)
blocks = cirInterpSingleRadius(img,lbpPoints,lbpRadius); 
blocks = blocks'; 
imgCenter = img(lbpRadius+2:end-(lbpRadius+1),lbpRadius+2:end-(lbpRadius+1)); 
SImg_p = blocks >= repmat(imgCenter(:),1,lbpPoints);     % S_p
MImg_p = abs(blocks - repmat(imgCenter(:),1,lbpPoints)); % M_p
MImg_threshold=mean(MImg_p(:));                          % threshold for M_P
MImg_p = MImg_p >= MImg_threshold;
weight = 2.^(0:lbpPoints-1);
SImg = SImg_p .* repmat(weight,size(blocks,1),1);         
SImg = sum(SImg,2);
MImg = MImg_p .* repmat(weight,size(blocks,1),1);
MImg = sum(MImg,2);

% Apply mapping if it is defined
%% code for MRAELBP_S,MRAELBP_M
if isstruct(mapping)
    bins = mapping.num;    
    sizarray = size(imgCenter);
    SImg = mapping.table(SImg+1); % code 
    MImg = mapping.table(MImg+1); 
    SImg = reshape(SImg,sizarray); 
    MImg = reshape(MImg,sizarray);
end
% % another implementation method
% if isstruct(mapping)
%     bins = mapping.num;
%     for i = 1:size(result,1)
%         for j = 1:size(result,2)
%             result(i,j) = mapping.table(result(i,j)+1);
%         end
%     end
% end

if (strcmp(mode,'h') || strcmp(mode,'hist') || strcmp(mode,'nh'))
    % Return with LBP histogram if mode equals 'hist'.
    SImg = hist(SImg(:),0:(bins-1));
    MImg = hist(MImg(:),0:(bins-1));
    %     result = hist(result(:),0:(bins-1));
    if (strcmp(mode,'nh'))
        %         result = result/sum(result);
        SImg = SImg/sum(SImg);
        MImg = MImg/sum(MImg);
    end
else
    % Otherwise return a matrix of unsigned integers
    % result = reshape(result,size(imgTemp));
%     if ((bins-1) <= intmax('uint8'))
%         SImg = uint8(SImg);
%     elseif ((bins-1) <= intmax('uint16'))
%         SImg = uint16(SImg);
%     else
%         SImg = uint32(SImg);
%     end
end

end






