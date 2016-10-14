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

function [U]=BSeuCallUI_FDA(S0,K,T,r,sigma)

M = 41;

%--- For the space adaption

space_tol=5*10^(-5);
space_fac = 0.01;
max_length = 1000;

Smin=0;
Smax=4*K;

S  = linspace(Smin,Smax,M); 

T = 1;
timesteps = 6;
dt = T/timesteps;

no_of_sols=3;

No_dims=1;

% Set up matrix for coarse problem

[A,h]=generatematrix(S,sigma,r);

% Set up initial condition for coarse problem

p0=payoff(S,K);

%Compute solution on coarse mesh

[solBDF(2:M-1),saved_sols] = BDF2_direct(A,Smax,K,r,p0(2:M-1),dt,timesteps,no_of_sols);

% Compute new adapted grid

[S_adapted,M]=adaption(A,S,h,saved_sols,no_of_sols,r,sigma,space_tol,space_fac,max_length);

timesteps = 189;
dt = T/timesteps;   

% Set up matrix for adapted problem

[A_adapted,h_adapted]=generatematrix(S_adapted,sigma,r);

% Set up initial condition for adapted problem

p0_adapted=payoff(S_adapted,K);

% Solve adapted problem

[solBDF_adapted(2:M-1),saved_sols_adapted] = BDF2_direct(A_adapted,Smax,K,r,p0_adapted(2:M-1),dt,timesteps,no_of_sols);

% Interpolate to measurement points

U=interp1(S_adapted(2:M-1),solBDF_adapted(2:M-1),S0,'spline');
