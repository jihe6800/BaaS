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
    %along with BENCHOP. If not, see <http://www.gnu.org/licenses/>.% This code was originally produced by Jonas Persson and has been modified
% by Lina von Sydow.

function [q_impl,saved_sols] = BDF2_iter(A,u0,dt,steps,r,no_of_sols)

% Save some solutions

n=steps/no_of_sols;
for ii=no_of_sols:-1:1
    sol_at_timestep(no_of_sols-ii+1)=steps-(ceil((ii-1)*n));
end
sol_index=1;
saved_sols=[];

sol_at_timestep = round(sol_at_timestep); %For very small dt!

%First time-step

p=u0';

Atmp = speye(size(A)) - dt*A;

setup.droptol = 1e-3;

% [L,U]=ilu(Atmp,setup);
%
% [q, ~] = gmres(Atmp,p,6,1e-8,200,L,U,p);

q=Atmp\p;

theta=1;

alphai0 = (1+2*theta)/(1+theta);
alphai1 = -1-theta;
alphai2 = theta^2/(1+theta);

%Remaining time-steps

Atmp = (alphai0*speye(size(A))-dt*A);
% [L,U]=ilu(Atmp,setup);
[L,U]=lu(Atmp);
for ii=1:steps-1
    
    c = -alphai1.*q -alphai2.*p;
    
    %    [q_impl,~]=gmres(Atmp,c,6,1e-8,200,L,U,q);
    
    q_impl=U\(L\c);
    
    % Save some solutions
    if ii==sol_at_timestep(sol_index)-1
        saved_sols=[saved_sols q_impl];
        sol_index=sol_index+1;
    end
    p=q;
    q=q_impl;
end