function [Imagen_reducida,Xmapeada,Ymapeada]=Matriz_reducida_mapeada(Imagen_original,ROI)

if nargin > 2
    error('Wrong number of input arguments!')
end

[m n ind]=size(Imagen_original);
if ind==3 , Imagen_original=rgb2gray(Imagen_original);end
%Imagen_original=histeq(Imagen_original,256);
j=1;i=1;
yinicial=ROI(1,2);
yfinal=yinicial+ROI(1,4);
%yfinal=features_glottis(1,4);
xinicial=ROI(1,1);
xfinal=ROI(1,1)+ROI(1,3);
for f=yinicial:yfinal
    for c=xinicial:xfinal
        Imagen_reducida(j,i)= Imagen_original(f,c);
        Ymapeada(j)=f;
        Xmapeada(i)=c;
        i=i+1;
    end
    j=j+1;
    i=1;
end


