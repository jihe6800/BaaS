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

function [r]= residuals(x,f)

N=length(x);



for i=1:N-2
for j=1:N
   p1(i,j)=abs(x(i+1)-x(j)); %%Distance Matrix
 
end
end

x=x';
y1=f';

for i=1:N-2
    [y,I]=sort(p1(i,:));    %%Nearest Neighbors 
    x1(i)=x(I(1));
   
    % y2=y1(I(1));
    
  
    x0=(x((I(2:8))));   %%3-7 Near by Points

    y0=y1((I(2:8)))  ; 
   
        
    s(i,:)=pred1(x1(i),x0,y0);

 
      
      
end
r=s;
