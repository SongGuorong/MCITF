function [bbssel,bbssel_inds] = ProposalSel(im,bbs,fgProb,superpixels,inds)
% bbssel : selected proposals
% bbssel_inds : the index of superpixels in selected proposals

[ww,hh,~]=size(im); 
area = ww*hh;  
% bbs=[x,y,w,h,score] nx5 
bbs(:,3) = bbs(:,1)+bbs(:,3); 
bbs(:,4) = bbs(:,2)+bbs(:,4);

bbs = sortrows(bbs,-5);

bbssel = [];          
bbssel_inds ={};       

for i = 1:size(bbs,1)    
    w = bbs(i,3)-bbs(i,1); 
    h = bbs(i,4)-bbs(i,2); 
%%  Criterion 1 (discard oversized and undersized bounding boxes)
   if ((w*h)<(0.7*area))&&((w*h)>(0.2*area))        
        xmin = uint16(bbs(i,1)); 
        ymin = uint16(bbs(i,2)); 
        xmax = uint16(bbs(i,3)); 
        ymax = uint16(bbs(i,4)); 
        win = superpixels(ymin:ymax,xmin:xmax); 
        winind = unique(win);
 % Compute the index of superpixel in each proposals
 % Estimate if the superpixels in the four edge of proposal are belong to this proposal
       topwin = unique(win(1:4,:));             
       downwin =  unique(win(end-3:end,:));
       leftwin =  unique(win(:,1:4));
       rigthwin =  unique(win(:,end-3:end));
       edgewin =unique([topwin;downwin;leftwin;rigthwin]); 
       for ii = 1:length(edgewin)  
           num = sum(sum(win==edgewin(ii))); 
           truenum = length(inds{edgewin(ii)}); 
           if num < 0.4*truenum        
               winind(winind==edgewin(ii))=[]; 
           end
       end
%%  Criterion 2 (throw out boxes without saliency seeds)
        winfgprob = fgProb(winind); 
        if (length(find(winfgprob > 0.7))) >= (0.3*length(winind))
            bbssel=[bbssel;bbs(i,:)]; 
            bbssel_inds =[bbssel_inds;winind]; 
        end
   end 
end

%% In the case that the number of selected proposals is very small
if size(bbssel,1) <= 5 
    bbssel = bbs;      
    bbssel_inds ={};
    for i = 1:size(bbssel,1)        
        xmin = uint16(bbssel(i,1)); 
        ymin = uint16(bbssel(i,2));
        xmax = uint16(bbssel(i,3));
        ymax = uint16(bbssel(i,4)); 
        win = superpixels(ymin:ymax,xmin:xmax);
        winind = unique(win); 
   % Compute the index of superpixel in each proposals
   % Estimate if the superpixels in the four edge of proposal are belong to this proposal
       topwin = unique(win(1:4,:));             
       downwin =  unique(win(end-3:end,:));
       leftwin =  unique(win(:,1:4));
       rigthwin =  unique(win(:,end-3:end));
       edgewin =unique([topwin;downwin;leftwin;rigthwin]);
       for ii = 1:length(edgewin)
           num = sum(sum(win==edgewin(ii)));   
           truenum = length(inds{edgewin(ii)});   
           if num < 0.4*truenum
               winind(winind==edgewin(ii))=[];
           end
       end
       bbssel_inds =[bbssel_inds;winind]; 
    end
end

end