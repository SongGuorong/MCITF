function connections = findHierarchy(allregions,sulabel)
        for k = 1: length(allregions{2})  
            index_1 = allregions{2}{k}.pixelInd; 
            temp = unique(sulabel{1}(index_1)); 
            oriconnections = [];
            for m = 1:length(temp)
                index_2 = allregions{1}{temp(m)};
                PixNum_1 = length(intersect(index_1,index_2)); 
                PixNum_2 = length(allregions{1}{temp(m)});  
                if PixNum_1/PixNum_2 > 0.5
                    oriconnections = [oriconnections;temp(m)];
                end
            end
            connections(k) = {oriconnections}; 
        end
        
end
     
 


