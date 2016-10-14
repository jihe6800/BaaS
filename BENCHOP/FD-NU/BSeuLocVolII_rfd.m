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

function up = BSeuLocVolII_rfd(sp,K,T,r,sigma,varargin)
n = 0.75*640; m = 0.625*64;
if nargin == 7
  n = varargin{1}; m = varargin{2};
end
for i=1:length(sp)
  up(i) = BSeuLocVol_rfd(sp(i),K,T,r,@(s,t)sigma(r,sp(i),s,t),n,m);
end
end

function up = BSeuLocVol_rfd(sp,K,T,r,sigma,n,m)
me = 2;
%
xk = 0.4;
smax = (((1-xk)/xk)^2 + 1)*K;
s = [0:n]/n - xk;
s = s.*abs(s) + xk^2;
s = (smax/s(n+1))*s;
%
ds = s(2:end) - s(1:end-1);
dl = 2./(ds(1:n-1).*(ds(1:n-1) + ds(2:n)));
dr = 2./(ds(2:n).*(ds(1:n-1) + ds(2:n)));
cl = -0.5*ds(2:n).*dl;
cr = 0.5*ds(1:n-1).*dr;
cl = r*s(2:n).*cl;
cr = r*s(2:n).*cr;
%
dt = T/m;
u = max(s-K,0)';
%
for k=1:2*me
  rhs = u(2:n);
  tau = 0.5*dt*k;
%
  d2 = 0.5*sigma(s(2:n),T-tau).^2;
%  d2 = 0.5*sigma(s(2:n),tau).^2;
  al = -d2.*s(2:n).^2.*dl - cl;
  ar = -d2.*s(2:n).^2.*dr - cr;
  ac = r - al - ar;
  A = spdiags([[al(2:n-1), 0]', ac', [0, ar(1:n-2)]'], -1:1, n-1,n-1);
%
  B = speye(n-1) - 0.5*dt*A;
  bl = -0.5*dt*al(1);
  br = -0.5*dt*ar(n-1);
  A = speye(n-1) + 0.5*dt*A;
%
  u(n+1) = smax - K*exp(-tau*r);
  rhs(n-1) = rhs(n-1) + br*u(n+1);
  u(2:n) = A\rhs;
end
%
for k=me+1:m
  rhs = B*u(2:n);
  rhs(n-1) = rhs(n-1) + br*u(n+1);
  tau = dt*k;
%
  d2 = 0.5*sigma(s(2:n),T-tau).^2;
%  d2 = 0.5*sigma(s(2:n),tau).^2;
  al = -d2.*s(2:n).^2.*dl - cl;
  ar = -d2.*s(2:n).^2.*dr - cr;
  ac = r - al - ar;
  A = spdiags([[al(2:n-1), 0]', ac', [0, ar(1:n-2)]'], -1:1, n-1,n-1);
%
  B = speye(n-1) - 0.5*dt*A;
  bl = -0.5*dt*al(1);
  br = -0.5*dt*ar(n-1);
  A = speye(n-1) + 0.5*dt*A;
%
  u(n+1) = smax - K*exp(-tau*r);
  rhs(n-1) = rhs(n-1) + br*u(n+1);
  u(2:n) = A\rhs;
end
%
up = interp1(s,u,sp,'spline');
end
