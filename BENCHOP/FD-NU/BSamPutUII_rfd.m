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

function up = BSamPutUII_rfd(sp,K,T,r,sigma,varargin)
n = 16; m = 4;
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
u0 = max(K-s,0)';
u = u0;
mu = zeros(n-1,1);
%
ss = exp(0.5*dt*r)*s;
for k=1:2*me
  rhs = interp1(s,u,ss(2:n),'cubic')';
  rhs = rhs + 0.5*dt*mu;
  rhs(1) = rhs(1) + bl*u(1);
  ut = A\rhs;
  u(2:n) = ut - 0.5*dt*mu;
  mu = mu + (u0(2:n) - ut)/(0.5*dt);
  ee = find(u(2:n) > u0(2:n));
  mu(ee) = 0;
  u = max(u,u0);
end
%
ss = exp(dt*r)*s;
for k=me+1:m
  rhs = B*interp1(s,u,ss(2:n),'cubic')';
  rhs = rhs + dt*mu;
  rhs(1) = rhs(1) + 2*bl*u(1);
  ut = A\rhs;
  u(2:n) = ut - dt*mu;
  mu = mu + (u0(2:n) - ut)/dt;
  ee = find(u(2:n) > u0(2:n));
  mu(ee) = 0;
  u = max(u,u0);
end
%
up = max(K-sp,0);
ip = find(sp > smin & sp < smax);
up(ip) = interp1(s,u,sp(ip));
