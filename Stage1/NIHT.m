% NIHT_mark2
function T = NIHT(A,y,k,rnk,e)

n = size(A,2);
x = zeros(n,rnk);
resid = y; % residual
proj = A'*resid;
approx = x+proj;
T = PrincipleSupport2(approx,k);
x = zeros(n,rnk);
x(T,:) = approx(T,:);
resid = y-A*x;
Nr = norm(resid,'fro');
i = 2; % iteration counter

while Nr>e && i<=n/4
    proj = A'*resid;
    w = norm(proj(T,:),'fro')/norm(A(:,T)*proj(T,:),'fro');
    w = w^2;
    approx = x+w*proj;
    T = PrincipleSupport2(approx,k);
    x = zeros(n,rnk);
    x(T,:) = approx(T,:);
    resid = y-A*x;
    Nr = norm(resid,'fro');
    i = i+1;
end