

load pomiary\zad2_zak_10_Goebbels.mat
figure;
box on
hold on
% y(210: 299) = y(209);
stairs(y(1:299))
load pomiary\zad2_zak25.mat
hold on
stairs(y(1:299))
load pomiary\zad2_zak-20.mat
hold on
stairs(y(1:299))
legendLogs = {'Z = 10', 'Z = 25', 'Z = -25'};
legend(legendLogs, Location='northwest')
print('wykresy_png\odpowiedzi_skokowe.png', '-dpng', '-r400')
