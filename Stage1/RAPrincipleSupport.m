function [T,val] = RAPrincipleSupport(y,A,k)
% RAPrincipalSupport(y,A,k) returns the index set T of the
% k largest row l2 norms of matrix A'*orth(y).  
% The optional second output argument, val, is
% the value of the of the kth largest row l2 norm in A'*orth(y).

% ******************
% This algorithm is no longer used in RARowThresholding
% but is usefule for just testing the principle support.
% ******************

% If w is a matrix, find the squared row l2 norms;
% otherwise take the absolute values.
if size(y,1)>1
  Q=orth(y);
  w=A'*Q;
  z=sum(w.*w,2);
else
  z=abs(A'*y);
end

% sort the magnitudes of w in descending order
% store the values in list and the indices in index
[list, index]=sort(z,'descend');

% create T as the index set of the k largest magnitudes, but sort the index
% set so they appear in order
T=sort(index(1:k));

% If there are two ouput arguments, the second should be the kth largest
% magnitude.  If there is only one output argument, do nothing.
if nargout>1
    val = list(k);
end
