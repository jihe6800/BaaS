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

function [A,h1,h2]=generatematrix(X,lengthX1,lengthX2,sigma1,sigma2,rho,r); 
 
X1=X(1:lengthX1);
X2=X(lengthX1+1:end);

h1=zeros(1,lengthX1-1);

for i=1:lengthX1-1
    h1(i)=X1(i+1)-X1(i);
end

X1inner=X1(2:end-1);
N1=length(X1inner); 
A1=spalloc(N1,N1,3*N1-2);
	
h2=zeros(1,lengthX2-1);

for i=1:lengthX2-1
    h2(i)=X2(i+1)-X2(i);
end

X2inner=X2(2:end-1);
N2=length(X2inner); 
A2=spalloc(N2,N2,3*N2-2); 

ax=zeros(1,N1);  % allocate room for the coefficients
bx=zeros(1,N1);
cx=zeros(1,N1);
axx=zeros(1,N1);
bxx=zeros(1,N1);
cxx=zeros(1,N1);

ay=zeros(1,N2);  % allocate room for the coefficients
by=zeros(1,N2);
cy=zeros(1,N2);
ayy=zeros(1,N2);
byy=zeros(1,N2);
cyy=zeros(1,N2);

% Creating first der. coeff

ax(2:N1-1)=h1(2:N1-1)./(h1(3:N1).*(h1(2:N1-1)+h1(3:N1)));
bx(2:N1-1)=(h1(3:N1)-h1(2:N1-1))./(h1(2:N1-1).*h1(3:N1));
cx(2:N1-1)=-h1(3:N1)./(h1(2:N1-1).*(h1(2:N1-1)+h1(3:N1)));

ax(1)=1/h1(1);
bx(1)=-1/h1(1);
cx(1)=0;

ax(N1)=0;
bx(N1)=1/h1(N1);
cx(N1)=-1/h1(N1);

ay(2:N2-1)=h2(2:N2-1)./(h2(3:N2).*(h2(2:N2-1)+h2(3:N2)));
by(2:N2-1)=(h2(3:N2)-h2(2:N2-1))./(h2(2:N2-1).*h2(3:N2));
cy(2:N2-1)=-h2(3:N2)./(h2(2:N2-1).*(h2(2:N2-1)+h2(3:N2)));

ay(1)=1/h2(1);
by(1)=-1/h2(1);
cy(1)=0;

ay(N2)=0;
by(N2)=1/h2(N2);
cy(N2)=-1/h2(N2);

% Creating second der. coeff

axx(2:N1-1)=2./(h1(3:N1).*(h1(2:N1-1)+h1(3:N1)) );
bxx(2:N1-1)=-2./(h1(2:N1-1).*h1(3:N1)) ;
cxx(2:N1-1)=2./(h1(2:N1-1).*(h1(2:N1-1)+h1(3:N1)));

axx(1)=0;
bxx(1)=0;
cxx(1)=0;

axx(N1)=0;
bxx(N1)=0;
cxx(N1)=0;

ayy(2:N2-1)=2./(h2(3:N2).*(h2(2:N2-1)+h2(3:N2)) );
byy(2:N2-1)=-2./(h2(2:N2-1).*h2(3:N2)) ;
cyy(2:N2-1)=2./(h2(2:N2-1).*(h2(2:N2-1)+h2(3:N2)));

ayy(1)=0;
byy(1)=0;
cyy(1)=0;

ayy(N2)=0;
byy(N2)=0;
cyy(N2)=0;

% Computing matrix

lowerx=r*X1inner.*cx+0.5*sigma1^2*X1inner.^2.*cxx;
midx=r*X1inner.*bx+0.5*sigma1^2.*X1inner.^2.*bxx-r;
upperx=r*X1inner.*ax+0.5*sigma1^2*X1inner.^2.*axx;

A1=spdiags([[lowerx(2:N1)'; 0] midx' [0;upperx(1:N1-1)']],-1:1,N1,N1);

lowery=r*X2inner.*cy+0.5*sigma2^2*X2inner.^2.*cyy;
midy=r*X2inner.*by+0.5*sigma2^2.*X2inner.^2.*byy;
uppery=r*X2inner.*ay+0.5*sigma2^2*X2inner.^2.*ayy;

A2=spdiags([[lowery(2:N2)'; 0] midy' [0;uppery(1:N2-1)']],-1:1,N2,N2);

lowerx=X1inner.*cx;
midx=X1inner.*bx;
upperx=X1inner.*ax;

A1mix=spdiags([[lowerx(2:N1)'; 0] midx' [0;upperx(1:N1-1)']],-1:1,N1,N1);

lowery=X2inner.*cy;
midy=X2inner.*by;
uppery=X2inner.*ay;

A2mix=spdiags([[lowery(2:N2)'; 0] midy' [0;uppery(1:N2-1)']],-1:1,N2,N2);

A=kron(speye(N2),A1)+kron(A2,speye(N1))+rho*sigma1*sigma2*kron(A2mix,A1mix);

