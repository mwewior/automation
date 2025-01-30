clear
finish = 300;

%{
load("pomiary_dmc/dmc_z0_lambda1_hor290_Nu80.mat");
yzad(1:start) = y(11);
y(1:start) = y(11);
u(1:start) = u(11);
    f = figure;
    subplot(2, 1, 2);
    stairs(u(1:finish));
    xlabel('k');
    ylim([0 68]);
    legend('u', Location='southeast');
    
    subplot(2, 1, 1);
    stairs(y(1:finish));
    hold on;
    stairs(yzad(1:finish));
    xlabel('k');
    hold on;
    ylim([27 Yzad+1]);
    legend('y', 'y_z_a_d', Location='southeast');
    title("Brak zakłóceń, lambda=1");
    exportgraphics(f, "rysunki/dmc_z0_lambda1_hor290_Nu80.png");
%}


%{

    load("pomiary_dmc/dmc_z0_lambda2_hor290_Nu80.mat");
    yzad(1:10) = y(11);
    y(1:10) = y(11);
    u(1:10) = u(11);

    f = figure;
    subplot(2, 1, 2);
    stairs(u(1:finish));
    xlabel('k');
    ylim([u(1)-1 61]);
    legend('u', Location='southeast');
    
    
    subplot(2, 1, 1);
    stairs(y(1:finish));
    hold on;
    stairs(yzad(1:finish));
    xlabel('k');
    hold on;
    legend('y', 'y_z_a_d', Location='southeast');
    ylim([27 36]);
    title("Brak zakłóceń, lambda=2");
    exportgraphics(f, "rysunki/dmc_z0_lambda2_hor290_Nu80.png")

%}
%{
    load("pomiary_dmc/dmc_z0_lambda05_hor290_Nu80_popr.mat");
    yzad(1:start) = y(11);
    y(1:start) = y(11);
    u(1:start) = u(11);
    f = figure;
    subplot(2, 1, 2);
    stairs(u(1:finish));
    xlabel('k');
    legend('u', Location='southeast');
    
    subplot(2, 1, 1);
    stairs(y(1:finish));
    hold on;
    stairs(yzad(1:finish));
    xlabel('k');
    
    legend('y', 'y_z_a_d', Location='southeast');
    title("Brak zakłóceń, lambda=0,5");
    exportgraphics(f, "rysunki/dmc_z0_lambda05_hor290_Nu80_popr.png")

    %}

%{
    load("pomiary_dmc/dmc_z0_lambda05_hor290_Nu80.mat");
    yzad(1:start) = y(11);
    y(1:start) = y(11);
    u(1:start) = u(11);
    f = figure;
    subplot(2, 1, 2);
    stairs(u(1:finish));
    xlabel('k');
    legend('u', Location='southeast');
    
    subplot(2, 1, 1);
    stairs(y(1:finish));
    hold on;
    stairs(yzad(1:finish));
    xlabel('k');
    hold on;
    ylim([27, 36]);

    title("Brak zakłóceń, lambda=0,5");
    legend('y', 'y_z_a_d', Location='southeast');
    exportgraphics(f, "rysunki/dmc_z0_lambda05_hor290_Nu80.png")
%}
%
    load("pomiary_dmc/dmc_z1_lambda02_hor290_Nu80_popr_pomiarzakl.mat");
    yzad(349:366) = 30.5;
    f = figure;
    subplot(2, 1, 2);
    stairs(u(349:570));
    xlim([0 215]);
    xlabel('k');
    legend('u', Location='southeast');
    
    subplot(2, 1, 1);
    stairs(y(349:570));
    hold on;
    stairs(yzad(349:570));
    xlim([0 215]);
    xlabel('k');
    hold on;
    legend('y', 'y_z_a_d', 'z', Location='southeast');
    title("Z zakłóceniami i pomiarem zakłóceń, lambda=0,2");
    exportgraphics(f, "rysunki/dmc_z1_lambda02_hor290_Nu80_najgorszy.png")
   
%}

%{
    load("pomiary_dmc/dmc_z1_lambda02_hor290_Nu80.mat");
    yzad(1:start) = y(11);
    y(1:start) = y(11);
    u(1:start) = u(11);
    f = figure;
    subplot(2, 1, 2);
    stairs(u(1:600));
    xlabel('k');
    legend('u', Location='southeast');
    
    subplot(2, 1, 1);
    stairs(y(1:590));
    hold on;
    stairs(yzad(1:590));
    xlabel('k');
    xlim([0 590]);
    hold on;
    % stairs(z(1:590));
    legend('y', 'y_z_a_d', 'z', Location='southeast');
    title("Z zakłóceniami, lambda=0,2");
    exportgraphics(f, "rysunki/dmc_z1_lambda02_hor290_Nu80.png")

%}




