function [y, A, x] = createRowProblem(k,m,n,r,distr)

if nargin<5
  distr=1;
  if nargin<4
    r=1;
  end
end

r=min(k,r);

A=randn(m,n)/sqrt(m);  
T=randperm(n,k);
x=zeros(n,r);

if distr>0
  w=randn(k,r);
  if distr==1
    w=sign(w);
  end
else
  w=rand(k,r);
end


x(T,:)=w;  

y=A*x;   
