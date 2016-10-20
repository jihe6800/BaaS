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

function [U]=BSeuCallspread_FDA(S0,T,r,sigma1,sigma2,rho)

M = 101;
S0=S0';

%--- For the space adaption

space_fac = 0.01;
max_length = 1000;

space_tol=3.6*10^(-3);

Smin=0;
Smax=350;

S1  = linspace(Smin,Smax,M);

Smin=0;
Smax=175;

S2  = linspace(Smin,Smax,M);

S_vals=[S1 S2];
vector_lengths=[length(S1) length(S2) ]; 

timesteps = 10;
dt = T/timesteps;
  
no_of_sols=3;

No_dims=1;

% Set up matrix for coarse problem

[A,h1,h2]=generatematrix(S_vals,M,M,sigma1,sigma2,rho,r);

% Set up initial condition for coarse problem

p0=payoff(S1(2:end-1),S2(2:end-1));

%Compute solution on coarse mesh
                                   
%[soldg,saved_sols] = dgdec(A,p0,dt,timesteps,1,no_of_sols);
[soldg,saved_sols] = BDF2_iter(A,p0,dt,timesteps,1,no_of_sols);
 
% Compute new adapted grid

[S_adapted,M]=adaption(A,S_vals,vector_lengths,[h1;h2],saved_sols,no_of_sols,r,sigma1,sigma2,rho,space_tol,space_fac,max_length);

S1_adapted=S_adapted(1:M(1));
S2_adapted=S_adapted(M(1)+1:end);

% Set up matrix for adapted problem

[A_adapted,h1_adapted,h2_adapted]=generatematrix(S_adapted,M(1),M(2),sigma1,sigma2,rho,r);

% Set up initial condition for adapted problem

p0_adapted=payoff(S1_adapted(2:end-1),S2_adapted(2:end-1));

% Solve adapted problem

timesteps = 40;
dt = T/timesteps;

%[soldg_adapted,saved_sols] = dgdec(A_adapted,p0_adapted,dt,timesteps,1,no_of_sols);
[soldg_adapted,saved_sols] = BDF2_iter(A_adapted,p0_adapted,dt,timesteps,1,no_of_sols);

% Interpolate to measurement points

soldg_mesh=reshape(soldg_adapted,[M(1)-2,M(2)-2]);

[SS1,SS2]=meshgrid(S1_adapted(2:end-1),S2_adapted(2:end-1));
[S01,S02]=meshgrid(S0(1,1:end),S0(2,1:end));

% size(SS1)
% size(SS2)
% size(soldg_mesh)

U=interp2(SS1,SS2,soldg_mesh',S0(1,1:end),S0(2,1:end),'spline');

 
  
