% sparsesvd
% Precondition: A is an m*n matrix, y is an m*1 vector,
% T is a set of index
% Postcondition: outputs n*1 vector x, an approximation of solution
% to the system of linear equations Ax = y

function x = sparsesvd(A,y,T,rnk)

[U,S,V] = svd(A(:,T),'econ');
w = U'*y;
for i = 1:rnk
    w(:,i) = w(:,i)./diag(S);
end
z = V*w;
n = size(A,2);
x = zeros(n,rnk);
x(T,:) = z;