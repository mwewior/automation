clear;
%% DANE zadanie 1:
data = importdata("danestat43.txt");

%% A
u = data(:,1);
uucz = u(1:2:end);
uwer=u(2:2:end);

y = data(:,2);
yucz = y(1:2:end);
ywer=y(2:2:end);

sz = size(u, 1)/2;

% wykres
dane = plot(u, y, 'o');
% dane = plot(Uucz, Yucz, 'o')
% dane = plot(Uwer, Ywer, 'o')
% ylabel("y", 'Rotation', pi/2);
% xlabel("u")
% hold on;
% grid on;


%% B

Mucz = [uucz, ones(sz, 1)];
Mwer = [uwer, ones(sz, 1)];
w = Mucz\yucz;
a1 = w(1); a0 = w(2);
Ymoducz = Mucz * w;
Ymodwer = Mwer * w;
Eucz = (Ymoducz - yucz)' * (Ymoducz - yucz);
Ewer = (Ymodwer - ywer)' * (Ymodwer - ywer);

% wykres
% wykd = plot(uucz, yucz, 'o' );
% hold on;
% grid on;
% mod = plot(uucz, Ymoducz, 'o', Color='red');
% hold on;
% legend([wykd, mod], 'dane uczące', 'wyjście modelu', 'location', 'SouthEast');
% 
% x = (-1:1);
% plot(x, a0 + a1*x)

%% C

N = 7; % stopień wielomianu
Mzeros = zeros(sz, N+1);
Mu = Mzeros;
Mu(:,1) = ones(sz, 1); Mw(:,1) = ones(sz, 1);
Mu(:,2) = uucz; Mw(:,2) = uwer;
for n=2:N
    Mu(:,n+1) = uucz.^n;
    Mw(:,n+1) = uwer.^n;
end

wpoly = Mu\yucz;

YmodPolyucz = Mu * wpoly;
YmodPolywer = Mw * wpoly;

Eu = (YmodPolyucz - yucz)' * (YmodPolyucz - yucz);
Ew = (YmodPolywer - ywer)' * (YmodPolywer - ywer);

% wykres
%uczące:
% wykd = plot(uucz, yucz, 'o' );
% hold on;
% grid on;
% mod = plot(uucz, YmodPolyucz, 'o', Color='red');
% hold on;
% title(strcat('Błąd=', string(Eu)));
% legend([wykd, mod], 'dane uczące', 'wyjście modelu', 'location', 'SouthEast');
%weryfikujące:
% wykd = plot(uwer, ywer, 'o' );
% hold on;
% grid on;
% mod = plot(uwer, YmodPolywer, 'o', Color='red');
% hold on;
% title(strcat('Błąd=', string(Ew)));
% legend([wykd, mod], 'dane weryfikujace', 'wyjście modelu', 'location', 'SouthEast');




