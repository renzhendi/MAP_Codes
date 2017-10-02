% This script is designed to plot the observed phase transitions of a
% selected algorithm. See paper 3.1.
%
% Modify the argument of addpath if necessary

clear;
addpath('C:/Users/Œ‚ﬁ»ïF/Documents/MATLAB/MAP-499/FinalCodes/Data_rho');
tic % timing

% *************
% * VARIABLES *
% *************

alg_name = 'RART'; %'RT'; %'RAOMP';
rnk_base = 4;
rnk_list = [5 10 20 40];
n = 1024;
plotSave = 0; % 0 display only; 1 save plots

% ******************
% * INITIALIZATION *
% ******************

dL = 2*length(rnk_list); % double of the length of the rnk_list
plots = zeros(1, dL);
legends = cell(1, dL);
colors = 'gkrb';
lines = {':','-','--'};
figure

% **********************
% * LOADING & PLOTTING *
% **********************

rho_base_struct = load(sprintf('Rho50_%s_n%d_r%d.mat',alg_name, n, rnk_base));
rho_base = [rho_base_struct.rho50];
xunit = 1/length(rho_base);

for i = 1:dL/2
    rnk = rnk_list(i);
    load(sprintf('Rho50_%s_n%d_r%d.mat',alg_name, n, rnk));
    plots(2*i-1) = plot(xunit:xunit:1, rho50, [colors(mod(i, length(colors))+1), lines{2}], 'LineWidth', 2);
    legends{2*i-1} = sprintf('Obs@rank=%d', rnk);
    hold on
    rho_p = Rho_Model(rho_base, rnk_base, rnk, n, n);
    plots(2*i) = plot(xunit:xunit:1, rho_p, [colors(mod(i, length(colors))+1), lines{1}], 'LineWidth', 2);
    legends{2*i} = sprintf('Pred@rank=%d', rnk);
    hold on
end

title(sprintf('50%% Success Predictions for %s at n=%d from rnk=%d', alg_name, n, rnk_base))
set(gca,'YDir','normal')        % invert the y axis direction
axis([0 1 0 1])                 % fix the scale of the axes
xlabel('\delta=m/n')            % label the horizontal axis
ylabel('\rho=k/m')              % label the vertical axis
legend(plots, legends);
if plotSave
    print(sprintf('PT_%s_%d.png', alg_name, n),'-dpng');
end

display(sprintf('Total testing time was %0.2f seconds.',toc));