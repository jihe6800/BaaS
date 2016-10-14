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
    %along with BENCHOP. If not, see <http://www.gnu.org/licenses/>.

function [U]=BSeuCallUII_FDA(S0,K,T,r,sigfunction)

%--- For the space adaption

space_tol=1.7*10^(-4);
space_fac = 0.01;
max_length = 1000;

Smin=0;
Smax=4*K;
   
no_of_sols=3;

No_dims=1;

for ii=1:length(S0)
    
    timesteps = 6;
    dt = T/timesteps;
    time=[0:dt:T];
    
    M = 41;
    S  = linspace(Smin,Smax,M); 
    
    clear sigmatrix
    
    for j=1:length(time)
        sigmatrix(1:length(S),j)=sigfunction(r,S0(ii),S,time(j));
    end

% Set up initial condition for coarse problem

    p0=payoff(S,K);

%Compute solution on coarse mesh
                                   
    [solbdf(2:M-1),saved_sols,sol_at_timestep] = BDF2_direct(S,sigmatrix,r,Smax,K,p0(2:M-1),dt,timesteps,no_of_sols);

    [S_adapted,M]=adaption(sol_at_timestep,timesteps,S,saved_sols,no_of_sols,r,sigmatrix,space_tol,space_fac,max_length);

    timesteps = 31;
    dt = T/timesteps;
    time=[0:dt:T];
    
    for j=1:length(time)
        sigmatrix(1:length(S_adapted),j)=sigfunction(r,S0(ii),S_adapted,time(j));
    end

% Set up initial condition for adapted problem

    p0_adapted=payoff(S_adapted,K);

    [solbdf_adapted(2:M-1),saved_sols,sol_at_timestep] = BDF2_direct(S_adapted,sigmatrix,r,Smax,K,p0_adapted(2:M-1),dt,timesteps,no_of_sols);

    U(ii)=interp1(S_adapted(2:M-1),solbdf_adapted(2:M-1),S0(ii),'spline');
    
end
