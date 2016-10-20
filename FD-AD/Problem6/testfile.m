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
    %along with BENCHOP. If not, see <http://www.gnu.org/licenses/>.clear all
close all

r = 0.03;
sig1 = 0.15;
sig2 = 0.15;
rho = 0.5;
T = 1;

S=[100,100,100,90,110;
    90,100,110,100,100]';

tic
[U]=BSeuCallspread_FDA(S,T,r,sig1,sig2,rho)
toc

Uref=[12.021727425647768, 5.978528810578943, 2.500244806693065, 2.021727425647768, 12.500244806693061]; 

Relerr=(U-Uref)./Uref
