function feat = drfiGetRegionSaliencyFeature( imsegs, spdata, imdata, pbgdata )    
    nseg = imsegs.nseg;   
    iDim = 28 * 2 + 27;     % Dimension of feature
    
    feat = zeros( nseg, iDim ); 
    spstats = regionprops( imsegs.segimage, 'Centroid', 'PixelIdxList', 'Area', 'Perimeter' );
    
    adjmat = double( imsegs.adjmat ) .* (1 - eye(nseg, nseg));  
    %%   
    position = zeros(nseg, 2); 
    area = zeros(1, nseg);     
    
    for ix = 1 : length(spstats)                   
        position(ix, :) = (spstats(ix).Centroid);
        area(ix) = spstats(ix).Area;
    end

    area_weight = repmat(area, [nseg, 1]) .* adjmat;
    area_weight = area_weight ./ repmat(sum(area_weight, 2) + eps, [1, nseg]);
    %% Contrast distance
    feat_dist_mat = zeros(nseg, nseg, 28);   
    %% textute distance      
    % MR8
    for ix = 1 : imdata.ntext_MR8
        feat_dist_mat(:,:,ix) = mexFeatureDistance(spdata.texture_MR8(ix,:), [], 'L1');
    end
    
    % Schmid
    for ix = 1 : imdata.ntext_S
        feat_dist_mat(:,:,8+ix) = mexFeatureDistance(spdata.texture_S(ix,:), [], 'L1');
    end
    
    % Gabor
    for ix = 1 : imdata.ntext_G5
        feat_dist_mat(:,:,8+13+ix) = mexFeatureDistance(spdata.texture_G5(ix,:), [], 'L1');
    end
    
    % Schmid & Gabor filter max response histogram
    feat_dist_mat(:,:,27) = mexFeatureDistance(spdata.textureHist, [], 'x2'); 
    
    feat_dist_mat(:,:,28) = mexFeatureDistance(spdata.MRAElbpHist, [], 'x2');
    
    %% regional contrast
    for ix = 1 : 28
        feat(:, ix) = sum(feat_dist_mat(:,:,ix) .* area_weight, 2);
    end
    
    %% regional backgroundness
    dim = 28;
    %% backgroundness for texture
    % backgroundness for MR8
    for ift = 1 : imdata.ntext_MR8
        feat(:, dim + ift) = abs( spdata.texture_MR8(ift, :) - pbgdata.texture_MR8(ift) );
    end
    
    % backgroundness for Schmid
    for ift = 1 : imdata.ntext_S
        feat(:, dim + 8 + ift) = abs( spdata.texture_S(ift, :) - pbgdata.texture_S(ift) );
    end
    
    % backgroundness for Gabor
    for ift = 1 : imdata.ntext_G5
        feat(:, dim + 8 +13+ ift) = abs( spdata.texture_G5(ift, :) - pbgdata.texture_G5(ift) );
    end
    
    % backgroundness for Schmid & Gabor filter max response histogram
    feat(:, dim + 27) = hist_dist( spdata.textureHist, repmat(pbgdata.textureHist, [1 nseg]), 'x2' );
    
    % backgroundness for MRAELBP
    feat(:, dim + 28) = hist_dist( spdata.MRAElbpHist, repmat( pbgdata.MRAElbpHist, [1 nseg]), 'x2' );
    
    ii = 28 * 2;  
    %% regional property
    for reg = 1 : nseg
        pixels = spstats(reg).PixelIdxList;  
        ix = ii;            % ii = 28 * 2              
       %% texture 
        % MR8 location information
        for it = 1 : imdata.ntext_MR8
            temp_textMR8 = imdata.imtext_MR8(:,:,it);           
            feat(reg, ix+it) = var( temp_textMR8(pixels) );
        end
        
        % Schmid location information
        for it = 1 : imdata.ntext_S
            temp_textS = imdata.imtext_S(:,:,it);                
            feat(reg, ix+8+it) = var( temp_textS(pixels) );
        end
        
        % Gabor location information
        for it = 1 : imdata.ntext_G5
            temp_textG5 = imdata.imtext_G5(:,:,it);              
            feat(reg, ix+21+it) = var( temp_textG5(pixels) );
        end
        
        % MRAELBP location information
        feat(reg, ix+27) = var( imdata.imMRAElbp(pixels) );             
    end
    
end







