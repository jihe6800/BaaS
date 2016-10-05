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

function [ RBF_Price ] = BSupoutCallI_ARBF(S,K,T,r,sig,B)
% S=[90 100 110];
% K=100;
% B=125;
% r=0.03;
% sig=0.15;
% K=100;
% T=1;

LN=length(S);
RBF_Price=zeros(1,LN);
for i=1:LN
    
RBF_Price(1,i)=BSupoutCallI(S(1,i),K,T,r,sig,B);

end
end

