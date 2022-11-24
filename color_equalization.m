function [Imgeq]=color_equalization(Img,option)
%% color equalization function
if nargin <2
    option='YCbCr';
end

if isempty(size(Img,3))
    error('I need a color image')
end

if strcmp(option,'YCbCr')
    Imgcolor=rgb2ycbcr(Img);
else
    Imgcolor=rgb2hsv(Img);
end


Grayeq=histeq(Imgcolor(:,:,1));
Imgcolor(:,:,1)=Grayeq;
Imgeq=ycbcr2rgb(Imgcolor);





