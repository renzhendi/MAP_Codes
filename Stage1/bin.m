function  [rho, success]  = bin(rnk,delta,distr,ortho,n,target,rho_mesh,high,low,numtests)
% This is a binary search algorithm that looks for a value of rho such that
% all values of rho less than or equal to rho in the mesh yield a
% probability of success of at least the target percentage.

% p is the rank of the signal
% delta is the value of delta these tests are measured at.
% numtests is the number of tests from which the average of rho will be
%   measured. Larger number of tests should coverge to the correct rho in a
%   given mesh.
% ortho is the type of algorithm being tested:
%       default: RA-NIHT
%       ortho = 1: PrincipleSupport
%       ortho = 2: RA-PrincipleSupport
%       ortho = 3: SOMP
%       ortho = 4: RA-SOMP
%       ortho = 5: SCoSaMP
%       ortho = 6: RA-SCoSaMP
%       ortho = 7: NIHT
% n is the number of rows of the signal. It is recommended that n >= 256
%   for Row Thresholding.
% target is probability of success that is desired for a specific value of
%   rho.
% rho_mesh is the step size for the values of rho. Smaller step sizes
%   should yield more accurate results.
% high is an upper bound for rho. It must be in the range [0,1].
% low is a lower bound for rho. It must be in the range [0,1].
% 	Also, it must be the case that high >= low.
% 	When in doubt let high = 1 and low = 0.
%   However, narrowing the bounds should speed up the algorithm.

m = ceil(delta*n);
lo = floor(low/rho_mesh);   % lo = 1
hi = floor(high/rho_mesh);  % hi = floor(1/rho_scale)

% This sets the L2 error we are willing to accept.
success_tol = .001;
bincount = 0;

while hi > lo
    mid = floor((hi+lo)/2); % mid = floor((hi+lo)/2
    rho = mid*rho_mesh;     % rho=mid+rho_scale
    k = ceil(rho*m);
    success = 0;
    
    for num=1:numtests
        [y, A, x_input] = createRowProblem(k,m,n,rnk,distr);
        T_input = find(sum(abs(x_input),2));
        switch ortho
            case 1
                T=PrincipleSupport(y,A,k);
            case 2
                T=RAPrincipleSupport(y,A,k);
            case 3
                T=OmpSupport(y,A,k);
            case 4
                T=RAOmpSupport(y,A,k);
            case 5
                T=SpSCoSaMP(A,y,k,min(k,rnk),success_tol);
            case 6
                T=RASCoSaMP(A,y,k,min(k,rnk),success_tol);
            case 7
                T=NIHT(A,y,k,min(k,rnk),success_tol);
            otherwise
                T=RANIHT(A,y,k,min(k,rnk),success_tol);
        end % end ortho if
        success = success + (length(intersect(T,T_input))==k);
    end % end numtests for loop
    
    success = success/numtests;
    % display(sprintf('Delta = %g Rho = %g Success = %g Count = %d', delta, rho, success, bincount))
    bincount = bincount + 1;
    
    if abs(success - target) <=0.03
        break
    elseif success < target
        hi = mid-1;
    else
        lo = mid+1; % The +1 will ensure that the while loop ends.
        %This results is the binary search selecting points in the mesh
        %such that every point below them has at least a target% success
        %rate. For an algorithm that yields every point with a target%
        %success rate change lo = mid+1 to lo = mid and hi = mid to hi =
        %mid-1.
    end % end if
end % end while
end % end function