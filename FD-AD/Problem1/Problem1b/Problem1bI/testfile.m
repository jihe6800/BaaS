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
sig = 0.15;
K = 100;
T = 1;

S=[90,100,110]

tic
[U]=BSamPutUI_FDA(S,K,T,r,sig)
toc

Uref = [10.7264867100  4.8206081848  1.8282075840]

Relerr=(U-Uref)./Uref

