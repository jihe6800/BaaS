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

function [U]=BSupoutCallI_FDA(S0,K,T,r,sigma,B)

Smin = 0;       
Smax = B; 
K = 100;

M = 41;

%--- For the space adaption

space_tol=13*10^(-4);
space_fac = 0.01;
max_length = 1000;

S  = linspace(Smin,Smax,M); 

timesteps = 6;
dt = T/timesteps;
   
no_of_sols=3;

No_dims=1;

% Set up matrix for coarse problem

[A,h]=generatematrix(S,sigma,r);

% Set up initial condition for coarse problem

p0=payoff(S,K);

%Compute solution on coarse mesh
                                   
[soldg(2:M-1),saved_sols] = dgdec_direct(A,Smax,K,r,p0(2:M-1),dt,timesteps,1,no_of_sols);

% Compute new adapted grid

[S_adapted,M]=adaption(A,S,h,saved_sols,no_of_sols,r,sigma,space_tol,space_fac,max_length);

% Set up matrix for adapted problem

[A_adapted,h_adapted]=generatematrix(S_adapted,sigma,r);

% Set up initial condition for adapted problem

p0_adapted=payoff(S_adapted,K);

% Solve adapted problem

timesteps = 11;
dt = T/timesteps;

[soldg_adapted(2:M-1),saved_sols] = dgdec_direct(A_adapted,Smax,K,r,p0_adapted(2:M-1),dt,timesteps,1,no_of_sols);

% Interpolate to measurement points

U = interp1(S_adapted(2:M-1),soldg_adapted(2:M-1),S0,'spline');
 
