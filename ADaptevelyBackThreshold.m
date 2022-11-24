function [foreground,levelout]=ADaptevelyBackThreshold(GrayImg,Diff,Thrfix,levelin)


Difftemp=Diff;
Difftemp(Difftemp>Thrfix)=0;
Difftemp(Difftemp<=Thrfix)=1;

foreground=GrayImg;
foreground=foreground.*Difftemp;
pixR2=foreground(foreground~=0);
[ind]=find(foreground~=0);

if (isempty(pixR2) || numel(pixR2)<5)
    level=levelin;
else
    level=adaptiveThreshold(255.*(pixR2));
end


if (levelin>level)
    levelout=level;
else
    levelout=levelin;
end

BW = im2bw(uint8(pixR2),levelout);
BW=imcomplement(BW);
foreground(ind(:))=BW(:);


