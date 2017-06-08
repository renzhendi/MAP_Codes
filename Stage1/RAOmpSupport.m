function T = RAOmpSupport(y,A,k)

rnk = size(y,2);
r = orth(y);
T = [];

for j = 1:k
    w = A'*r;
    [~,i] = max(sum(w.*w,2));
    T = union(T,i);
    x = sparsesvd(A,y,T,rnk);
    r = orth(y-A*x);
end