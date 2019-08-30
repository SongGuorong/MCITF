function spdata = drfiGetSuperpixelData( imdata, imsegs )

    spstats = regionprops( imsegs.segimage, 'PixelIdxList' ); 
    nseg = imsegs.nseg;  
    %% texture MR8/Schmid(S)/MRAELBP
    % MR8
    imtext_MR8 = imdata.imtext_MR8;   
    
    % Schmid
    imtext_S = imdata.imtext_S;       
    
    % Gabor
    imtext_G5 = imdata.imtext_G5;      
    
    % Gabor & Schmid filter max response histogram
    texthist = imdata.texthist;     
    
    % MRAELBP
    imMRAElbp = imdata.imMRAElbp;
    
    imw = imdata.imw;   
    imh = imdata.imh;    
    
    spdata.texture_MR8 = zeros(imdata.ntext_MR8, nseg);     
    spdata.texture_S = zeros(imdata.ntext_S, nseg);        
    spdata.texture_G5 = zeros(imdata.ntext_G5, nseg);      
    spdata.textureHist = zeros(imdata.ntext_SG, nseg);     
    spdata.MRAElbpHist = zeros(imdata.nMRAElbp, nseg);     
    
    %% 
    for s = 1 : nseg
        pixels = spstats(s).PixelIdxList;      
        %% texture
        % MR8
        for ift = 1 : imdata.ntext_MR8
            spdata.texture_MR8(ift, s) = mean( imtext_MR8(pixels+(ift-1)*imw*imh) );
        end
        
        % Schmid
        for ift = 1 : imdata.ntext_S
            spdata.texture_S(ift, s) = mean( imtext_S(pixels+(ift-1)*imw*imh) );
        end
        
        % Gabor
        for ift = 1 : imdata.ntext_G5
            spdata.texture_G5(ift, s) = mean( imtext_G5(pixels+(ift-1)*imw*imh) );
        end
        
        % Gabor & Schmid filter max response histogram texthist   range:[1,18]
        spdata.textureHist(:, s) = hist( texthist(pixels), 1:imdata.ntext_SG )';
        spdata.textureHist(:, s) = spdata.textureHist(:, s) / max( sum(spdata.textureHist(:, s)), eps );
        
        % MRAELBP  imMRAElbp   range:[0:(imdata.nMRAElbp-1)]
        spdata.MRAElbpHist(:, s) = hist( imMRAElbp(pixels), 0:(imdata.nMRAElbp-1) )';
        spdata.MRAElbpHist(:, s) = spdata.MRAElbpHist(:, s) / max( sum(spdata.MRAElbpHist(:, s)), eps );
    end  
    
end







