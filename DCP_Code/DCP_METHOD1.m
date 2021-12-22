
%% =========================== Minimum of two Cross descriptors using Dual cross pattern .m ========================== %
%
% Description          :  This code is used for "Getting motion descriptors for Motion vector orientation 
%                         using DCP method
%
% 
%                        
%                         
%                         
%
% Input parameters     :    H.264/AVC block motion vectors
%
%
% Output parameters    :    minimum of two descriptors DCP-1 and DCP-2
%                           
%
% Subroutine  called   :    NA
% Called by            :    NA
% Reference            :    Ding, C., Choi, J., Tao, D., & Davis, L. S. (2015). 
%                           Multi-directional multi-level dual-cross patterns for robust face recognition.
%                           IEEE transactions on pattern analysis and machine intelligence, 38(3), 518-531.
% Author of the code   :    Sandula Pavan (516ec6004@nitrkl.ac.in)
% Date of creation     :    04.12.2019
% --------------------------------------------------------------------- %
% Modified on          :    
% Modification details :    variable name and comments
% Modified By          :    
% ================================================================ %
%           ECE Department, NIT Rourkela, India.
% ================================================================ %



function [Q]= DCP_METHOD1(S,w1,w2)
%% Intialization
Wei=[1 4 16 64];
% Weigh=[1 4 16 64 4^4 4^5 4^6 4^7];
%% Dual Cross Encoding
for i=3:w1+2
    for j=3:w2+2
        D=S(i-2:i+2,j-2:j+2);
        D1=[D(1,3) D(1,5) D(3,5) D(5,5) D(5,3) D(5,1) D(3,1) ,D(1,1)];
        p=D(3,3);
%         Q=D(2:4,2:4);l=1;%m=1;
        Q1=[D(1,2) D(1,3) D(2,3) D(3,3) D(3,2) D(3,1) D(2,1) D(1,1)];
        for i1=1:8
           if D1(1,i1)-p>=0
               a1(i1)=1;
           else
               a1(i1)=0;
           end
           if Q1(1,i1)-p>=0
               b1(i1)=2;
           else
               b1(i1)=0;
           end
        end
        c1=a1+b1;
        
       f1=[ c1(1,1) c1(1,3) c1(1,5) c1(1,7)];
       f2=[c1(1,2) c1(1,4) c1(1,6) c1(1,8)];
%        f3= [ c1(1,1) c1(1,2) c1(1,3) c1(1,4) c1(1,5) c1(1,6) c1(1,7) c1(1,8)];
       
%% DCP DESCRIPTORS
%         DCP_a=f3.*Weigh;
        DCP_1=f1.*Wei;
        DCP_2=f2.*Wei;
% GE1(i-2,j-2)=e_1;
% GE2(i-2,j-2)=e_2;
        H(i-2,j-2)=sum([DCP_1]);
        H1(i-2,j-2)=sum(DCP_2);
    end
    
    
    
    
   
    
%% Minimum of two descriptors.
%     Q=min(H,H1);

end
Q=(H+H1);%./max(abs(H(:)+H1(:)));
%  Conc_His=[H(:) H1(:)];
% figure, Q=histogram(Conc_His(:),10);