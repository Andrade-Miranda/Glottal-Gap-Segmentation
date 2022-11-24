function [Segmentacion,foreground]=Inpainting_Backgroun_Segmentation(Video,vRgb,NROI,Thrfix)

%% Implementation of the Glottal Gap tracking by a continuous background modeling using inpainting
%input:
%   Video: uint8 LHSV sequence in gray;
%   vRgb: color of the final glottal boundary, default value [0 255 255];
%   NROI: Number the frames used to create the ROI, default value N=50;
%   Thrfix: Initial Threshold, default value -25 
%output:
% Segmentacion: Output segmentation LHSV
% foreground: Binary Video, 1 foreground 0 background

%% Initialization
Total_Number_frames=size(Video,4);
video_width=size(Video,2);%columns
video_height=size(Video,1);%rows 
levelin=1;

%% number of time the ROI is re-computed depending of the number of frames
    residuo=mod(Total_Number_frames,NROI);
    if (residuo~=0)
        num_findROI=floor(Total_Number_frames/NROI)+1; 
    else
        num_findROI=floor(Total_Number_frames/NROI);
    end



%% Enhancement step
VideoEnhanced=zeros(video_height,video_width,Total_Number_frames);
for kk=1:Total_Number_frames
temp=Video(:,:,:,kk);
[Color_enha]=color_equalization(temp);%color equalization function
[~,J,~]=RGB2SUVTransformation(Color_enha,-pi/4,pi/4);%RGB2SUV transformation
B = bfilter2(im2double(J),5,10); %bilateral filter
VideoEnhanced(:,:,kk)=B;%Video enhanced
end

%% Initialization for the ROI
Frame_inicial_ROI=1;
Frame_inicial=1;


for num_iteration=1:num_findROI %number of times that ROI is re-computed
if(num_iteration==num_findROI)
    if (residuo~=0)
Frame_inicial_ROI=Total_Number_frames-NROI+1;
Frame_final_ROI=Total_Number_frames;
Frame_inicial=Total_Number_frames-residuo+1;
Frame_final=Frame_final_ROI;
    else
Frame_final_ROI=NROI*num_iteration;
Frame_inicial=Frame_inicial_ROI;
Frame_final=Frame_final_ROI;
    end
else
Frame_final_ROI=NROI*num_iteration;
Frame_inicial=Frame_inicial_ROI;
Frame_final=Frame_final_ROI;
end

%% ROI computation
[ROI,~,~,~]=ROI_Gaussian_resemble(video_width,video_height,NROI,VideoEnhanced,Frame_inicial_ROI,Frame_final_ROI,2,2);

%% Masking
mascara_inpaint=zeros(video_width,video_height);
yinicial=ROI(1,2);
yfinal=yinicial+ROI(1,4);
xinicial=ROI(1,1);
xfinal=ROI(1,1)+ROI(1,3);
for f=yinicial:yfinal
    for c=xinicial:xfinal
        mascara_inpaint(f,c)= 1;
    end
end


conNframe=1;
for num_imagen=Frame_inicial:Frame_final %se realiza el tracking hasta video_nrFramesTotal    
%% Background Modeling and substraction
[inpaint_frame]=Inpainting_enhance(VideoEnhanced(:,:,num_imagen),mascara_inpaint);
[mascara_Enh,Xgray,Ygray]=Matriz_reducida_mapeada(VideoEnhanced(:,:,num_imagen),ROI);
[mascara_Inp,~,~]=Matriz_reducida_mapeada(inpaint_frame,ROI);
Glottismask=255.*(mascara_Enh)-255.*(mascara_Inp);

%% Thresholding and morphological operation
[BW,leveout]=ADaptevelyBackThreshold(mascara_Enh,Glottismask,Thrfix,levelin);
levelin=leveout;
 BW1 = bwmorph(BW,'clean'); 
 foreground(num_iteration).frame(:,:,conNframe)=BW1;
 
%% Edges extraction
seg_final= edge(BW1,'sobel');
[tempy,tempx]=find(seg_final ==1);
coordenada_x=Xgray(tempx(:));
coordenada_y=Ygray(tempy(:));
Coordenadas_glottis=struct('x',coordenada_x,'y',coordenada_y);
Segmentacion(:,:,:,num_imagen)=crear_contorno_vRgb(Video(:,:,:,num_imagen),Coordenadas_glottis.y,Coordenadas_glottis.x,vRgb); 

imshow(Segmentacion(:,:,:,num_imagen));%% final Segmentation
conNframe=conNframe+1;
end 
 Frame_inicial_ROI=num_imagen;
end