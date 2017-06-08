% SCoSaMP
% Precondition: A is an m*n matrix, y is an m*r vector,
% k is the sparsity of signal x, and should be a positive integer,
% rnk is the rank of x.
% Postcondition: outputs an n*1 vector x, an approximation of solution
% to the system of linear equations Ax = y

function T = SCoSaMP(A,y,k,rnk,e)

% initialization
[~,n] = size(A);
% x = zeros(n,rnk);
r = y;          % residual
Nr = norm(r,'fro'); % magnitude of residual
s = min(n,2*k); % 2k largest entries
T = [];         % support set
i=1;            % iteration counter
elist = zeros(20,1);

% iteration & update
while Nr>e && i<=20 % if possible, solve the problem within tolerance; otherwise stop ASAP
    H = PrincipleSupport(r,A,s);
    U = union(T,H);             % higher efficiency with mergesort or binary tree
    u = sparsesvd(A,y,U,rnk);   % least squares solutions
    T = PrincipleSupport2(u,k); % support set
    x = zeros(n,rnk);
    x(T,:) = u(T,:);            % approximation
    r = y-A*x;                  % residual
    Nr = norm(r,'fro');
    elist(i) = Nr;
    i = i+1;                    % iteration counter
end

if i>20
    while Nr>e && mean(elist(1:10))>mean(elist(11:20))
            H = PrincipleSupport(r,A,s);
            U = union(T,H);
            u = sparsesvd(A,y,U,rnk);
            T = PrincipleSupport2(u,k);
            x = zeros(n,rnk);
            x(T,:) = u(T,:);
            r = y-A*x;
            Nr = norm(r,'fro');
            elist = [elist(2:20);Nr];
    end
end