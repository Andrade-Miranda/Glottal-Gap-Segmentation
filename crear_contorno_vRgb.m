function [imagen]= crear_contorno_vRgb(next_frame,contoy,contox,vRgb)

%% Function that Overlap contours in original video
[~,~,l]=size(next_frame);
if (l==1)
    imagen(:,:,1)=next_frame;
    imagen(:,:,2)=next_frame;
    imagen(:,:,3)=next_frame;
else
    imagen=next_frame;
end

   for i=1:length(contoy(1,:))
       imagen((contoy(1,i)),(contox(1,i)),1)=vRgb(1); 
   end
   for i=1:length(contoy(1,:))
       imagen((contoy(1,i)),(contox(1,i)),2)=vRgb(2); 
   end
   for i=1:length(contoy(1,:))
       imagen((contoy(1,i)),(contox(1,i)),3)=vRgb(3); 
   end
   
