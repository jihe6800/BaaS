 %Copyright (C) 2015 Jari Toivanen

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

function up = BSeuCallspread_rfd(S,T,r,sig1,sig2,rho)
n = 12*[64,64]; m = 12*16;
%
K = 0;
sp = S';
sigma = [sig1, sig2];
me = 4;
%
xk = 0.4;
save = sum(sp,2)/size(sp,2);
smax = (((1-xk)/xk)^2 + 1)*save;
s1 = [0:n(1)]/n(1) - xk;
s2 = [0:n(2)]/n(2) - xk;
s1 = s1.*abs(s1) + xk^2;
s2 = s2.*abs(s2) + xk^2;
s1 = (smax(1)/s1(n(1)+1))*s1;
s2 = (smax(2)/s2(n(2)+1))*s2;
%
z = [0, 0];
%
ds1 = s1(2:end) - s1(1:end-1);
ds1l = 2./(ds1(1:end-1).*(ds1(1:end-1) + ds1(2:end)));
ds1r = 2./(ds1(2:end).*(ds1(1:end-1) + ds1(2:end)));
Ds1 = spdiags([[ds1l, z]', -[0, ds1l+ds1r, 0]', [z, ds1r]'], -1:1, n(1)+1,n(1)+1);
cs1l = -0.5*ds1(2:end).*ds1l;
cs1r = 0.5*ds1(1:end-1).*ds1r;
Cs1 = spdiags([[cs1l, z]', -[0, cs1l+cs1r, 0]', [z, cs1r]'], -1:1, n(1)+1,n(1)+1);
Is1 = speye(n(1)+1);
%
ds2 = s2(2:end) - s2(1:end-1);
ds2l = 2./(ds2(1:end-1).*(ds2(1:end-1) + ds2(2:end)));
ds2r = 2./(ds2(2:end).*(ds2(1:end-1) + ds2(2:end)));
Ds2 = spdiags([[ds2l, z]', -[0, ds2l+ds2r, 0]', [z, ds2r]'], -1:1, n(1)+1,n(2)+1);
cs2l = -0.5*ds2(2:end).*ds2l;
cs2r = 0.5*ds2(1:end-1).*ds2r;
Cs2 = spdiags([[cs2l, z]', -[0, cs2l+cs2r, 0]', [z, cs2r]'], -1:1, n(2)+1,n(2)+1);
Is2 = speye(n(2)+1);
%
s1d = spdiags(s1',0,n(1)+1,n(1)+1);
s2d = spdiags(s2',0,n(2)+1,n(2)+1);
D = 0.5*sigma(1)^2*kron(Is2,s1d.^2)*kron(Is2,Ds1) ...
  + rho*sigma(1)*sigma(2)*kron(s2d,s1d)*kron(Cs2,Cs1) ...
  + 0.5*sigma(2)^2*kron(s2d.^2,Is1)*kron(Ds2,Is1);
C = r*kron(Is2,s1d)*kron(Is2,Cs1) + r*kron(s2d,Is1)*kron(Cs2,Is1);
nn = (n(1)+1)*(n(2)+1);
A = r*speye(nn) - D - C;
%
ib = [(n(1)+1)*ones(1,n(2)), 1:(n(1)+1)];
jb = [1:n(2), (n(2)+1)*ones(1,n(1)+1)];
kb = ib + (n(1)+1)*(jb-1);
nb = size(kb,2);
ki = setdiff([1:nn],kb);
ni = size(ki,2);
%
dt = T/m;
B = speye(nn) - 0.5*dt*A;
Bb = B(ki,kb);
B = B(ki,ki);
A = speye(nn) + 0.5*dt*A;
A = A(ki,ki);
[L,U,P,Q] = lu(A);
%
u = kron(s1',ones(1,n(2)+1)) - kron(ones(n(1)+1,1),s2) - K;
u(find(u < 0)) = 0;
%
u = reshape(u,nn,1);
for k=1:2*me
  rhs = u(ki);
  u(kb) = max(s1(ib) - (K + s2(jb))*exp(-0.5*dt*k*r),0);
  rhs = rhs + Bb*u(kb);
  u(ki) = Q*(U\(L\(P*rhs)));
end
for k=me+1:m
  rhs = B*u(ki);
  rhs = rhs + Bb*u(kb);
  u(kb) = max(s1(ib) - (K + s2(jb))*exp(-dt*k*r),0);
  rhs = rhs + Bb*u(kb);
  u(ki) = Q*(U\(L\(P*rhs)));
end
u = reshape(u,n(1)+1,n(2)+1);
%
for k=1:size(sp,2)
  up(k) = interp2(s2,s1',u,sp(2,k),sp(1,k),'spline');
end
