% name = 'k1_1ti10td1.mat';
% name = 'jebane_gowno_wypierdalam_elo.mat';
% name = 'k042_ti50_td08.mat';
name = 'pid_tylko_przyrosty.mat';

ws = load(name);
y1 = ws.y1;
y2 = ws.y2;
y1zad = ws.yz1;
y2zad = ws.yz2;
u1 = ws.u1;
u2 = ws.u2;

fy = figure;
stairs(y1); hold on;
stairs(y2); hold on;
stairs(y1zad, '--'); hold on;
stairs(y2zad, '--'); hold on; grid on;

fu = figure;
stairs(u1); hold on;
stairs(u2); hold on; grid on;
