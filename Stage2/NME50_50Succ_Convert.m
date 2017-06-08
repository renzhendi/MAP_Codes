% This script converts the 250*50-matrix representation of the 50%succ
% curve into a row vector containing the expected rho value at each delta.
%
% Modify the argument of addpath if necessary

clear;
addpath('C:/Users/LENOVO_PC/Documents/MATLAB/MAP-499/OrthoThresholding/PStesting/NME50');

% *************
% * VARIABLES *
% *************

alg_name = 'RAPrincipalSupport';
alg_name_abbr = 'RART';
n_list = [512 1024 2048 4096];
r_list = [5 8 10 16 20 24 32 40 48 56 64];
row50 = zeros(1, 50); % length of delta

% *************
% * MAIN LOOP *
% *************
for i = 1:length(n_list)
    n = n_list(i);
    for j = 1:length(r_list)
        r = r_list(j);
        load(sprintf('NME50_%s_n%d_r%d.mat', alg_name, n, r));
        for l = 1:50
            ind = find(results50(:,l));
            row50(l) = mean(ind)/250;
        end
        save(sprintf('Row50_%s_n%d_r%d.mat', alg_name_abbr, n, r),'row50');
    end
end