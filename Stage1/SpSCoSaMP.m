% SCoSaMP
% Precondition: A is an m*n matrix, y is an m*r vector,
% k is the sparsity of signal x, and should be a positive integer,
% rnk is the rank of x.
% Postcondition: outputs an n*1 vector x, an approximation of solution
% to the system of linear equations Ax = y

function T = SpSCoSaMP(A,y,k,rnk,e)

% initialization
[~,n] = size(A);
% x = zeros(n,rnk);
r = y;          % residual
Nr = norm(r,'fro');   % magnitude of residual
s = min(n,k);   % 2k largest entries
T = [];         % support set
i=1;            % iteration counter

% iteration & update
while Nr>e && i<=10 % if possible, solve the problem within tolerance; otherwise stop ASAP
    H = PrincipleSupport(r,A,s);
    U = union(T,H);             % higher efficiency with mergesort or binary tree
    u = sparsesvd(A,y,U,rnk);   % least squares solutions
    T = PrincipleSupport2(u,k); % support set
    x = zeros(n,rnk);
    x(T,:) = u(T,:);            % approximation
    r = y-A*x;                  % residual
    Nr = norm(r,'fro');
    i = i+1;                    % iteration counter
end

if i>10 % run for iterations
    while Nr>e && i<=n/2 % if possible, solve the problem within tolerance; otherwise stop ASAP
        H = PrincipleSupport(r,A,s);
        U = union(T,H);             % higher efficiency with mergesort or binary tree
        u = sparsesvd(A,y,U,rnk);   % least squares solutions
        T = PrincipleSupport2(u,k); % support set
        x = sparsesvd(A,y,T,rnk);
        T = find(sum(x,2));
        r = y-A*x;                  % residual
        Nr = norm(r,'fro');
        i = i+1;                    % iteration counter
    end
end