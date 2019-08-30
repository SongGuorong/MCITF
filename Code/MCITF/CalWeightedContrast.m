function wCtr = CalWeightedContrast(colDistM,posDistM,fgProb)
% Calculate background probability weighted contrast

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014
bgProb = 1 - fgProb;
spaSigma = 0.4;     % sigma for spatial weight
posWeight = Dist2WeightMatrix(posDistM, spaSigma);
% bgProb weighted contrast
wCtr = colDistM .* posWeight * bgProb;
wCtr = (wCtr - min(wCtr)) / (max(wCtr) - min(wCtr) + eps);

% post-processing for cleaner fg cue
removeLowVals = true;
if removeLowVals
    thresh = graythresh(wCtr);  % automatic threshold
    wCtr(wCtr < thresh) = 0;
end

end
