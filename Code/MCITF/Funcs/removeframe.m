function [input_im,w,sup_img] = removeframe(image)
threshold=0.6;
input_im=im2double(image);     
gray=rgb2gray(input_im);        
edgemap = edge(gray,'canny');   
[m,n]=size(edgemap);
flagt=0;
flagd=0;
flagr=0;
flagl=0;
t=1;        % top
d=1;        % down
l=1;        % left
r=1;        % right

for k=1:30        % we assume that the frame is not wider than 30 pixels.
    pbt=mean(edgemap(k,:));
    pbd=mean(edgemap(m-k+1,:));
    pbl=mean(edgemap(:,k));
    pbr=mean(edgemap(:,n-k+1));
    if pbt>threshold
        t=k;
        flagt=1;
    end
    if pbd>threshold
        d=k;
        flagd=1;
    end
    if pbl>threshold
        l=k;
        flagl=1;
    end
    if pbr>threshold
        r=k;
        flagr=1;
    end
end

flagrm=flagt+flagd+flagl+flagr;
% we assume that there exists a frame when one more lines parallel to the image side are detected 
if flagrm>1 
    maxwidth=max([t,d,l,r]);
    % 
    if t==1
        t=maxwidth;
    end
    if d==1
        d=maxwidth;
    end
    if l==1
        l=maxwidth;
    end
    if r==1
        r=maxwidth;
    end    
    input_im=input_im(t:m-d+1,l:n-r+1,:);
    sup_img=image(t:m-d+1,l:n-r+1,:);
    w=[m,n,t,m-d+1,l,n-r+1];
else
    w=[m,n,1,m,1,n];
    sup_img=image;
end  

end
      