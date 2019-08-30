function pbgdata = drfiGetPbgFeat( imdata )
% get probable background feature 
% the probable background is estimated as the border near image edge

borderwidth = floor( 15 * max(imdata.imh, imdata.imw) / 400 ); 

% get pixels in the probable background
h = imdata.imh;  
w = imdata.imw;  

pixels = (1 : h * borderwidth)';
pixels = [pixels;(h*w : -1 : (h*w - borderwidth*h +1))'];
n = 16 : w - 15;

y1 = 1 : 15;
y2 = h-14 : h;
[nn1,yy1] = meshgrid( n, y1 );
ny1 = (nn1 - 1) * h + yy1;
pixels = [pixels; ny1(:)];
[nn2,yy2] = meshgrid( n, y2 );
ny2 = (nn2 - 1) * h + yy2;
pixels = [pixels; ny2(:)];          
%% texture MR8/Schmid(S)/MRAELBP
% MR8
pbgdata.texture_MR8 = zeros(imdata.ntext_MR8, 1);   % MR8 boundary response
for ix = 1 : imdata.ntext_MR8
    pbgdata.texture_MR8(ix, 1) = mean( imdata.imtext_MR8(pixels + (ix-1) * w * h) );
end

% Schmid
pbgdata.texture_S = zeros(imdata.ntext_S, 1);       % Schmid boundary response
for ix = 1 : imdata.ntext_S
    pbgdata.texture_S(ix, 1) = mean( imdata.imtext_S(pixels + (ix-1) * w * h) );
end

% Gabor
pbgdata.texture_G5 = zeros(imdata.ntext_G5, 1);      % Gabor boundary response
for ix = 1 : imdata.ntext_G5
    pbgdata.texture_G5(ix, 1) = mean( imdata.imtext_G5(pixels + (ix-1) * w * h) );
end

% Gabor & Schmid filter max response histogram
pbgdata.textureHist = zeros(imdata.ntext_SG, 1); 
pbgdata.textureHist = hist( imdata.texthist(pixels), 1:imdata.ntext_SG )';
pbgdata.textureHist = pbgdata.textureHist / max( sum(pbgdata.textureHist), eps );

% MRAELBP
pbgdata.MRAElbpHist = zeros(imdata.nMRAElbp, 1);
pbgdata.MRAElbpHist = hist( imdata.imMRAElbp(pixels), 0:(imdata.nMRAElbp-1) )';
pbgdata.MRAElbpHist = pbgdata.MRAElbpHist / max( sum(pbgdata.MRAElbpHist), eps );

end






