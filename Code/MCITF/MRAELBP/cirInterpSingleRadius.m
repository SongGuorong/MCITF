function blocks = cirInterpSingleRadius(img,lbpPoints,lbpRadius)

[imgH,imgW] = size(img);       

imgNewH = imgH - 2*(lbpRadius+1);
imgNewW = imgW - 2*(lbpRadius+1);

% the interpolated img
blocks = zeros(lbpPoints,imgNewH*imgNewW);

radius = lbpRadius;
neighbors = lbpPoints;
spoints = zeros(neighbors,2);

% Determine the dimensions of the input image.
[ysize,xsize] = size(img);

% Angle step
angleStep = 2 * pi / neighbors;
for i = 1 : neighbors
    spoints(i,1) = -radius * sin((i-1)*angleStep);
    spoints(i,2) = radius * cos((i-1)*angleStep);
end

miny = min(spoints(:,1));
maxy = max(spoints(:,1));
minx = min(spoints(:,2));
maxx = max(spoints(:,2));

% Block size, each LBP code is computed within angleStep block of size bsizey*bsizex
bsizey = ceil(max(maxy,0)) - floor(min(miny,0))+3; 
bsizex = ceil(max(maxx,0)) - floor(min(minx,0))+3;

% Coordinates of origin (0,0) in the block
origy = 2 - floor(min(miny,0));  
origx = 2 - floor(min(minx,0));

% Minimum allowed size for the input img depends
% on the radius of the used LBP operator.
if(xsize < bsizex || ysize < bsizey)
    error('Too small input img. Should be at least (2*radius+1) x (2*radius+1)');
end

% Calculate dx and dy;
dx = xsize - bsizex;
dy = ysize - bsizey;

%%
for i = 1:neighbors 
    y = spoints(i,1)+origy;
    x = spoints(i,2)+origx;
    % Calculate floors, ceils and rounds for the x and y.
    ry = round(y);
    rx = round(x);
    NE1 = img(ry-1:ry-1+dy,rx-1:rx-1+dx);
    NE2 = img(ry-1:ry-1+dy,rx:rx+dx);
    NE3 = img(ry-1:ry-1+dy,rx+1:rx+1+dx);
    NE4 = img(ry:ry+dy,rx-1:rx-1+dx);
    NE5 = img(ry:ry+dy,rx+1:rx+1+dx);
    NE6 = img(ry+1:ry+1+dy,rx-1:rx-1+dx);
    NE7 = img(ry+1:ry+1+dy,rx:rx+dx);
    NE8 = img(ry+1:ry+1+dy,rx+1:rx+1+dx);
    NE_average = (NE1 + NE2 + NE3 + NE4 + NE5 + NE6 + NE7 + NE8)/8; % a_p_i
    blocks(i,:) = NE_average(:)';
end


end % end of the function
    

    
    