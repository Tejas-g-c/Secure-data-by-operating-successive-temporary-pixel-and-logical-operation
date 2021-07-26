clear all;
clc;
%message input
a1=input('Enter the message to be hidden: ','s');
N=strlength(a1)*8;
ascii=uint8(a1);
binary_separate=dec2bin(ascii,8);
Binarystring='';
for i=1:strlength(a1)
Binarystring=append(Binarystring,binary_separate(i,:));
end
%read image
Image=imread('Raja-Yoga-4.jpg'); %enter the image path in storage
I=rgb2gray(Image);% Convert image to greyscale
%I=imresize(I, [2 2]); % resize of image
[row,column]=size(I);
X=I;
K=1;
a=1;
%encoding message
for L=1:row
for m=1:column
bi = dec2bin(I(L,m),8);
A = str2double(bi(7));
Q = I(L,m)+1;
bi1=dec2bin(Q,8);
B = str2double(bi1(7));
if(K<N)
M1 = str2double(Binarystring(a));
M2 = str2double(Binarystring(a+1));
if((A==0)&&(B==0))
if((M1==0)&&(M2==0))
X(L,m)=I(L,m);
end
if((M1==0)&&(M2==1))
X(L,m)=I(L,m)+1;
end
if((M1==1)&&(M2==0))
X(L,m)=I(L,m)-1;
end
if((M1==1)&&(M2==1))
X(L,m)=I(L,m)+2;
end
end
if((A==0)&&(B==1))
if((M1==0)&&(M2==0))
X(L,m)=I(L,m)-1;
end
if((M1==0)&&(M2==1))
X(L,m)=I(L,m);
end
if((M1==1)&&(M2==0))
X(L,m)=I(L,m)+2;
end
if((M1==1)&&(M2==1))
X(L,m)=I(L,m)+1;
end
end
if((A==1)&&(B==0))
if((M1==0)&&(M2==0))
X(L,m)=I(L,m)+1;
end
if((M1==0)&&(M2==1))
X(L,m)=I(L,m)+2;
end
if((M1==1)&&(M2==0))
X(L,m)=I(L,m);
end
if((M1==1)&&(M2==1))
X(L,m)=I(L,m)-1;
end
end
if((A==1)&&(B==1))
if((M1==0)&&(M2==0))
X(L,m)=I(L,m)+2;
end
if((M1==0)&&(M2==1))
X(L,m)=I(L,m)-1;
end
if((M1==1)&&(M2==0))
X(L,m)=I(L,m)+1;
end
if((M1==1)&&(M2==1))
X(L,m)=I(L,m);
end
end
K=K+2;
a=a+2;
else
X(L,m)=I(L,m);
end
end
end
%decoding mesage
S=X;
k=1;
m=0;
message_in_bits='';
for i=1:row
for j=1:column
if(k<N)
bi2=dec2bin(S(i,j),8);
d2=str2double(bi2(7));
message_in_bits=append(message_in_bits,num2str(d2));
bi2=dec2bin(S(i,j)+1,8);
d3=str2double(bi2(7));
message_in_bits=append(message_in_bits,num2str(d3));
k=k+2;
end
end
end
%display
i=1;
original_message='';
while i<=N
original_message=append(original_message,char(bin2dec(message_in_bits(1,i:i+7))));
i=i+8;
end
disp(['The original message is: ',original_message]);
subplot(1,4,1);
imshow(I);
title('Cover Image');
subplot(1,4,2);
imshow(X);
title('Stego Image')
subplot(1,4,3);
imhist(I);
title('Histogram of cover Image')
subplot(1,4,4);
imhist(X);
title('Histogram of stego Image')
thePSNR = psnr(X, I);
theMSE = immse(X, I);
disp('MSE = ')
disp(theMSE);
disp('PSN = ')
disp(thePSNR);
