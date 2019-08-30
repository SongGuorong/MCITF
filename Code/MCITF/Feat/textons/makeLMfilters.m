function F=makeLMfilters
% 函数功能创建LM滤波器(核)15维特征，最高可达48维特征
% Returns the LML filter bank of size 49x49x48 in F. To convolve an
% image I with the filter bank you can either use the matlab function
% conv2, i.e. responses(:,:,i)=conv2(I,F(:,:,i),'valid'), or use the
% Fourier transform.

  SUP=19;            % 49;  % Support of the largest filter (must be odd)
  SCALEX=sqrt(2).^1; % sqrt(2).^[1:3];% Sigma_{x} for the oriented filters 共3种尺度
  NORIENT=6;         % Number of orientations方位数为6

  NROTINV=3;         % 12；
  NBAR=length(SCALEX)*NORIENT;
  NEDGE=length(SCALEX)*NORIENT;
  NF=NBAR+NEDGE+NROTINV;
  F=zeros(SUP,SUP,NF);
  hsup=(SUP-1)/2;
  % x是一个矩阵,每一行是[-hsup:hsup]的复制,y是一个矩阵,每一列是[hsup:-1:-hsup]的复制
  [x,y]=meshgrid([-hsup:hsup],[hsup:-1:-hsup]);
  orgpts=[x(:) y(:)]';

  count=1;
  for scale=1:length(SCALEX)
    for orient=0:NORIENT-1
      angle=pi*orient/NORIENT;  % Not 2pi as filters have symmetry
      c=cos(angle);s=sin(angle);
      rotpts=[c -s;s c]*orgpts;
      F(:,:,count)=makefilter(SCALEX(scale),0,1,rotpts,SUP); % 计算高斯0,1阶组合
      F(:,:,count+NEDGE)=makefilter(SCALEX(scale),0,2,rotpts,SUP); % 计算高斯1,2阶组合
      count=count+1;
    end
  end
  
  count=NBAR+NEDGE+1;
  SCALES=sqrt(2).^1;   % sqrt(2).^[1:4];
  for i=1:length(SCALES)
    F(:,:,count)=normalise(fspecial('gaussian',SUP,SCALES(i)));
    F(:,:,count+1)=normalise(fspecial('log',SUP,SCALES(i)));
    F(:,:,count+2)=normalise(fspecial('log',SUP,3*SCALES(i)));
    count=count+3;
  end
return

function f=makefilter(scale,phasex,phasey,pts,sup)
  gx=gauss1d(3*scale,0,pts(1,:),phasex);  
  gy=gauss1d(scale,0,pts(2,:),phasey);
  f=normalise(reshape(gx.*gy,sup,sup)); % 滤波器f大小sup x sup
return

function g=gauss1d(sigma,mean,x,ord)
% Function to compute gaussian derivatives of order 0 <= ord < 3
% 函数计算高斯的0,1,2阶导数
% evaluated at x.

  x=x-mean;num=x.*x;
  variance=sigma^2; % 方差
  denom=2*variance; % 分母
  g=exp(-num/denom)/(pi*denom)^0.5;             % 阶数ord=0，高斯函数
  switch ord
    case 1, g=-g.*(x/variance);                 % 阶数ord=1，高斯函数一阶导
    case 2, g=g.*((num-variance)/(variance^2)); % 阶数ord=2，高斯函数二阶导
  end
return

% normalise归一化
function f=normalise(f)
f=f-mean(f(:)); 
f=f/sum(abs(f(:))); 
return