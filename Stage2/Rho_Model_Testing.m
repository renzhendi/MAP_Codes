% This testing suite makes predictions of the 50%succ curve based on our
% 2017 model. It outputs an Excel form containing the base and predicted n
% and r values and the ratio of the true rho over the predicted rho.
%
% Modify the argument of addpath if necessary

clear;
addpath('C:/Users/���ȕF/Documents/MATLAB/MAP-499/FinalCodes/Data_rho');
tic % timing

% *************
% * VARIABLES *
% *************

alg_name = 'RART'; %'RAOMP'
r1_list = [2 4 5 8 10 16 20 32 40 64]; % base rank list
r2_list = [2 4 5 8 10 16 20 32 40 64]; % predicted rank list
n1_list = [512 1024 2048 4096];
n2_list = [512 1024 2048 4096];
varDelta = 1;                          % 0 \alpha ~ f(n1,r1,n2,r2); 1 \alpha ~ g(n1,r1,n2,r2,delta)
plotDisp = 1;                          % 0 no plots; 1 display plots
plotSave = 0;                          % 0 display only; 1 save plots
matSave = 0;                           % 0 compute only; 1 save the result matrix

% ******************
% * INITIALIZATION *
% ******************

if varDelta
    modelMAT = zeros(35000, 6);
else
    modelMAT = zeros(700, 5);
end
deltas = 0.02:0.02:1;
deltaLength = length(deltas);
counter = 1;

% *********************
% * MAIN TESTING LOOP *
% *********************

for i = 1:length(n1_list)
    n1 = n1_list(i);
    for j = i:length(n2_list)
        n2 = n2_list(j);
        for k = 1:length(r1_list)
            r1 = r1_list(k);
            for l = k:length(r2_list)
                r2 = r2_list(l);
                load(sprintf('Rho50_%s_n%d_r%d.mat', alg_name, n1, r1));
                rho_p = Rho_Model(rho50, r1, r2, n1, n2);
                load(sprintf('Rho50_%s_n%d_r%d.mat', alg_name, n2, r2));
                if varDelta
                    ratios = rho50./rho_p;
                    display(sprintf('(%d, %d)->(%d, %d): (delta, alpha)=', n1, r1, n2, r2));
                    displayMAT = [deltas; ratios]'
                    modelMAT(counter:counter+deltaLength-1,1) = n1;
                    modelMAT(counter:counter+deltaLength-1,2) = r1;
                    modelMAT(counter:counter+deltaLength-1,3) = n2;
                    modelMAT(counter:counter+deltaLength-1,4) = r2;
                    modelMAT(counter:counter+deltaLength-1,5:6) = displayMAT;
                    counter = counter+deltaLength;
                    if plotDisp
                        Rho_Model_Drawing(counter, alg_name, rho50, rho_p, median(ratios), r1, r2, n1, n2, plotSave);
                    end
                else
                    ratio = median(rho50./rho_p);
                    display(sprintf('(%d, %d)->(%d, %d): alpha=%0.4f', n1, r1, n2, r2, ratio));
                    modelMAT(counter,:) = [n1, r1, n2, r2, ratio];
                    counter = counter+1;
                    if plotDisp
                        Rho_Model_Drawing(counter, alg_name, rho50, rho_p, ratio, r1, r2, n1, n2, plotSave);
                    end
                end
            end
        end
    end
end

if matSave
    xlswrite('nrRatioModelMAT(raw).xlsx',modelMAT(1:counter-1,:));
end

display(sprintf('Total testing time was %0.2f seconds.',toc));