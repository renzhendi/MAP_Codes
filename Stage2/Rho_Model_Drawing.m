% This function implements the plotting step in the Row_Model_Testing.
%
% index: title of the plot in MATLAB
% alg_name: name of the algorithm
% row: the true values of Rows
% row_hat: the predicted values of Rows
% ratio: row./row_hat
% r1: base rank
% r2: predicted rank
% n1: matrix size at r1
% n2: matrix size at r2
% save: 0 display only; 1 save plots

function figTitle = Rho_Model_Drawing(index, alg_name, rho, rho_hat, ratio, r1, r2, n1, n2, save)

figTitle = index;
figure(figTitle)
xunit = 1/length(rho);
xaxis = xunit:xunit:1;
plot(xaxis, rho, 'k', 'LineWidth', 2);
hold on
plot(xaxis, rho_hat, 'r--', 'LineWidth', 2);
hold off
title([sprintf('50%% Success for %s (%d, %d)->(%d, %d), ', alg_name, n1, r1, n2, r2), '\alpha', sprintf('=%0.4f', ratio)])
set(gca,'YDir','normal')        % invert the y axis direction
axis([0 1 0 1])                 % fix the scale of the axes
xlabel('\delta=m/n')            % label the horizontal axis
ylabel('\rho=k/m')              % label the vertical axis
legend('Observed','Predicted');
if save
    print(sprintf('Model_%s_n%dr%d_n%dr%d.png', alg_name, n1, r1, n2, r2),'-dpng');
end