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

function [ RBF_Price ] = BSeuCallGammaII_ARBF(S,K,T,r,sig)
% S=[97, 98, 99];
% K=100;
% r=0.1;
% sig=0.01;
% K=100;
% T=0.25;

LN=length(S);
RBF_Price=zeros(1,LN);
for i=1:LN
    
RBF_Price(1,i)=BSeuCallGammaII(S(1,i),K,T,r,sig);

end
% Gamma=[0.454451267361807 0.512594211115861 0.009158543351289];
% err=abs(Gamma-RBF_Price)./Gamma
end
