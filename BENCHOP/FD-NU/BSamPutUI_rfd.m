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

function up = BSamPutUI_rfd(sp,K,T,r,sigma,varargin)
n = 1.25*640; m = 4*64;
if nargin == 7
  n = varargin{1}; m = varargin{2};
end
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
%
d2 = 0.5*sigma^2*ones(1,n-1);
al = -d2.*s(2:n).^2.*dl - r*s(2:n).*cl;
ar = -d2.*s(2:n).^2.*dr - r*s(2:n).*cr;
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
for k=1:2*me
  rhs = u(2:n) + 0.5*dt*mu;
  rhs(1) = rhs(1) + bl*u(1);
  ut = A\rhs;
  u(2:n) = ut - 0.5*dt*mu;
  mu = mu + (u0(2:n) - ut)/(0.5*dt);
  ee = find(u(2:n) > u0(2:n));
  mu(ee) = 0;
  u = max(u,u0);
end
%
for k=me+1:m
  rhs = B*u(2:n) + dt*mu;
  rhs(1) = rhs(1) + 2*bl*u(1);
  ut = A\rhs;
  u(2:n) = ut - dt*mu;
  mu = mu + (u0(2:n) - ut)/dt;
  ee = find(u(2:n) > u0(2:n));
  mu(ee) = 0;
  u = max(u,u0);
end
%
up = interp1(s,u,sp,'spline');
