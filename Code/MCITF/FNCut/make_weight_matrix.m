function W = make_weight_matrix(res_img,superlabels,para)
% input  superlabels: 3*1 cell,each cell is the superpixels labels.
      
img = im2double(res_img); [X,Y,Z] = size(res_img); N = X*Y;  % image resize

lab_img = colorspace('Lab<-', res_img);
lab_valsX = reshape(lab_img, X*Y, Z); 

%% make regions for each layer 
for k=1:para.K
       L = superlabels{k};   
       nseg0 = max(L(:));    
       nseg{k} = nseg0;      
      [points,edges]=lattice(X,Y,0);   
      clear points; 
      d_edges = edges(find(L(edges(:,1))~=L(edges(:,2))),:); 
      all_seg_edges = [L(d_edges(:,1)) L(d_edges(:,2))]; 
      all_seg_edges = sort(all_seg_edges,2); 
      tmp = zeros(nseg0,nseg0);    
      tmp(nseg0*(all_seg_edges(:,1)-1)+all_seg_edges(:,2)) = 1;
      [edges_x,edges_y] = find(tmp==1); 
      seg_edges0 = [edges_x edges_y];
      seg_edges{k} = seg_edges0; 
    %
      seg_lab_vals0 = zeros(nseg0,size(lab_valsX,2)); 
      for i=1:nseg0
        seg0{i} = find(L(:)==i);  
        seg_lab_vals0(i,:) = mean(lab_valsX(seg0{i},:));
      end
      seg{k} = seg0;     
      seg_lab_vals{k} = seg_lab_vals0; 
end

%% make edges & nodes betweem pixels : 'edgesX' 'lab_valsX'
[pointsX,edgesX] = lattice(X,Y,0); clear pointsX;   

%% make edges & nodes between regions: 'edgesY' 'lab_valsY'
num = N; edgesY = []; 
lab_valsY = [];
for k=1:para.K
    edgesY = [edgesY; (seg_edges{k}+num)]; 
    lab_valsY = [lab_valsY ; seg_lab_vals{k}];
    num = num + nseg{k};
end

%% total weight matrix - For each layer, use different color variance
weightsX = makeweights(edgesX,lab_valsX,para.beta); 
W_X = adjacency(edgesX,weightsX,N);  

% make edges between pixels and regions: 'edgesXY'
W_A = []; W_B = []; nsegs = 0;
for k=1:para.K
    nsegs = nsegs + nseg{k};
    weightsY{k} = makeweights(seg_edges{k},seg_lab_vals{k},para.beta);
    nW_Y{k} = para.gamma*adjacency(seg_edges{k},weightsY{k},nseg{k});
    % make edges between pixels and regions: 'edgesXY'
    edgesXY{k} = [];
    for i=1:nseg{k}
        col1 = seg{k}{i}; col2 = (i+N)*ones(size(col1,1),1); 
        edgesXY{k} = [edgesXY{k} ; [col1 col2]]; clear col1 col2;
    end
    weightsXY{k} = ones(size(edgesXY{k},1),1);
    W_T = para.alpha*adjacency(edgesXY{k},weightsXY{k},N+nseg{k});
    W_A = [W_A   W_T(1:N,N+1:N+nseg{k})];
    W_B = [W_B ; W_T(N+1:N+nseg{k},1:N)];
    clear W_T;
end

W_Y = sparse(nsegs,nsegs); num = 0;
for k=1:para.K
    W_Y(num+1:num+nseg{k},num+1:num+nseg{k}) = nW_Y{k}; num = num + nseg{k};
end
W = [W_X W_A ; W_B W_Y];

end

