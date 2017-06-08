% This testing suite makes predictions of the 50%succ curve based on our
% 2017 model. It outputs an Excel form containing the base and predicted n
% and r values and the ratio of the true rho over the predicted rho.
%
% Modify the argument of addpath if necessary

clear;
addpath('C:/Users/ÎâÞÈ•F/Documents/MATLAB/MAP-499/FinalCodes/data2017');
tic % timing

alg_name = 'RART';
r1_list = [5 8 10 16 20 24 32 40 48 56 64]; % base rank list
r2_list = [5 8 10 16 20 24 32 40 48 56 64]; % predicted rank list
n1_list = [512 1024 2048 4096];
n2_list = [512 1024 2048 4096];
modelMAT = zeros(1000, 5);
counter = 1;

for i = 1:length(n1_list)
    n1 = n1_list(i);
    for k = i:length(n2_list)
        n2 = n2_list(k);
        for j = 1:length(r1_list)
            r1 = r1_list(j);
            for l = j:length(r2_list)
                r2 = r2_list(l);
                load(sprintf('Row50_%s_n%d_r%d.mat',alg_name,n1,r1));
                rho_p = Rho_Model(rho50, r1, r2, n1, n2);
                load(sprintf('Row50_%s_n%d_r%d.mat',alg_name,n2,r2));
                ratio = median(rho50./rho_p);
                display(sprintf('(%d, %d)->(%d, %d): rho/rhoHAT=%0.4f', n1, r1, n2, r2, ratio));
                modelMAT(counter,:) = [n1, r1, n2, r2, ratio];
                counter = counter+1;
                % Rho_Drawing(counter, alg_name, rho50, rho_p, ratio, r1, r2, n1, n2);
            end
        end
    end
end

xlswrite('nrRatioModelMAT(raw).xlsx',modelMAT(1:counter-1,:));
sprintf('Total testing time was %0.2f seconds.',toc);