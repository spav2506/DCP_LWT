function [CH_1,CV_1,CD_1]=Lwt3(dct)
frm_cnt=size(dct,4);

m=size(dct,1);
n=size(dct,2);
CH_1=zeros(m/2,n/2,frm_cnt);CV_1=zeros(m/2,n/2,frm_cnt);CD_1=zeros(m/2,n/2,frm_cnt);
sd1=liftwave('haar');
dct=double(abs(dct));
for i= 1:frm_cnt
    dct1 = double(abs(dct(:,:,1,i)));
    [A,CH,CV,CD]=lwt2(dct1,sd1);
%     m1=0;
%    
%     for j=1:16:size(dct1,1)
%  n1=0;
%         for k=1:16:size(dct1,2)
%             
%              dct2= dct1(j:j+15,k:k+15);
%              [A,CH,CV,CD]=lwt2(dct2,sd1);
% 
%              
%              
%              
             CH_1(:,:,i)=CH;
             CV_1(:,:,i)=CV;
             CD_1(:,:,i)=CD;
%              
%              n1=n1+1;
%              
%              
%              
%              
%              
%              
%              
%              
%            
%         end
%         m1=m1+1;
%     end
 
%  B = imresize(abs(B),2,'bilinear');
%   C = imresize(abs(C),2,'bilinear');
%    D = imresize(abs(D),2,'bilinear');


    
end
%    tmp1 = sort(reshape((CH_1),[],1),'descend');
% tmp2 = sort(reshape((CV_1),[],1),'descend');
% tmp3 = sort(reshape((CD_1),[],1),'descend'); 
end