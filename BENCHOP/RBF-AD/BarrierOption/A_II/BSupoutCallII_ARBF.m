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
    %along with BENCHOP. If not, see <http://www.gnu.org/licenses/>.

function RBF_Price=BSupoutCallII_ARBF(S,K,T,r,sig,B)
% ========================
% Parameters for The Options
% ========================
% clear all,  
% S=[97,98,99]; %Stock price at time 0
% K=100; %Strike Price
% r=0.10; %Interest rate
% sig=0.01; %Volatility
% T=0.25; %Maturity
% B=125;
M=150; %Time Step
N=40; %Node
theta=0.5;
a=50; %interval [a,b]
b=B; %interval [a,b]
e=0.97*log(K);
f=1.00*log(K);
cg=0.745;
err=1e-3; % error setting 
err = [err/1 err/30];% redefine error (error indicator)
dt=T/M;%Time step
x=log(S);
B=log(b);
ksi=zeros(N,1);%define the set of nodes form ksi_1 to ksi_N
for i=1:N
    ksi(i)=(i-1)*((log(b)-log(a))/(N-1))+log(a);
end

maxdis=2*((log(b)-log(a))/(59));% Max distance between each point


g=@(ksi) payoff(ksi,B,K);%max(exp(ksi)-K,0);% The payoff of options



x1=ksi;

[x1,c,u0]=coarserefine3(g,x1,err,cg,maxdis,e,f);




u0(1)=0;
u0(end)=0;

dt1=dt/1;
for i=1:1
    
 
   
   N=length(x1);
   dx=diff(x1);
   c=cg*min([Inf;1./dx],[1./dx;Inf]);
   [Phi,Phi_1,Phi_2]=deal(zeros(N));
   for j=1:N
    [Phi(:,j),Phi_1(:,j),Phi_2(:,j)]=mq(x1,x1(j),c(j));
   end

   I=eye(N,N);
  
   P=I*r-0.5*(sig^2)*(Phi\Phi_2)-(r-0.5*(sig^2))*(Phi\Phi_1); 
   H=I+dt1*(1-theta)*P;
   G=I-dt1*theta*P;
   lambda=Phi\u0;
   lambda=H\G*lambda;
   u0=Phi*lambda;
   lambda1=Phi\eye(N);
   
   [x1,c,u0]=coarserefine1(@(xp)predictor(xp,x1,u0,lambda1,c),x1,err,cg,maxdis,e,f);
   
   
   nu=u0; 
   
        
 
   
         nu(1)=0;
         nu(end)=0;
   
    u0=nu;


end
 

for i=3:M+1
    

   N=length(x1);
   dx=diff(x1);
   c=cg*min([Inf;1./dx],[1./dx;Inf]);
   [Phi,Phi_1,Phi_2]=deal(zeros(N));
   for j=1:N
    [Phi(:,j),Phi_1(:,j),Phi_2(:,j)]=mq(x1,x1(j),c(j));
   end

   I=eye(N,N);
  
   P=I*r-0.5*(sig^2)*(Phi\Phi_2)-(r-0.5*(sig^2))*(Phi\Phi_1); 
   H=I+dt*(1-theta)*P;
   G=I-dt*theta*P;
   lambda=Phi\u0;
   lambda=H\G*lambda;
   u0=Phi*lambda;
   lambda1=Phi\eye(N);
   if mod(i,1)==0
   [x1,c,u0]=coarserefine1(@(xp)predictor(xp,x1,u0,lambda1,c),x1,err,cg,maxdis,e,f);
   end
   
   nu=u0; 

         nu(1)=0;
         nu(end)=0;
 
    u0=nu;

end


   N=length(x1);

   [Phi,Phi_1,Phi_2]=deal(zeros(N));
   for j=1:N
    [Phi(:,j),Phi_1(:,j),Phi_2(:,j)]=mq(x1,x1(j),c(j));
   end
  
 lambda=Phi\u0;
 LN=length(S);
 RBF_Price=zeros(1,LN);
 for i=1:LN
RBF_Price(1,i)=sum(lambda.*sqrt(((x(1,i)-x1).*c).^2+1));
 end
