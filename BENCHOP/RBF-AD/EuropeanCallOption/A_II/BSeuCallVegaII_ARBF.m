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

function RBF_Price=BSeuCallVegaII_ARBF(S,K,T,r,sig)
% ========================
% Parameters for The Options
% ========================
 
% S=[97,98,99]; %Stock price at time 0
% K=100; %Strike Price
% r=0.10; %Interest rate
% sig=0.01; %Volatility
% T=0.25; %Maturity

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
% Vega=[10.689829936518105 12.307387008891816 0.224407208464969];
% Error=(Vega-RBF_Price)./Vega
end
