clc
clear all;
% read the image 
Im=imread('lena.png');

%convert the image to double
Im=double(Im);
n=max(size(Im));

%noisey image
NIm = Im + 10*randn(n,n);

%display the images
% figure(1)
% imshow(Im,[]);
% figure(2)
% imshow(NIm,[]);

% 
%% 1 Dimensional Quadratic regularising - denoising the image

L=sparse(n-1,n);
for i=1:n-1
L(i,i)=1;
L(i,i+1)=-1;
end
lambda=100;
xde1D=(speye(n)+lambda*(L')*L)\NIm;
% figure(3)
% imshow(xde1D,[]);

%% 2 Dimensional Quadratic regularising - denoising the image
x = NIm;
n = max(size(x));

%converting to colomn
x=x';
xx=x(:);
xx=xx';

%L matrix construction
L=sparse(2*(n-1)*(n-1),n*n);
shift=0;
iteration = (n-1)*(n-1) + (n-2);
for i=1:1:iteration
    
    if(mod(i,n)==0)
        shift=shift-1;
    
    else
    L(2*(i+shift)-1,(i))= 1;
    L(2*(i+shift)-1,(i)+1)=-1;
    L(2*(i+shift),(i))=1;
    L(2*(i+shift),(i)+n)=-1;
    end
end

%solution
lambda=25;
xde=(speye(n*n)+lambda*(L')*L)\xx';

%converting back to 2D
count=1;
j=1;
opImg=zeros(n,n);
for i=1:1:n*n
    
    opIm(count,j)=xde(i);
    j=j+1;
    if (mod(i,n)==0)
        j=1;
        count=count+1;
    end
    
end

% figure(4)
% imshow(opIm,[]);

%% TV regularization
x = NIm;
n = max(size(x));

%converting to colomn
x=x';
xx=x(:);
xx=xx';

%L matrix construction
L=sparse(2*(n-1)*(n-1),n*n);
shift=0;
iteration = (n-1)*(n-1) + (n-2);
for i=1:1:iteration
    
    if(mod(i,n)==0)
        shift=shift-1;
    
    else
    L(2*(i+shift)-1,(i))= 1;
    L(2*(i+shift)-1,(i)+1)=-1;
    L(2*(i+shift),(i))=1;
    L(2*(i+shift),(i)+n)=-1;
    end
end

%solution Algo
lambda=25;
mu=zeros(2*(n-1)*(n-1),1);
y=xx';
for i=1:1000
mu=mu-0.25*L*(L'*mu)+0.5*(L*y);
mu=lambda*mu./max(abs(mu),lambda);
xdeTV=y-0.5*L'*mu;
end

%converting back to 2D
count=1;
j=1;
opImgTV=zeros(n,n);
for i=1:1:n*n
    
    opImTV(count,j)=xdeTV(i);
    j=j+1;
    if (mod(i,n)==0)
        j=1;
        count=count+1;
    end
    
end

% figure(5)
% imshow(opImTV,[]);

figure
subplot(2,3,1)
imshow(Im,[]);
title('The Original Image')

subplot(2,3,2)
imshow(NIm,[])
title('Noisy Image')

subplot(2,3,3)
imshow(xde1D,[]);
title('1D denoising')

subplot(2,3,4)
imshow(opIm,[]);
title('2D denoising')

subplot(2,3,5)
imshow(opImTV,[]);
title('Denoising By TV')
