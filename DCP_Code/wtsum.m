function [Q] = wtsum(wz,weight5)
Q=sum(sum((wz(:,:)).*weight5(:,:)));