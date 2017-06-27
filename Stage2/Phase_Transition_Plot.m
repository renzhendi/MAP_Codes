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

alg_name = 'RART'; % RAOMP
rnk_list = [1 4 16 64];
n = 1024;
plotSave = 0; % 0 display only; 1 save plots

% ******************
% * INITIALIZATION *
% ******************

L = length(rnk_list); % the length of the rnk_list
plots = zeros(1, L);
legends = cell(1, L);
colors = 'ykrb';
lines = {':','-','--'};
figure

% **********************
% * LOADING & PLOTTING *
% **********************

for i = 1:length(rnk_list)
    rnk = rnk_list(i);
    load(sprintf('Rho50_%s_n%d_r%d.mat',alg_name, n, rnk));
    xunit = 1/length(rho50);
    plots(i) = plot(xunit:xunit:1, rho50, [colors(mod(i, length(colors))+1), lines{2}], 'LineWidth', 2);
    legends{i} = sprintf('rank=%d', rnk);
    hold on
end

title(sprintf('50%% Success for %s at n=%d', alg_name, n))
set(gca,'YDir','normal')        % invert the y axis direction
axis([0 1 0 1])                 % fix the scale of the axes
xlabel('\delta=m/n')            % label the horizontal axis
ylabel('\rho=k/m')              % label the vertical axis
legend(plots, legends);
if plotSave
    print(sprintf('PT_%s_%d.png', alg_name, n),'-dpng');
end

display(sprintf('Total testing time was %0.2f seconds.',toc));