%  U=[0.033913177006134 0.512978189232598 1.469203342553328];
%  Err=abs(U-RBF_Price)./U
end
% B=b;
% v=(r-sig^2/2);
% d1 = (log(S/K)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d2 = (log(S/K)+(r-sig^2/2)*T)/(sig*sqrt(T));
% C_BS = -K*exp(-r*T)*normcdf(d2)+S*normcdf(d1);
% d3 = (log(S/B)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d4 = (log(S/B)+(r-sig^2/2)*T)/(sig*sqrt(T));
% C_BS_SB = -B*exp(-r*T)*normcdf(d4)+S*normcdf(d3);
% d5 = (log(S/B)+(r-sig^2/2)*T)/(sig*sqrt(T));
% d6 = (log(B/S)+(r-sig^2/2)*T)/(sig*sqrt(T));
% d7 = (log(((B^2)/S)/K)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d8 = (log(((B^2)/S)/K)+(r-sig^2/2)*T)/(sig*sqrt(T));
% C_BS1= -K*exp(-r*T)*normcdf(d8)+((B^2)/S)*normcdf(d7);
% d9 = (log(((B^2)/S)/B)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d10 =(log(((B^2)/S)/B)+(r-sig^2/2)*T)/(sig*sqrt(T));
% C_BS2= -B*exp(-r*T)*normcdf(d10)+((B^2)/S)*normcdf(d9);
% C_UO=C_BS - C_BS_SB -(B-K)*exp(-r*T)*normcdf(d5)-((B/S)^(2*v/(sig^2)))*(C_BS1-C_BS2-(B-K)*exp(-r*T)*normcdf(d6));
% 
% Error1=abs(RBF_Price-C_UO);
% S=S+1;
% x=log(S);
% RBF_Price=sum(lambda.*sqrt(((x-x1).*c).^2+1));
% v=(r-sig^2/2);
% d1 = (log(S/K)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d2 = (log(S/K)+(r-sig^2/2)*T)/(sig*sqrt(T));
% C_BS = -K*exp(-r*T)*normcdf(d2)+S*normcdf(d1);
% d3 = (log(S/B)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d4 = (log(S/B)+(r-sig^2/2)*T)/(sig*sqrt(T));
% C_BS_SB = -B*exp(-r*T)*normcdf(d4)+S*normcdf(d3);
% d5 = (log(S/B)+(r-sig^2/2)*T)/(sig*sqrt(T));
% d6 = (log(B/S)+(r-sig^2/2)*T)/(sig*sqrt(T));
% d7 = (log(((B^2)/S)/K)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d8 = (log(((B^2)/S)/K)+(r-sig^2/2)*T)/(sig*sqrt(T));
% C_BS1= -K*exp(-r*T)*normcdf(d8)+((B^2)/S)*normcdf(d7);
% d9 = (log(((B^2)/S)/B)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d10 =(log(((B^2)/S)/B)+(r-sig^2/2)*T)/(sig*sqrt(T));
% C_BS2= -B*exp(-r*T)*normcdf(d10)+((B^2)/S)*normcdf(d9);
% C_UO=C_BS - C_BS_SB -(B-K)*exp(-r*T)*normcdf(d5)-((B/S)^(2*v/(sig^2)))*(C_BS1-C_BS2-(B-K)*exp(-r*T)*normcdf(d6));
% 
% Error2=abs(RBF_Price-C_UO);
% S=S+1;
% x=log(S);
% RBF_Price=sum(lambda.*sqrt(((x-x1).*c).^2+1));
% v=(r-sig^2/2);
% d1 = (log(S/K)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d2 = (log(S/K)+(r-sig^2/2)*T)/(sig*sqrt(T));
% C_BS = -K*exp(-r*T)*normcdf(d2)+S*normcdf(d1);
% d3 = (log(S/B)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d4 = (log(S/B)+(r-sig^2/2)*T)/(sig*sqrt(T));
% C_BS_SB = -B*exp(-r*T)*normcdf(d4)+S*normcdf(d3);
% d5 = (log(S/B)+(r-sig^2/2)*T)/(sig*sqrt(T));
% d6 = (log(B/S)+(r-sig^2/2)*T)/(sig*sqrt(T));
% d7 = (log(((B^2)/S)/K)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d8 = (log(((B^2)/S)/K)+(r-sig^2/2)*T)/(sig*sqrt(T));
% C_BS1= -K*exp(-r*T)*normcdf(d8)+((B^2)/S)*normcdf(d7);
% d9 = (log(((B^2)/S)/B)+(r+sig^2/2)*T)/(sig*sqrt(T));
% d10 =(log(((B^2)/S)/B)+(r-sig^2/2)*T)/(sig*sqrt(T));
% C_BS2= -B*exp(-r*T)*normcdf(d10)+((B^2)/S)*normcdf(d9);
% C_UO=C_BS - C_BS_SB -(B-K)*exp(-r*T)*normcdf(d5)-((B/S)^(2*v/(sig^2)))*(C_BS1-C_BS2-(B-K)*exp(-r*T)*normcdf(d6));
% 
% Error3=abs(RBF_Price-C_UO);
% Error(1,1)=Error1;
% Error(1,2)=Error2;
% Error(1,3)=Error3;
% Error