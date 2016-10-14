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
    %along with BENCHOP. If not, see <http://www.gnu.org/licenses/>.% This code was originally produced by Emil Larsson and has been modified
% by Lina von Sydow.

function [u,saved_sols] = dgdec_direct(A,Smax,K,rate,u0,k,steps,r,no_of_sols)
 
 n=steps/no_of_sols;  
 for ii=no_of_sols:-1:1                                       %
    sol_at_timestep(no_of_sols-ii+1)=steps-(ceil((ii-1)*n));   %
 end
 sol_index=1;                                                 %
 saved_sols=[];                                               %
  
 sol_at_timestep = round(sol_at_timestep); %For very small dt!
le = length(u0);

% Generation of C, H matrix when Legendre polynomials of order r are used.
[C,H,~,psihatR] = Leg2(r);

% Diagonalize K-matrix
[Q,T] = eig(C);
invQ = inv(Q);

% Store diagonal values in an array for efficient access in parfor
lambda = diag(T);

% Precalculate inv(Q)*H*Q
QHQ = Q\H*Q;
%QHQ = invQ*H*Q;

% Pre-LU factorization stored in cells
L = cell(1,r+1);
U = cell(1,r+1);
G = cell(1,r+1);
for i = 1:r+1
    G{i} = lambda(i)*speye(le) - 0.5*k*A; % eqn. (19) in [1]
    [L{i}, U{i}] = lu(G{i});
end

% Can be replaced with bsxfun
% b = 1/psihatR(r+1)*kron(H(:,end), speye(le))*alpha0;
% g = kron(invQ, speye(le))*b; % eqn. (18) in [1]

b = zeros(le, r+1);
g = zeros(le, r+1);

% More efficient than kron but need two loops
for i = 1:r+1
    b(:,i) = 1/psihatR(r+1)*H(i,r+1)*u0';
end

for i = 1:r+1
    g(:,i) = sum(bsxfun(@times, b,invQ(i,:)),2);
end

for i = 1:r+1
   w(:,i)=U{i}\(L{i}\g(:,i));
end

% Updating the RHS
% g = kron(QHQ, speye(le))*warr;

% Updating the RHS replacing kron
for i = 1:r+1
    g(:,i) = sum(bsxfun(@times,w,QHQ(i,:)),2);
end

% Time integration
for ii = 1:steps-1
    % Use parfor when parallellizing this loop
    for i = 1:r+1
        w(:,i)=U{i}\(L{i}\g(:,i));
    end
    
    if ii==sol_at_timestep(sol_index)-1
      u = real(sum(bsxfun(@times,w,psihatR*Q),2));
      saved_sols=[saved_sols u];
      sol_index=sol_index+1;
    end
    
    % Updating the RHS
    % g = kron(QHQ, speye(le))*warr;
    
    % Updating the RHS replacing kron
    for i = 1:r+1
        g(:,i) = sum(bsxfun(@times,w,QHQ(i,:)),2);
    end

end

% Solution should be real
% u = real(kron(psihatR, speye(le))*kron(Q, speye(le))*warr);
u = real(sum(bsxfun(@times,w,psihatR*Q),2));

