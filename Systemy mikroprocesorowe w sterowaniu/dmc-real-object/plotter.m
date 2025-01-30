load('jshit.mat');

dmc_fig = figure;

subplot(2,1,1);
stairs(y(50:end)); hold on;
stairs(yzad(50:end), '--'); grid on;

subplot(2,1,2);
stairs(u(50:end));
grid on;