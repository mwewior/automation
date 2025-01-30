clear;

x11 = -1:0.01:-0.7;
y1_1 = ones(size(x11, 2)); 

x12 = -0.7:0.01:-0.4;

a1 = -1 / 0.3;
b11 =  1 - a1*(-0.7);

y1_2 = a1*x12 + b11;

x13 = -0.4:0.01:1;
y1_3 = zeros(size(x13, 2)); 



y2_1 = zeros(size(x11, 2)); %x11 = -1:0.01:-0.7;

b12 = 1 + a1*(-0.4);
y2_2 = -a1*x12 + b12;

x23 = -0.4:0.01:-0.2;
y2_3 = ones(size(x23, 2)); 


x24 = -0.2:0.01:0.2;

% a2 = -1 / 0.4;
% b21 = 1 + a2*(0.2);

X = ((10/4)*(x24+0.2));
bell = 2.^( X.^3 ) - 1;
y2_4 = -bell+1;



x25 = 0.2:0.01:1;
y2_5 = zeros(size(x25, 2)); 



x31 = -1:0.01:-0.2;
y3_1 = zeros(size(x31, 2)); 

y3_2 = bell;

x33 = 0.2:0.01:1;
y3_3 = ones(size(x33, 2));


figure
plot(x11, y1_1, Color='r'); hold on;
plot(x12, y1_2, Color='r'); hold on;
plot(x13, y1_3, Color='r'); hold on;

plot(x11, y2_1, Color='g'); hold on;
plot(x12, y2_2, color='g'); hold on;
plot(x23, y2_3, Color='g'); hold on;
plot(x24, y2_4, Color='g'); hold on;
plot(x25, y2_5, Color='g'); hold on;

plot(x31, y3_1, Color='b'); hold on;
plot(x24, y3_2, Color='b'); hold on;
plot(x33, y3_3, Color='b'); hold on; grid on;
 
% x_audio =   [125 250 500 1000 2000 4000 6000 8000];
% y_lewe  =   [ 5   0   5   0    0    0    5    5];
% y_prawe =   [ 5   0   0   5   -5    0    0    5];
% 
% audiogram = figure;
% 
% ax = gca();
% plot(ax, x_audio,y_prawe,'--ok', 'Color', '0 0.447 0.741'); hold on;
% plot(ax, x_audio,y_lewe,'--xk', 'Color', 'r'); hold on; %'0.85 0.325 0.098');
% xticks = [125 250 500 1000 2000 4000 6000 8000];
% set(ax, 'XScale','log','XLim',[100,10000],...
%     'XTick',xticks,'XMinorTick','off')
% ylim([-10, 80]);
% ax.YDir = 'reverse';
% grid(ax,'on')
% ax.MinorGridLineStyle = 'none';
% xlabel('frequency Hz');
% ylabel('Hearing Level dB');
% legend('Prawe', 'Lewe', Location='southeast')