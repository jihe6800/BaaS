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

function [x1, varargout]=coarserefine3(g,x1,err,cg,maxdis,e,f)


I1 = true;

LN=(x1(3)-x1(2));
a=round(maxdis/LN);
indx1=find(x1>e,1,'first');
indx2=find(x1<f,1,'last');

b=mod(indx1-2,a);
itr=(indx1-2-b)/a;
LN=1+b+itr;
xnew1=zeros(LN,1);
for i=1:2+b
    xnew1(i)=i;
end
for i=3+b:LN
   tt=xnew1(i-1)+a;
   xnew1(i)=tt;
end
b=mod(length(x1)-indx2-1,a);
itr=(length(x1)-indx2-b-1)/a;
LN=1+b+itr;
xnew2=zeros(LN,1);
for i=1:2+b
    xnew2(i)=length(x1)+1-i;
end
for i=3+b:LN
   tt=xnew2(i-1)-a;
   xnew2(i)=tt;
end
xnew3=(indx1:indx2)';
xnew4=sortrows([xnew1;xnew3]);
xnew=sortrows([xnew4;xnew2]);

x1=x1(xnew);
xnew1=zeros(2,1);
xnew1(1,1)=0.5*(x1(2)-x1(1))+x1(1);
xnew1(2,1)=0.5*(x1(end)-x1(end-1))+x1(end-1);
x1=sortrows([x1;xnew1]);
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

%Max_resid=max(resid);


%===========Refine=================

I1=find(resid(indx1:indx2)>err(1));
if isempty(I1)==0


     ref=I1+1+indx1;
     
     midpts=mid_points_amend1(x1,ref);
       
     x11=sortrows([x1;midpts]);

     
    


     QQ=length(x11)-length(x1);
% 
%      fprintf('Adding %i centers.',QQ);
     




 
else
    break
end
x1=x11;

N=length(x1);


end




if nargout>1
       
       varargout(1) ={c};
    if nargout>2
        
         
        varargout(2)={feval(g,x1)};
    end
end