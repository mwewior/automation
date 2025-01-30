
dane = 'zad2_pomiary.mat';

if strcmp(dane, 'zad2_pomiary.mat')
% load(dane);
figure
title('Odpowiedzi skokowe dla zmian sygnału sterującego')
stairs(z2_27_40); hold on; stairs(z2_27_35); hold on; stairs(z2_27_20);
grid on;
legend('u = 40', 'u = 35', 'u = 20');
legend('Location','southeast');
% matlab2tikz('tikz/labodpskokowa.tex');

elseif strcmp(dane, 'pomiary_z1.mat')
load('zad2_pomiary.mat');
figure
title('Pomiar temperatury dla punktu pracy u = 27')
stairs(pomiary_z1);
grid on;
xlabel('k'); ylabel('temperatura')
% matlab2tikz('tikz/labodpskokowa.tex');


end
