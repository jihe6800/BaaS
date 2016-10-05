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

function uu = predictor(xx,x,u,lambda,epsilon)

% Use RBF to interpolate values at new set points
% clear all
% clc
% K=15; %Strike Price
% r=0.05; %Interest rate
% sigma=0.3; %Volatility
% T=1; %Maturity
% cg=0.95;
% a=1; %interval [a,b]
% b=30; %interval [a,b]
% N=80;
% K=15; %Strike Price
% M=80;
% dt=T/M;
% theta=0.5;
% ExerciseType='c';
% ksi=zeros(N,1);%define the set of nodes form ksi_1 to ksi_N
% for i=1:N
%     ksi(i)=(i-1)*((log(b)-log(a))/(N-1))+log(a);
% end
% if ExerciseType=='p',
%     
%     g=@(ksi) max(K-exp(ksi),0);% The payoff of options
% else
%     g=@(ksi) max(exp(ksi)-K,0);% The payoff of options
% end
% 
% x1=ksi;
% u0=feval(g,x1);
% dx=diff(x1);
% c=cg*min([Inf;1./dx],[1./dx;Inf]);
% [Phi,Phi_1,Phi_2]=deal(zeros(N));
% for j=1:N
%     [Phi(:,j),Phi_1(:,j),Phi_2(:,j)]=mq(x1,x1(j),c(j));
% end
% x=x1;
% xx=x1;
% if ExerciseType=='p',
%         
%     u0(1)=K;
%     u0(end)=0; 
% else
%     u0(1)=0;
%     u0(end)=K;
% end
% lambda1=Phi\u0;
% lambda=Phi\eye(N);
%    I=eye(N,N);
%    P=I*r-0.5*(sigma^2)*(Phi\Phi_2)-(r-0.5*(sigma^2))*(Phi\Phi_1); 
%    H=I+dt*(1-theta)*P;
%    G=I-dt*theta*P;
%    lambda1=H\G*lambda1;
%    u0=Phi*lambda1;
% 
% 
% epsilon=c;
% u=u0;


N = length(x); 
Nxx = length(xx);
B = zeros(Nxx,N);
for j=1:N
    B(:,j) = mq(xx,x(j),epsilon(j));
end

uu = B*(lambda*u);

