 %Copyright (C) 2015 Jeremy Levesley

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

function [phi,phi1,phi2] = mq(x,xc,c)
% 1-D multiquadric radial basis function
f = @(r,c) sqrt((c*r).^2 + 1);

r = x - xc;
phi = f(r,c);

if nargout > 1
% 1-st derivative    
phi1 = (c^2)*r./phi;
    if nargout > 2
    % 2-nd derivative
    phi2 = (c^2)./(phi.^3);
%         if nargout > 3
%         % 3-rd derivative    
%         phi3 = -3*(c^4)*r./(phi.^5);
%             if nargout > 4
%             % 4-th derivative        
%             phi4 = 12*(c^4)*((c*r).^2-0.25)./(phi.^7);
%             end
   end
%     end
end