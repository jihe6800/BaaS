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

function up = HSTeuCall_rfd(sp,K,T,r,vp,kappa,theta,sigma,rho,varargin)
n = [512,256]; m = 32;
if nargin == 11
  n = varargin{1}; m = varargin{2};
end
me = 2;
%
xk = 0.4;
smax = (((1-xk)/xk)^2 + 1)*K;
s = [0:n(1)]/n(1) - xk;
s = s.*abs(s) + xk^2;
s = (smax/s(n(1)+1))*s;
%
vmax = 1;
v = vmax*([0:n(2)]./n(2)).^2;
%
ds = s(2:end) - s(1:end-1);
dsl = 2./(ds(1:end-1).*(ds(1:end-1) + ds(2:end)));
dsr = 2./(ds(2:end).*(ds(1:end-1) + ds(2:end)));
Ds = spdiags([[dsl(2:end), 0]', -(dsl+dsr)', [0, dsr(1:end-1)]'], -1:1, n(1)-1,n(1)-1);
csl = -0.5*ds(2:end).*dsl;
csr = 0.5*ds(1:end-1).*dsr;
Cs = spdiags([[csl(2:end), 0]', -(csl+csr)', [0, csr(1:end-1)]'], -1:1, n(1)-1,n(1)-1);
Is = speye(n(1)-1);
%
dv = v(2:end) - v(1:end-1);
dv = [dv(1), dv, dv(end)];
dvl = 2./(dv(1:end-1).*(dv(1:end-1) + dv(2:end)));
dvr = 2./(dv(2:end).*(dv(1:end-1) + dv(2:end)));
dvl(end) = dvl(end) + dvr(end); dvr(end) = 0;
Dv = spdiags([[dvl(2:end), 0]', -(dvl+dvr)', [0, dvr(1:end-1)]'], -1:1, n(2)+1,n(2)+1);
cvl = -0.5*dv(2:end).*dvl;
cvr = 0.5*dv(1:end-1).*dvr;
cvl(1) = 0;
cvr(1) = 1/dv(2);
cvl(end) = cvl(end) + cvr(end); cvr(end) = 0;
Cv = spdiags([[cvl(2:end), 0]', -(cvl+cvr)', [0, cvr(1:end-1)]'], -1:1, n(2)+1,n(2)+1);
Iv = speye(n(2)+1);
%
vd = spdiags(v',0,n(2)+1,n(2)+1);
sd = spdiags(s(2:end-1)',0,n(1)-1,n(1)-1);
D = 0.5*kron(vd,sd.^2)*kron(Iv,Ds) ...
  + rho*sigma*kron(vd,sd)*kron(Cv,Cs) ...
  + 0.5*sigma^2*kron(vd,Is)*kron(Dv,Is);
C = r*kron(Iv,sd)*kron(Iv,Cs) + kappa*kron(theta*Iv-vd,Is)*kron(Cv,Is);
nn = (n(1)-1)*(n(2)+1);
A = r*speye(nn) - D - C;
ev = ones(n(2)+1,1);
al = -0.5*s(2)^2*dsl(1)*v' - r*s(2)*csl(1)*ev;
ar = -0.5*s(end-1)^2*dsr(end)*v' - r*s(end-1)*csr(end)*ev;
%
dt = T/m;
B = speye(nn) - 0.5*dt*A;
bl = -0.5*dt*al;
el = zeros(n(1)-1,1); el(1) = 1;
bl = kron(bl,el);
br = -0.5*dt*ar;
er = zeros(n(1)-1,1); er(end) = 1;
br = kron(br,er);
A = speye(nn) + 0.5*dt*A;
[L,U,P,Q] = lu(A);
%
u = kron(max(s-K,0)',ones(1,n(2)+1));
%
for k=1:2*me
  rhs = reshape(u(2:end-1,:),nn,1);
  u(end,:) = smax - K*exp(-0.5*dt*k*r);
  rhs = rhs + br*u(end,1);
%  sol = A\rhs;
  sol = Q*(U\(L\(P*rhs)));
  u(2:end-1,:) = reshape(sol,n(1)-1,n(2)+1);
end
%
for k=me+1:m
  rhs = B*reshape(u(2:end-1,:),nn,1);
  rhs = rhs + br*u(end,1);
  u(end,:) = smax - K*exp(-dt*k*r);
  rhs = rhs + br*u(end,1);
%  sol = A\rhs;
  sol = Q*(U\(L\(P*rhs)));
  u(2:end-1,:) = reshape(sol,n(1)-1,n(2)+1);
end
%
up = interp2(v,s',u,vp,sp,'spline')';
