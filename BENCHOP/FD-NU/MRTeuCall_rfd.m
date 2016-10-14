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

function up = MRTeuCall_rfd(sp,K,T,r,sigma,lambda,gamma,delta,varargin)
n = 300; m = 128;
if nargin == 10
  n = varargin{1}; m = varargin{2};
end
%
gammam = gamma + 0.5*delta^2;
me = 2;
%
xk = 1/3;
smax = (((1-xk)/xk)^2 + 1)*K;
s = [0:n]/n - xk;
s = s.*abs(s) + xk^2;
s = (smax/s(n+1))*s;
%
ds = s(2:end) - s(1:end-1);
dl = 2./(ds(1:n-1).*(ds(1:n-1) + ds(2:n)));
dr = 2./(ds(2:n).*(ds(1:n-1) + ds(2:n)));
D = spdiags([[dl(2:n-1), 0]', -(dl+dr)', [0, dr(1:n-2)]'], -1:1, n-1,n-1);
cl = -0.5*ds(2:n).*dl;
cr = 0.5*ds(1:n-1).*dr;
C = spdiags([[cl(2:n-1), 0]', -(cl+cr)', [0, cr(1:n-2)]'], -1:1, n-1,n-1);
%
xi = exp(gammam) - 1;
d2 = 0.5*sigma^2*ones(1,n-1);
al = -d2.*s(2:n).^2.*dl - (r - lambda*xi)*s(2:n).*cl;
ar = -d2.*s(2:n).^2.*dr - (r - lambda*xi)*s(2:n).*cr;
ac = r + lambda - al - ar;
A = spdiags([[al(2:n-1), 0]', ac', [0, ar(1:n-2)]'], -1:1, n-1,n-1);
%
dt = T/m;
B = speye(n-1) - 0.5*dt*A;
bl = -0.5*dt*al(1);
br = -0.5*dt*ar(n-1);
A = speye(n-1) + 0.5*dt*A;
%
J = MertonJump(lambda,delta,gammam,s);
J = -0.5*dt*J(2:n,2:n);
%
u = max(s-K,0)';
%
for k=1:2*me
  if mod(k,2) == 1
    up = u;
  end
  rhs = u(2:n) + J*u(2:n);
  u(n+1) = smax - K*exp(-0.5*dt*k*r);
  rhs(n-1) = rhs(n-1) + br*u(n+1);
  u(2:n) = A\rhs;
end
%
for k=me+1:m
  rhs = B*u(2:n) + J*(3*u(2:n) - up(2:n));
  rhs(n-1) = rhs(n-1) + br*u(n+1);
  un(n+1) = smax - K*exp(-dt*k*r);
  rhs(n-1) = rhs(n-1) + br*un(n+1);
  un(2:n) = A\rhs;
  up = u; u = un';
end
%
up = interp1(s,u,sp,'spline');
end

function A = MertonJump(lambda,delta,gamma,x)
n = size(x,2);
A = zeros(n);
for i=2:n-1
  k = 1;
  sr = log(x(k+1)) - log(x(i));
  dx = x(k+1) - x(k);
  el = -1.0;
  er = erf((sr - gamma - 0.5*delta^2)/(sqrt(2.0)*delta));
  A(i,k) = A(i,k) + 0.5*exp(gamma)*(er - el)*(-x(i))/dx;
  A(i,k+1) = A(i,k+1) + 0.5*exp(gamma)*(er - el)*(x(i))/dx;
  el = -1.0;
  er = erf((sr - gamma + 0.5*delta^2)/(sqrt(2.0)*delta));
  A(i,k) = A(i,k) + 0.5*(er - el)*(x(k+1))/dx;
  A(i,k+1) = A(i,k+1) + 0.5*(er - el)*(-x(k))/dx;
%
  sl = log(x(2:n-1)) - log(x(i));
  sr = log(x(3:n)) - log(x(i));
  dx = x(3:n) - x(2:n-1);
  el = erf((sl - gamma - 0.5*delta^2)/(sqrt(2.0)*delta));
  er = erf((sr - gamma - 0.5*delta^2)/(sqrt(2.0)*delta));
  A(i,2:n-1) = A(i,2:n-1) + 0.5*exp(gamma)*(er - el)*(-x(i))./dx;
  A(i,3:n) = A(i,3:n) + 0.5*exp(gamma)*(er - el)*(x(i))./dx;
  el = erf((sl - gamma + 0.5*delta^2)/(sqrt(2.0)*delta));
  er = erf((sr - gamma + 0.5*delta^2)/(sqrt(2.0)*delta));
  A(i,2:n-1) = A(i,2:n-1) + 0.5*(er - el).*(x(3:n))./dx;
  A(i,3:n) = A(i,3:n) + 0.5*(er - el).*(-x(2:n-1))./dx;
end
A = -lambda*A;
end
