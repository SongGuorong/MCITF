function mapping = getmappingNew(samples,mappingtype)
% ===================================================================
% GETMAPPING returns a structure containing a mapping table for LBP codes.
%  MAPPING = GETMAPPING(samples,MAPPINGTYPE) returns a
%  structure containing a mapping table for
%  LBP codes in a neighbourhood of samples sampling
%  points. Possible values for MAPPINGTYPE are
%       'u2'   for uniform LBP
%       'ri'   for rotation-invariant LBP
%       'riu2' for uniform rotation-invariant LBP.
%       'fathi12' for implementing the method by fathi et al. in 2012
%  Example:
%       I = imread('rice.tif');
%       MAPPING = getmapping(16,'riu2');
%       LBPHIST = lbp(I,2,16,MAPPING,'hist');
%  Now LBPHIST contains a rotation-invariant uniform LBP
%  histogram in a (16,2) neighbourhood.
% ===================================================================
numAllLBPs = 2^samples;
table = 0 : numAllLBPs-1;
newMax = 0; % number of patterns in the resulting LBP code
index  = 0;

% Uniform 2
if strcmp(mappingtype,'u2')
    newMax = samples*(samples-1) + 3;
    for i = 0 : numAllLBPs-1
        % rotate left
        i_bin = dec2bin(i,samples);   
        j_bin = circshift(i_bin',-1)';  % circularly rotate left
        numt = sum(i_bin~=j_bin); 
        if numt <= 2
            table(i+1) = index;
            index = index + 1;
        else
            table(i+1) = newMax - 1;
        end
    end
end

% Rotation invariant
if strcmp(mappingtype,'ri') 
    tmpMap = zeros(2^samples,1) - 1;
    for i = 0:2^samples-1
        rm = i;
        r_bin = dec2bin(i,samples);
        for j = 1:samples-1
            temp=circshift(r_bin',-1*j)';
            r = bin2dec(circshift(r_bin',-1*j)'); % rotate left
            if r < rm
                rm = r;
            end
        end
        if tmpMap(rm+1) < 0
            tmpMap(rm+1) = newMax;
            newMax = newMax + 1;
        end
        table(i+1) = tmpMap(rm+1);
    end
end

% Uniform and Rotation invariant
if strcmp(mappingtype,'riu2') 
    newMax = samples + 2;
    for i = 0:2^samples - 1
        i_bin =  dec2bin(i,samples);
        j_bin = circshift(i_bin',-1)'; % rotate left
        numt = sum(i_bin~=j_bin);      % '0->1'change times
        if numt <= 2
            table(i+1) = sum(bitget(i,1:samples));
        else
            table(i+1) = samples+1;
        end
    end
end

% *************************************************************************
if strcmp(mappingtype,'num')
    newMax = 2*(samples - 1);
    for i = 0:2^samples - 1
        i_bin = dec2bin(i,samples);    
        j_bin = circshift(i_bin',-1)'; % circularly rotate left
        numt = sum(i_bin~=j_bin);        
        if numt <= 2
            table(i+1) = sum(bitget(i,1:samples));
        else
            numOnesInLBP = sum(bitget(i,1:samples));
            table(i+1) = samples+numOnesInLBP-1;
        end
    end
end
% *************************************************************************
if strcmp(mappingtype,'count')
    newMax = samples + 1;
    for i = 0:2^samples - 1
        numOnesInLBP = sum(bitget(i,1:samples));
        table(i+1) = numOnesInLBP;
    end
end
% *************************************************************************

mapping.table = table;
mapping.samples = samples;
mapping.num = newMax;

if strcmp(mappingtype,'')
    mapping.num = numAllLBPs;   
end

end


