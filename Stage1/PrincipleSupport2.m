function [T,val] = PrincipleSupport2(w,k)
% PrincipalSupport(w,k) takes a vector w and returns the index set T of the
% k rows of w with largest magnitude l2 norm.  The optional second output argument, val, is
% the value of the of the kth largest row l2 norm in w.

% If w is a matrix, find the squared row l2 norms;
% otherwise take the absolute values.
if size(w,1)>1
  z=sum(w.*w,2);
else
  z=abs(w);
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
