% This function implements the plotting step in the Row_Model_Testing.
%
% alg_name: name of the algorithm
% row: the true values of Rows
% row_hat: the predicted values of Rows
% ratio: row./row_hat
% r1: base rank
% r2: predicted rank
% n1: matrix size at r1
% n2: matrix size at r2

function figTitle = Rho_Drawing(index, alg_name, rho, rho_hat, ratio, r1, r2, n1, n2)

figTitle = index;
figure(figTitle)
plot(rho, 'b', 'LineWidth', 2);
hold on
plot(rho_hat, 'r--', 'LineWidth', 2);
hold off
title(sprintf('50%% Succ for %s, (%d, %d)->(%d, %d): rho/rhoHAT=%0.4f', alg_name, n1, r1, n2, r2, ratio))
set(gca,'YDir','normal')        % invert the y axis direction
axis([0 50 0 1])                % 50 pixels on the x axis
xlabel('\delta=m/n (index, total = 50 sample points)')    % label the horizontal axis
ylabel('\rho=k/m')              % label the vertical axis
% print(sprintf('%d.png',figTitle),'-dpng');