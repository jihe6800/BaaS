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

function [x1, varargout]=coarserefine(g,x1,err,cg,e,f)

I1 = true;
N=length(x1);

while any(I1)
 
dx=diff(x1);
c=cg*min([Inf;1./dx],[1./dx;Inf]);

Phi=zeros(N,N);

for j=1:N
   
    Phi(:,j)=mq(x1,x1(j),c(j));
  
end


lambda=Phi\feval(g,x1);

mq_aprox=Phi*lambda;
spline_aprox = residuals(x1,mq_aprox);

mq_aprox(1)=[];
mq_aprox(end)=[];


%===========Max residual===========

indx1=find(x1>e,1,'first');
indx2=find(x1<f,1,'last');
resid= abs(mq_aprox-spline_aprox);

% Max_resid=max(resid);


%===========Refine=================

I1=find(resid(indx1:indx2)>err(1));
if isempty(I1)==0


 ref=I1+indx1;
 if isempty(ref)==0
     
%      midpts=mid_points_amend1(x2,ref);
       
%      x11=sortrows([x1;midpts]);
     midpts=x1(ref)+0.5*dx(ref);

     QQ=length(midpts);

     %fprintf('Adding %i centers.',QQ);


 end
 
else
    break
end

%===========Coarsening==================


 
% I= find(resid < err(2));
Leftside=find(resid(1:indx1-1) < err(2));
Rightside=find(resid(indx2:end) < err(2));
Middle=find(resid(indx1:indx2-1) < err(2));
if isempty(Leftside)==0 
    coarse_resid= resid(Leftside);
    A=sortrows([coarse_resid Leftside]);
    A= A(:,2)+1;
    p= length(Leftside);
    q= round(2/100 *(p));
    Coarsenpoint=A(1:q);
else
    Coarsenpoint=[];
end
if isempty(Rightside)==0 
    coarse_resid= resid(Rightside+indx2-1);
    A=sortrows([coarse_resid Rightside]);
    A= A(:,2)+indx2+1;
    p= length(Rightside);
    q= round(2/100 *(p));
    Coarsenpoint1=A(1:q);
else
    Coarsenpoint1=[];
end
if isempty(Middle)==0 
    coarse_resid= resid(Middle+indx1-1);
    A=sortrows([coarse_resid Middle]);
    A= A(:,2)+indx1+1;
    p= length(Middle);
    q= round(2/100 *(p));
    Coarsenpoint2=A(1:q);
else
    Coarsenpoint2=[];
end
Coarsenpoint1=sortrows([Coarsenpoint1;Coarsenpoint2]);
Coarsenpoint=sortrows([Coarsenpoint1;Coarsenpoint]);
x1(Coarsenpoint)=[];

% ---coarsening points
 
%   if isempty(I)==0
%    coarse_resid= resid(I);
%    A=sortrows([coarse_resid I]);
%    A= A(:,2);
%    p= length(I);
%    q= round(30/100 *( p));
%    
%    %points_coarse=  x(A(1:q));
% %     x1(A(1:q)+1);
%     x1(A(1:q))=[];
%     fprintf('Removing %i centers.',q)
% 
%   end
x1=sortrows([x1;midpts]);
N=length(x1);

end





if nargout>1
       
       varargout(1) ={c};
    if nargout>2
        
         
        varargout(2)={feval(g,x1)};
    end
end