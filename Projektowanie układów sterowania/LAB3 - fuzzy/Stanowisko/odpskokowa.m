clear

n = 1000;

% przypisanie pomiarów do zmiennych przeliczanych
h20 = load("pomiary/od27do20.mat");
 pomiar20 = h20.y;
h30 = load("pomiary/od20do30.mat");
 pomiar30 = h30.y;
h40 = load("pomiary/od30do40.mat");
 pomiar40 = h40.y;
h50 = load("pomiary/od40do50.mat");
 pomiar50 = h50.y;
h60 = load("pomiary/od50do60.mat");
 pomiar60 = h60.y;
h70 = load("pomiary/od60do70.mat");
 pomiar70 = h70.y;
% TODO
h80 = load("od70do80v2.mat");
 pomiar80 = h80.y;

% opoznienie
Tp = 10;

for k = 1:399
    if k > Tp
        s20(k-10) = (pomiar20(k) - pomiar20(10))/(-7); %od 27
        s30(k-10) = (pomiar30(k) - pomiar30(10))/10; % od 20
%         dla s40 do 300. pomiar
%         s40(k-10) = (pomiar40(300) - pomiar40(10))/10; % od 30
         s50(k-10) = (pomiar50(k) - pomiar50(10))/10; % od 40
         s60(k-10) = (pomiar60(k) - pomiar60(10))/10; % od 50
         s70(k-10) = (pomiar70(k) - pomiar70(10))/10; % od 70
%          s80(k-10) = (pomiar80(470) - pomiar80(10))/10; % od 80
    end
end

for k = 1:300
    if k > Tp
         s40(k-10) = (pomiar40(k) - pomiar40(10))/10; % od 30
    end
end

for k = 1:700
    if k > Tp
         s80(k-10) = (pomiar80(k) - pomiar80(10))/10; % od 70
    end
end

k20 = s20(389) - s20(1);
char = zeros(6, 2);
char(1, 1) = 20;
char(1, 2) = pomiar20(399);
char(2, 1) = 30;
char(2, 2) = pomiar30(399);
char(3, 1) = 40;
char(3, 2) = pomiar40(302);
char(4, 1) = 50;
char(4, 2) = pomiar50(402);
char(5, 1) = 60;
char(5, 2) = pomiar60(466);
char(6, 1) = 70;
char(6, 2) = pomiar70(424);
char(7, 1) = 80;
char(7, 2) = pomiar80(700);

plot(char(:, 1), char(:, 2));

% save("s_nieliniowy");

figure
stairs(s20);
hold on;
stairs(s30);
hold on;
stairs(s40);
hold on;
stairs(s50);
hold on;
stairs(s60);
hold on;
stairs(s70);
hold on;
stairs(s80);
legend('s20', 's30', 's40', 's50', 's60', 's70', 's80');