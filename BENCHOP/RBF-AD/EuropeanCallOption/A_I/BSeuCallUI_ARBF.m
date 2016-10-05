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
% % format long
% % % ========================
% % % Parameters for The Options
% % % ========================
% %%%%%%%%%%%%%%%%%%%%%%%%%% set 1%%%%%%%%%%%%%%%%%%%%%%%  
% S=[60:160]; %Stock price at time 0
% K=100; %Strike Price
% r=0.03; %Interest rate
% sig=0.15; %Volatility
% T=1; %Maturity
function RBF_Price=BSeuCallUI_ARBF(S,K,T,r,sig)
M=30; %Time Step
N=20; %Node
theta=0.5;
a=30; %interval [a,b]
b=2*K; %interval [a,b]
e=0.82*log(K);
f=1*log(K);
cg=0.66;
err=1e-3; % error setting 
err = [err/0.055 err/200];% redefine error (error indicator)
CT=5;


dt=T/M;%Time step
x=log(S);
ksi=zeros(N,1);%define the set of nodes form ksi_1 to ksi_N
for i=1:N
    ksi(i)=(i-1)*((log(b)-log(a))/(N-1))+log(a);
end

g=@(ksi) max(exp(ksi)-K,0);% The payoff of options

x1=ksi;
ConNum=zeros(M+1,1);
[x1,c,u0]=coarserefine(g,x1,err,cg,e,f);

u0(1)=0;
u0(end)=K;
N=length(x1);

TT=zeros(1,M+1);
TT(1,1)=N;
   [Phi,Phi_1,Phi_2]=deal(zeros(N));
   for j=1:N
    [Phi(:,j),Phi_1(:,j),Phi_2(:,j)]=mq(x1,x1(j),c(j));
   end 
ConNum(1,1)=cond(Phi);   

dt1=dt/CT;
for i=1:CT
    
   tn=dt+i*dt1;
   
 
   I=eye(N,N);
  
   P=I*r-0.5*(sig^2)*(Phi\Phi_2)-(r-0.5*(sig^2))*(Phi\Phi_1); 
   H=I+dt1*(1-theta)*P;
   G=I-dt1*theta*P;
   lambda=Phi\u0;
   lambda=H\G*lambda;
   u0=Phi*lambda;
   lambda1=Phi\eye(N);
   
   [x1,c,u0]=coarserefine(@(xp)predictor(xp,x1,u0,lambda1,c),ksi,err,cg,e,f);
   
   
   nu=u0; 
   
        
 
   
         nu(1)=0;
         nu(end)=b-exp(-r*tn)*K;
   
    u0=nu;
   N=length(x1);
   TT(1,i)=N;

   [Phi,Phi_1,Phi_2]=deal(zeros(N));
   for j=1:N
    [Phi(:,j),Phi_1(:,j),Phi_2(:,j)]=mq(x1,x1(j),c(j));
   end
   ConNum(i+1,1)=cond(Phi);
   


end

for i=3:M+1
    
   tn=2*dt+i*dt;
   
 
   I=eye(N,N);
  
   P=I*r-0.5*(sig^2)*(Phi\Phi_2)-(r-0.5*(sig^2))*(Phi\Phi_1); 
   H=I+dt*(1-theta)*P;
   G=I-dt*theta*P;
   lambda=Phi\u0;
   lambda=H\G*lambda;
   u0=Phi*lambda;

     
   nu=u0; 
   
   nu(1)=0;
   nu(end)=b-exp(-r*tn)*K;
   
   u0=nu;

  


end


lambda=Phi\u0;
pp=length(S);
RBF_Price=zeros(1,pp);
for jj=1:pp
RBF_Price(1,jj)=sum(lambda.*sqrt(((x(1,jj)-x1).*c).^2+1));
end
end
% s1=S;
% BS=zeros(1,pp);
% for jj=1:pp
% S=s1(1,jj);   
% d1 = (log(S/K)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d2 = (log(S/K)+(r-sig^2/2)*T)/(sig*sqrt(T));
% BS(1,jj) = -K*exp(-r*T)*normcdf(d2)+S*normcdf(d1);
% end
% Error1=abs(RBF_Price-BS)./BS;
% plot(s1,Error1,'o')
%  
%  RBF_Delta=zeros(pp,1);
%  for i=1:pp
% RBF_Delta(i,1)=sum(lambda.*(((c.^2).*(x(i,1)-x1))./(sqrt(((x(i,1)-x1).*c).^2+1)))/s1(i,1));
%  end
%  Delta=[0.334542751969886; 0.608341880846395; 0.818694517094515];
%  Err=abs(RBF_Delta-Delta)./Delta
%  RBF_Gamma=zeros(pp,1);
%  for i=1:pp 
% RBF_Gamma(i,1)=sum(lambda.*(((c.^2)./(sqrt(((x(i,1)-x1).*c).^2+1).^3))-(((c.^2).*(x(i,1)-x1))./(sqrt(((x(i,1)-x1).*c).^2+1))))/(s1(i,1)^2));
%  end
%  Gamma=[0.026971755100040; 0.025609261020380; 0.015975258690289];
%  Err1=abs(RBF_Gamma-Gamma)./Gamma