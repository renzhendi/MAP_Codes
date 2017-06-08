function T = OmpSupport(y,A,k)

rnk = size(y,2);
r = y;
T = [];

for j = 1:k
    w = A'*r;
    [~,i] = max(sum(w.*w,2));
    T = union(T,i);
    x = sparsesvd(A,y,T,rnk);
    r = y-A*x;
end