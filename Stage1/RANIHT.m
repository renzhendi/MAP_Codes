% RANIHT
function T = RANIHT(A,y,k,rnk,e)

% initialization
[~,n] = size(A);
x = zeros(n,rnk);
r = orth(y);    % residual
Nr = norm(r,'fro');   % magnitude of residual
T = [];         % support set
i = 1;          % iteration counter

% iteration & update
while Nr>e && i<=n/2 % if possible, solve the problem within tolerance; otherwise stop ASAP
    diff = A'*r;
    w = norm(diff(T,:),'fro')/norm(A(:,T)*diff(T,:),'fro');
    approx = x+w*diff;
    T = PrincipleSupport2(approx,k);
    x = zeros(n,rnk);
    x(T,:) = approx(T,:);      % approximation
    r = orth(y-A*x);           % residual
    %w = norm(diff(T,:),'fro')/norm(A(:,T)*diff(T,:),'fro');
    Nr = norm(r,'fro');
    i = i+1;                   % iteration counter
end