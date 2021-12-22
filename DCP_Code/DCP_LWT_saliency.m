function [Saliency]= DCP_LWT_saliency(frameType,dct, mv_x, mv_y)


%% Intialization

BLK_SZ=4;L=9;W=6;
MBLK_SZ = BLK_SZ*4;


%% reading DCT-R values

dct = (dct(:,:,:,frameType=='P'));


%% Applying Lifting wavelet on DCT


[CH,CV,CD]=Lwt3(dct);

%%
 
% Final_LWTCoeff= CH && CV && CD

%%  DCT-Y component
% dct_y = double(abs(dct(:,:,1,:)));



%% Sorting all frames of lifting coefficients and store in temperory file (tmp)

tmp1 = sort(reshape((CH),[],1),'descend');
tmp2 = sort(reshape((CV),[],1),'descend');
tmp3 = sort(reshape((CD),[],1),'descend');

%% Eliminating zero content
 
%  tmp1(tmp1==0)=[];
%  tmp2(tmp2==0)=[];
%  tmp3(tmp3==0)=[];
 
 %% 25 th percentile threshold over all frames of lifting wavelet coefficients

TH1 = tmp1(floor(numel(tmp1)*.25));
TH2 = tmp2(floor(numel(tmp2)*.25));
TH3 = tmp3(floor(numel(tmp3)*.25));


%% Setting these three thresholds and find DCT binary

dct_binary_map1 = CH > TH1;


dct_binary_map2 =  CV > TH2;


dct_binary_map3 =  CD > TH3;

%%


% Resize_binary_map1 =imresize(dct_binary_map1,2,'bilinear');
% 
% Resize_binary_map2 =imresize(dct_binary_map2,2,'bilinear');
% 
% Resize_binary_map3 =imresize(dct_binary_map3,2,'bilinear');
% 


%% The final dct map is formed via its all dct binary map



dct_map=(dct_binary_map1 | dct_binary_map2) | dct_binary_map3;

Final_dct_map=imresize(dct_map,2,'bilinear');





% Final_dct_map=logical(Final_dct_map);

% dct_map=(Resize_binary_map1 | Resize_binary_map2) | Resize_binary_map3;





sfc_map = Subsum(squeeze (Final_dct_map),MBLK_SZ,MBLK_SZ);

sfc_map= Normalize3d(sfc_map);
% Sfc1 = imresize(sfc,4,'bilinear'); size(Sfc1)


%%

%%
% 
sfc_flt = zeros(size(sfc_map));


%% spatial and temporal filtering 
for frame=1:L
    sfc_flt(:,:,frame) = imfilter(sfc_map(:,:,frame),ones(3));
end
sfc_avg = sfc_flt;
for frame=L+1:size(sfc_map,3)
    sfc_flt(:,:,frame) = imfilter(sfc_map(:,:,frame),ones(3));
    sfc_avg(:,:,frame) = mean(sfc_flt(:,:,frame-L:frame),3);
end
sfc_avg = Normalize3d(sfc_avg);







%% Interpolation to block level

S_LWT = imresize(sfc_avg,4,'bilinear');
S_LWT=Normalize3d(S_LWT);



%% DCP Implementation for motion vectors

[S_MV] = method_dcp_exp(frameType,mv_x,mv_y);

BLK_H=size(mv_x,1);BLK_W=size(mv_x,2);

%% Fusion of two Saliency maps using Dempster shafer.

a1=S_MV;

b1=S_LWT;

% 
AB=a1.*b1;

c1=1-a1;

d1=1-b1;

CD=c1.*d1;

Fuse= (AB)./(1-CD);
% % Fuse=a1+b1+AB
S=(Fuse);

%% Fusion - AMF

% Fuse1= a1+b1+a1.*b1;
% S=Normalize3d(Fuse1);

%% For non-salient maps
zeroSaliency = find(sum(sum(S,1),2)==0);
if ~isempty(zeroSaliency)
    for i=1:numel(zeroSaliency)
        if zeroSaliency(i) == 1
            gaussMap = fspecial('gaussian',[BLK_H BLK_W],W); 
            % equal to pixel-based Gaussian blob of one visual digree
            S(:,:,1) = gaussMap / max(gaussMap(:));            
        else
            S(:,:,zeroSaliency(i)) = S(:,:,zeroSaliency(i)-1);
        end
    end
end
Saliency = zeros(BLK_H,BLK_W,length(frameType));
Saliency(:,:,frameType=='P') = S;
Saliency = imresize(Saliency,BLK_SZ,'bilinear');
% S_t = Saliency;
Saliency = uint8(Saliency.*255);

Saliency_Lwt =imresize(S_LWT,BLK_SZ,'bilinear');
Saliency_Lwt = uint8(Saliency_Lwt.*255);
