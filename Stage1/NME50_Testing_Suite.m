% This testing suite outputs 250*50 matrices storing the NMEs at the 50%
% succ curve for given algorithm, n, ranks, and distribution of x. Plots
% are also optional.
%
% It is designed to compute the NME50 at all ranks for one n-value at a
% time, so that users can run the data of different n-values on different
% computers simultaneously.
%
% Note that the definition of NME is the number of missed entries when the
% algorithm is failing.

% Ensure the random number generator is using clock seed
rng('shuffle');
tic

% *************
% * VARIABLES *
% *************

% default: RA-NIHT
% ortho = 1: PrincipleSupport
% ortho = 2: RA-PrincipleSupport
% ortho = 3: SOMP
% ortho = 4: RA-SOMP
% ortho = 5: SCoSaMP
% ortho = 6: RA-SCoSaMP
% ortho = 7: NIHT
ortho = 1;           % define which support selection technique to use
n = 512;             % perform your tests for n=512
rnk_list = [5 8 10 16 20 32 40 48 56 64]; % enter the ranks to be collected
distr = 1;           % distribution of x: 0 rand; 1 sign; 2 randn
plots = 0;           % 0 no plots; 1 save plots

% ******************
% * INITIALIZATION *
% ******************

numtests = 100;      % perform 100 tests per delta rho pair, and in bin
delta_scale = 0.02;  % create a list of values for delta = m/n
rho_scale = 0.004;   % create a list of values for rho = k/m
band = [0.47 0.53];  % percentage of success
success_tol = 0.001; % set the L2 error we are willing to accept
delta_list = delta_scale:delta_scale:1;
delta_total = length(delta_list);
rho_list = rho_scale:rho_scale:1;
rho_total = length(rho_list);
rho_min = 0;

switch ortho % Alg_name used for plots
    case 1
        alg_name = 'PrincipalSupport';
    case 2
        alg_name = 'RAPrincipalSupport';
    case 3
        alg_name = 'OmpSupport';
    case 4
        alg_name = 'RAOmpSupport';
    case 5
        alg_name = 'SCoSaMP';
    case 6
        alg_name = 'SpSCoSaMP';
    case 7
        alg_name = 'NIHT';
    otherwise
        alg_name = 'RANIHT';
end

% *********************
% * MAIN TESTING LOOP *
% *********************

for ppp = 1:length(rnk_list)
    rnk = rnk_list(ppp);
    results50 = zeros(rho_total, delta_total);
    
    for d = 1:delta_total
        delta = delta_list(d);
        m=ceil(delta*n);
        
        [rho_min,~] = bin(rnk, delta, distr, ortho, n, band(2), rho_scale, 1, rho_min-rho_scale, numtests);
        r_min = ceil(rho_min/rho_scale);
        
        NMEavg = 1; % ensure we start the tests, but can bail out when we are always failing
        successperc = band(2);
        r = r_min;
        
        while successperc > band(1) && r <= rho_total
            rho = rho_list(r);
            k = ceil(rho*m);
            NumMissedEntry = 0;
            successperc = 0; % initialized as a counter; will be turned into a percentage
            
            for t=1:numtests
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
                        T=SCoSaMP(A,y,k,min(k,rnk),success_tol);
                    case 6
                        T=SpSCoSaMP(A,y,k,min(k,rnk),success_tol);
                    case 7
                        T=NIHT(A,y,k,min(k,rnk),success_tol);
                    otherwise
                        T=RANIHT(A,y,k,min(k,rnk),success_tol);
                end % ends switch
                
                l = length(intersect(T,T_input));
                NumMissedEntry = NumMissedEntry + k - l;
                successperc = successperc + (l == k);
            end  % ends numtest loop
            
            % record the successes in a matrix and report the progress of the testing
            NMEavg = NumMissedEntry/(numtests-successperc);
            successperc = successperc/numtests;
            results50(r, d) = NMEavg;
            display(sprintf('Finished (delta, rho) = (%0.3f, %0.3f) @rnk=%d, succ=%0.2f, NME=%0.2f after %0.2f seconds.', delta, rho, rnk, successperc, NMEavg, toc));
            r = r + 1;
            
        end % ends rho_list loop
    end % ends delta_list loop
    
    save(sprintf('NME50_%s_n%d_r%d.mat',alg_name,n,rnk),'results50');
    
    % ************************************
    % * Make Plot to Display the Results *
    % ************************************
    
    if plots
        figure(rnk)
        hold off						% make sure to delete whatever is in the previous figure
        imagesc(delta_list,rho_list,results50); % plot the ratio of the results matrix as an image
        c = colorbar();					% display the color meanings in a color bar
        title(sprintf('NME50 for %s, n=%d, r=%d.', alg_name, n, rnk)) % put the title on the plot
        set(gca,'YDir','normal')        % invert the y axis direction
        set(c, 'XTick', 0:0.1:1)        % fix the range of the horizontal axis
        set(c, 'YTick', 0:0.1:1)        % fix the range of the vertical axis
        xlabel('\delta=m/n')			% label the horizontal axis
        ylabel('\rho=k/m')				% label the vertical axis
        caxis([0,20])                   % set up a constant color bar
        print(sprintf('NME50plot_%s_n%d_r%d.pdf',alg_name,n,rnk),'-dpdf') % save the image as a pdf file in the folder from which this script was executed
    end
end

sprintf('Total testing time was %0.2f seconds.',toc)