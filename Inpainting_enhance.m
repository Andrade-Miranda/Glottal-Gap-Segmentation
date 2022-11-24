function [inpaint_Frame]=Inpainting_enhance(frame,mask)
indxNaN= mask==1;
frame(indxNaN)=NaN;
inpaint_Frame=inpaint_nans_bc(frame,4);
end


