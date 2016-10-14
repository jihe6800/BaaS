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

function up = BSeuCallUII_rfd(sp,K,T,r,sigma,varargin)
n = 1.25*640; m = 64;
if nargin == 7
  n = varargin{1}; m = varargin{2};
end
me = 2;
%
sdel = 0.1*K;
s = 2*[0:n]/n - 1;
s = K + sdel*s.*abs(s);
smin = s(1);
smax = s(n+1);
%
ds = s(2:end) - s(1:end-1);
dl = 2./(ds(1:n-1).*(ds(1:n-1) + ds(2:n)));
dr = 2./(ds(2:n).*(ds(1:n-1) + ds(2:n)));
D = spdiags([[dl(2:n-1), 0]', -(dl+dr)', [0, dr(1:n-2)]'], -1:1, n-1,n-1);
cl = -0.5*ds(2:n).*dl;
cr = 0.5*ds(1:n-1).*dr;
C = spdiags([[cl(2:n-1), 0]', -(cl+cr)', [0, cr(1:n-2)]'], -1:1, n-1,n-1);
%
d2 = 0.5*sigma^2*ones(1,n-1);
al = -d2.*s(2:n).^2.*dl;
ar = -d2.*s(2:n).^2.*dr;
ac = r - al - ar;
A = spdiags([[al(2:n-1), 0]', ac', [0, ar(1:n-2)]'], -1:1, n-1,n-1);
%
dt = T/m;
B = speye(n-1) - 0.5*dt*A;
bl = -0.5*dt*al(1);
br = -0.5*dt*ar(n-1);
A = speye(n-1) + 0.5*dt*A;
%
u = max(s-K,0)';
%
ss = exp(0.5*dt*r)*s;
for k=1:2*me
  rhs = interp1(s,u,ss(2:n),'cubic')';
  u(n+1) = smax - K*exp(-0.5*dt*k*r);
  rhs(n-1) = rhs(n-1) + br*u(n+1);
  u(2:n) = A\rhs;
end
%
ss = exp(dt*r)*s;
for k=me+1:m
  rhs = B*interp1(s,u,ss(2:n),'cubic')';
  rhs(n-1) = rhs(n-1) + br*(ss(n+1) - K*exp(-dt*(k-1)*r));
  u(n+1) = smax - K*exp(-dt*k*r);
  rhs(n-1) = rhs(n-1) + br*u(n+1);
  u(2:n) = A\rhs;
end
%
up = max(sp-K*exp(-T*r),0);
ip = find(sp > smin & sp < smax);
up(ip) = interp1(s,u,sp(ip),'spline');
