% This script converts the 250*50-matrix representation of the 50%succ
% curve into a row vector containing the expected rho value at each delta.
%
% Modify the argument of addpath if necessary

clear;
addpath('C:/Users/Œ‚ﬁ»ïF/Documents/MATLAB/MAP-499/FinalCodes/Data_NME50');

% *************
% * VARIABLES *
% *************

alg_name = 'RAPrincipalSupport';
alg_name_abbr = 'RART';
n_list = [512 1024 2048];
r_list = [1 2 4 5 8 10 16 20 32 40 64];
rho50 = zeros(1, 50); % length of delta

% *************
% * MAIN LOOP *
% *************
for i = 1:length(n_list)
    n = n_list(i);
    for j = 1:length(r_list)
        r = r_list(j);
        load(sprintf('NME50_%s_n%d_r%d.mat', alg_name, n, r));
        for l = 1:50
            ind = find(NME50(:,l));
            rho50(l) = mean(ind)/250;
        end
        save(sprintf('Rho50_%s_n%d_r%d.mat', alg_name_abbr, n, r),'rho50');
    end
end