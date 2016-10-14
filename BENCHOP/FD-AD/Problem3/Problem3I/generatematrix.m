 %Copyright (C) 2015 Lina von Sydow

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
% This code was originally produced by Jonas Persson and has been modified
% by Lina von Sydow.

function [A,h]=generatematrix(X,sigma,r)  
  
lengthX=length(X);
h=zeros(1,lengthX-1);

for i=1:lengthX-1
    h(i)=X(i+1)-X(i);
end

Xinner=X(2:end-1);
N=length(Xinner); % N is the number of gridpoints in each
                        % direction in the inner of the grid.
A=spalloc(N,N,3*N-2); 

	

ax=zeros(1,N);  % allocate room for the coefficients
bx=zeros(1,N);
cx=zeros(1,N);
axx=zeros(1,N);
bxx=zeros(1,N);
cxx=zeros(1,N);

     
% Creating first der. coeff
     
ax(1:N-1)=h(1:N-1)./(h(2:N).*(h(1:N-1)+h(2:N)));
bx(1:N-1)=(h(2:N)-h(1:N-1))./(h(1:N-1).*h(2:N));
cx(1:N-1)=-h(2:N)./(h(1:N-1).*(h(1:N-1)+h(2:N)));

ax(N)=0;
bx(N)=1/h(N);
cx(N)=-1/h(N);

% Creating second der. coeff

axx(1:N-1)=2./(h(2:N).*(h(1:N-1)+h(2:N)) );
bxx(1:N-1)=-2./(h(1:N-1).*h(2:N)) ;
cxx(1:N-1)=2./(h(1:N-1).*(h(1:N-1)+h(2:N)));

axx(N)=0;
bxx(N)=0;
cxx(N)=0;

% Computing matrix

lower=r*Xinner.*cx+0.5*sigma(2:end-1).^2.*Xinner.^2.*cxx;
mid=r*Xinner.*bx+0.5*sigma(2:end-1).^2.*Xinner.^2.*bxx-r;
upper=r*Xinner.*ax+0.5*sigma(2:end-1).^2.*Xinner.^2.*axx;

A=spdiags([[lower(2:N)'; 0] mid' [0;upper(1:N-1)']],-1:1,N,N);
