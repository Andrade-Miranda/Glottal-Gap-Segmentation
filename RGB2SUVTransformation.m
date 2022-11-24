function [ImgSUV,J,R]=RGB2SUVTransformation(Img,thetaEL,thetaAZ)

ImgSUV=zeros(size(Img));
[Ry]=rotation_matrixXYZ(thetaAZ,'y');
[Rx]=rotation_matrixXYZ(thetaEL,'x');
[Rz]=rotation_matrixXYZ(0,'z');


R=Ry*Rx;
Img=double(Img);

for j=1:(size(Img,1))
    for i=1: (size(Img,2))
        r= Img(j,i,1);
        g= Img(j,i,2);
        b= Img(j,i,3);
        p=R*[r g b]';
        ImgSUV(j,i,1)=abs(p(1));
        ImgSUV(j,i,2)=abs(p(2));
        ImgSUV(j,i,3)=abs(p(3));
    end
end
J= sqrt(ImgSUV(:,:,1).^2+ImgSUV(:,:,3).^1);
ImgSUV=uint8(ImgSUV);
J=abs(uint8(J));

