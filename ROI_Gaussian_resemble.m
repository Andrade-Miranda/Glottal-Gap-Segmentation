function [ROI,center,TIVx,TIVy]=ROI_Gaussian_resemble(video_width,video_height,nr_Frames,video,Frame_inicial,Frame_final,desviacionx,desviaciony) 

if nargin < 7
    desviacionx = 2.3;
    desviaciony = 2.3;
elseif desviacionx == -1
    desviacionx = 2.3;
    desviaciony = 2.3;
end

new_video=video(:,:,Frame_inicial:Frame_final);

for j=1:nr_Frames
 Matriz_suma_columnas(j,:)=sum(double(new_video(:,:,j)))./video_height;
 end
Promedio_columnas=sum(Matriz_suma_columnas)./nr_Frames;%average Nframes columns

for j=1:nr_Frames
  matriz_score_columnas(j,:)=abs(Matriz_suma_columnas(j,:)-Promedio_columnas(1,:));
end
total_columnas=sum(matriz_score_columnas)./nr_Frames;

%%
columnas_suavizada =total_columnas';
maxim_columnas=max(columnas_suavizada);
minimum_columnas=min(columnas_suavizada);

for i=1:length(columnas_suavizada)
    columnas_suavizadas_normalizadas(1,i)=(columnas_suavizada(i,1)-minimum_columnas)./(maxim_columnas-minimum_columnas);
end

x_axis=1:length(columnas_suavizadas_normalizadas);
f = fit( x_axis', columnas_suavizadas_normalizadas', 'gauss1' );
f_x=f.a1*exp(-((x_axis-f.b1)/f.c1).^2);

%% 
mean_gaussian_c=f.b1;
SD_gaussian_c=f.c1/sqrt(2);

%cutoff between +2SD y -2SD
xneg=round(mean_gaussian_c-(desviacionx*SD_gaussian_c));
xpos=round(mean_gaussian_c+(desviacionx*SD_gaussian_c));
xpos(xpos>video_width)=video_width;
xneg(xneg<1)=1;
ROI_columnas=[xneg,1,xpos-xneg,video_height];
center_x=mean_gaussian_c;


 for j=1:nr_Frames
imagen_recortada(:,:,j)=imcrop(new_video(:,:,j),ROI_columnas);
  end


%% compute ROI in ROWs
for j=1:nr_Frames
 Matriz_suma_filas(j,:)=sum(double(imagen_recortada(:,:,j)'))./(video_width);
 end
Promedio_filas=sum(Matriz_suma_filas)./nr_Frames;
for j=1:nr_Frames
    matriz_score_filas(j,:)=abs(Matriz_suma_filas(j,:)-Promedio_filas(1,:));
end
total_filas=sum(matriz_score_filas)./nr_Frames;
%%

filas_suavizadas =total_filas';
maxim_filas=max(filas_suavizadas);
minimum_filas=min(filas_suavizadas);

for i=1:length(filas_suavizadas)
    filas_suavizadas_normalizadas(1,i)=(filas_suavizadas(i,1)-minimum_filas)./(maxim_filas-minimum_filas);
end

g = fit( x_axis', filas_suavizadas_normalizadas', 'gauss1' );
g_x=g.a1*exp(-((x_axis-g.b1)/g.c1).^2);

%%
mean_gaussian_r=g.b1;
SD_gaussian_r=g.c1/sqrt(2);

%cutoff betwee +2SD y -2SD
yneg=round(mean_gaussian_r-(desviaciony*SD_gaussian_r));
ypos=round(mean_gaussian_r+(desviaciony*SD_gaussian_r));
ypos(ypos>video_height)=video_height;
yneg(yneg<1)=1;
ROI=[xneg,yneg,xpos-xneg,ypos-yneg];
center_y=mean_gaussian_r;
center.x=center_x;
center.y=center_y;

TIVx.fit=f_x;
TIVx.nofit=columnas_suavizadas_normalizadas;
TIVy.fit=g_x;
TIVy.nofit=filas_suavizadas_normalizadas;

