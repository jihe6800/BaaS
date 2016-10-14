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

function [C, H, psihatL, psihatR] = Leg2(r)

C = zeros(r+1,r+1);
for i = 0:r
    for j = 0:r
        if j < i
            sigma = (-1)^(i+j);
        else
            sigma = 1;
        end
        C(i+1,j+1) = sigma*sqrt(i+0.5)*sqrt(j+0.5);
    end
end


% Generate vectors of Legendre polynomials evaluated at the left and right
% boundary.
psihatL = (-1).^(0:r).*sqrt((0:r) + 0.5);
psihatR = sqrt((0:r) + 0.5);

% Generate coefficient matrix for the right hand side
H = zeros(r+1,r+1);
for i = 1:r+1
    H(i,:) = psihatR*psihatL(i);
end
     

