 %Copyright (C) 2015 Jeremy Levesley

    %This file is part of BENCHOP.
    %BENCHOP is free software: you can redistribute it and/or modify
    %it under the terms of the GNU General Public License as published by
    %the Free Software Foundation, either version 3 of the License, or
    %(at your option) any later version.

    %BENCHOP is distributed in the hope that it will be useful,
    %but WITHOUT ANY WARRANTY; without even the implied warranty of
    %MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    %GNU General Public License for more details.

    %You should have received a copy of the GNU General Public License
    %along with BENCHOP. If not, see <http://www.gnu.org/licenses/>.% close all
% clear all
% format long
function RBF_Price=BSeuCallVegaI_ARBF(S,K,T,r,sig)
% ========================
% Parameters for The Options
% ========================
 
% S=[90,100,110]; %Stock price at time 0
% K=100; %Strike Price
% r=0.03; %Interest rate
% sig=0.15; %Volatility
% T=1; %Maturity
a=0.001*sig;
LN=length(S);
A=zeros(1,LN);
for i=1:LN
  A(1,i)=BSeuCall(S(1,i),K,T,r,sig);
end

sig=sig+a;
B=zeros(1,LN);
for i=1:LN
B(1,i)=BSeuCall(S(1,i),K,T,r,sig);
end
RBF_Price=abs(B-A)/a;
end

% Vega=[32.770682446548165 38.413891530570481 28.995094522875153];
% Error=abs(Vega-RBF_Price)./Vega
% [P1,P2,P3]=BSeuCall(S,K,T,r,sig);
% BS_Vega=zeros(1,3);
% % BS1=zeros(1,3);
% for i=1:3
%     S=60+(i-1)*10;
%     d1 = (log(S/K)+(r+sig^2/2)*T)/(sig*sqrt(T));
%     d2 = (log(S/K)+(r-sig^2/2)*T)/(sig*sqrt(T));
%     BS_Vega(1,i)=S*exp(-d1^2/2)*sqrt(T)/sqrt(2*pi);
% %     BS1(1,i) = -K*exp(-r*T)*normcdf(d2)+S*normcdf(d1);
% end
% sig=sig+a;
% S=60;
% [P11,P21,P31]=BSeuCall(S,K,T,r,sig);
% RBF_Vega=zeros(1,3);
% RBF_Vega(1,1)=abs(P11-P1)/a;
% RBF_Vega(1,2)=abs(P21-P2)/a;
% RBF_Vega(1,3)=abs(P31-P3)/a;
% Error=abs(BS_Vega-RBF_Vega)./BS_Vega
% Error=zeros(1,3);
% Error(1,1)=abs(RBF_Vega(1,1)-BS_Vega(1,1));
% Error(1,2)=abs(RBF_Vega(1,2)-BS_Vega(1,2));
% Error(1,3)=abs(RBF_Vega(1,3)-BS_Vega(1,3));
% Error
% BS=zeros(1,3);
% for i=1:3
%     S=90+(i-1)*10;
%     d1 = (log(S/K)+(r+sig^2/2)*T)/(sig*sqrt(T));
%     d2 = (log(S/K)+(r-sig^2/2)*T)/(sig*sqrt(T));
%     BS(1,i) = -K*exp(-r*T)*normcdf(d2)+S*normcdf(d1);
% end
% err=zeros(1,3);
% err(1,1)=abs(BS(1,1)-BS1(1,1))/a;
% err(1,2)=abs(BS(1,2)-BS1(1,2))/a;
% err(1,3)=abs(BS(1,3)-BS1(1,3))/a;