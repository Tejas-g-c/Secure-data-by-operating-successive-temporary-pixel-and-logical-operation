clear all;
clc;
original=imread('originalImage-300x300.jpg'); %enter the image path in storage
cover=rgb2gray(original);% Convert image to greyscale
%cover=imresize(cover, [4 4]); % resize of image
[row,column]=size(cover);
L=256;
stego=cover;
%message input
message=input('Enter the message to be hidden: ','s');
len=strlength(message)*8; %Each character will take 8 bits so total number of
bits in the message will be len
ascii=uint8(message); %ascii is a vector having the ascii value of each
character
binary_separate=dec2bin(ascii,8); %binary_separate is an array having the
decimal representation of each ascii value
binary_all=''; %binary_all will have the entire sequence of bits of the message
for i=1:strlength(message)
binary_all=append(binary_all,binary_separate(i,:));
end
%Encoding the message
count=1; %initializing count with 1
for i=1:row
for j=1:column
%for every character in the message
if count<=len
a1 = cover(i,j);
%bug code
if(mod(a1,2)~= 0)
cover(i,j)= cover(i,j)+1;
end
bi=dec2bin(cover(i,j),8);%decimal to binary conversion
%Obtain the 6th bit of the grey level of the pixel
c6 = str2double(bi(3));
%Obtain the 7th bit of the grey level of the pixel
c7 = str2double(bi(2));
%Obtain the 8th bit of the grey level of the pixel
c8 = str2double(bi(1));
%Perform XOR operation between the 6th bit and 7th bit
x1 = double(xor(c6,c7));
%Perform XOR operation between the x1 and 8th bit
x2 = double(xor(c8,x1));
%Convert the bit from the message to numeric form
a=str2double(binary_all(count));
%Perform XOR operation between the bit and the LSB
temp=double(xor(x2,a));
%save that to bit to get stego-image
stego(i,j)=cover(i,j)+temp;
count=count+1;
%end
end
end
end
thePSNR = psnr(stego, cover);
theMSE = immse(stego, cover);
disp('MSE = ')
disp(theMSE);
disp('PSN = ')
disp(thePSNR);
%Decoding the message (revrse process)
count1=1;
message_in_bits='';
for i=1:row
for j=1:column
%For all the characters in the message
if count1<=len
bi1=dec2bin(stego(i,j),8);
d1 = str2double(bi1(8));
d6 = str2double(bi1(3));
d7 = str2double(bi1(2));
d8 = str2double(bi1(1));
y1 = double(xor(d6,d7));
y2 = double(xor(d8,y1));
LSB = double(xor(d1,y2));
message_in_bits=append(message_in_bits,num2str(LSB));
count1=count1+1;
end
end
end
%Converting the bit sequence into the original message
i=1;
original_message='';
while i<=len
%Take a set of 8 bits at a time
%Convert the set of bits to a decimal number
%Convert the decimal number which is the ascii value to its corresponding
character
%Append the obtained character into the resultant string
original_message=append(original_message,char(bin2dec(message_in_bits(1,i:i+7))));
i=i+8;
end
disp(['The original message is: ',original_message]);
subplot(1,4,1);
imshow(cover);
title('Cover Image');
subplot(1,4,2);
imshow(stego);
title('Stego Image')
subplot(1,4,3);
imhist(cover);
title('Histogram of cover Image')
subplot(1,4,4);
imhist(stego);
title('Histogram of stego Image')
