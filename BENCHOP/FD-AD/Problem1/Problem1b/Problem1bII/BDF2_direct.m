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

function [q_impl,saved_sols] = BDF2_direct(A,Smax,K,r,p0,dt,steps,no_of_sols)

% Save some solutions

n=steps/no_of_sols; 
for ii=no_of_sols:-1:1                                       
sol_at_timestep(no_of_sols-ii+1)=steps-(ceil((ii-1)*n));  
end
sol_index=1;                                                 
saved_sols=[];                                               
  
sol_at_timestep = round(sol_at_timestep); %For very small dt!

%First time-step

p=p0(:); 

Atmp = speye(size(A)) - dt*A;

[L U] = lu(Atmp);
       
qtilde=U\(L\p);        

M=length(qtilde);
lambda=zeros(size(qtilde));
lambdaold=lambda;

q=qtilde+dt*(lambdaold-lambda);

for i=1:M
    if q(i)<p(i)
        q(i)=p(i);
        lambda(i)=lambdaold(i)-(q(i)-qtilde(i))/dt;
    end
end

 theta=1;
   
 alphai0 = (1+2*theta)/(1+theta);
 alphai1 = -1-theta;
 alphai2 = theta^2/(1+theta);
    
 Atmp = (alphai0*speye(size(A))-dt*A);
 
 [L,U]=lu(Atmp);
 
 %Remaining time-steps
 
 for ii=1:steps-1

    c = -alphai1.*q -alphai2.*p-2/3*dt*lambda;
    
    lambdaold=lambda;
    lambda=zeros(size(lambdaold));
    
    qtilde=U\(L\c);

    q_impl=qtilde+2/3*dt*(lambdaold-lambda);

    for i=1:M
        if q_impl(i)<p(i)
            q_impl(i)=p(i);
            lambda(i)=lambdaold(i)-(q_impl(i)-qtilde(i))/dt;
        end
    end
    % Save some solutions
    if ii==sol_at_timestep(sol_index)-1
       saved_sols=[saved_sols q_impl];
       sol_index=sol_index+1;
    end
    p=q;		           
    q=q_impl;
end







