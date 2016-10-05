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

function z = mid_points_amend1(x,p)

N=length(x);
for i=1:length(p)
midl(i,:)= (x(p(i)-1)+x(p(i)))/2;
midr(i,:)=(x(p(i)+1)+x(p(i)))/2;
z(1,2*i-1)=midl(i,1);
%z(2,2*i-1)=p(i);
z(1,2*i)=midr(i,1);
%z(2,2*i)=p(i)+2;
end
%z1=z(2,:)';
z=z(1,:)';
%  coarsen=resid(1:N-3)<10^-5 & resid(2:N-2) < 10^-5;
%  cp=1+find(coarsen);
%  x(cp)=[];
%  z=[midl;midr]; %sortrows([midl;midr]);
% [midl;midr]
%  
%  
 zx=z; ii=[];
 I=find(zx);
 A=sortrows([zx I]); 
for i=1:(length(zx)-1)
    
    if A(i,1)==A(i+1,1), 
        ii=[ii i+1]; 
    end
   
end
% z1=z1(A(:,2));
% A(:,3)=z1;

A(ii,:)=[];
%A=sortrows([A(:,2) A(:,1)]); 
%A=A(:,2);
z= A(:,1);

% midpts=zeros(length(midl),2);
% midpts(:,1)=midl;
% midpts(:,2)=midr;
% if nargout>1
%    
%   varargout(1) ={A(:,3)};
    

end