clear

%% Tryb:

tryb = 'dmc';
% tryb = 'pomiar';
 pomiar_zaklocen = 1;


%% Parametry do ustawiania

Yzad = 35; 
Z1 = 30;
Z2 = 10;


% DMC
D = 290;      % horyzont dynamiki
Dz = 290;     % horyzont zakłóceń

N = 290;      % horyzont predykcji
Nu = 80;     % horyzont sterowania

lambda = 0.2;



%% Parametry stałe:


n = 1000;
start = 10;



T = 1;
k = 0;


% Punkt Pracy
Upp = 27;
Ypp = 28.4;
Zpp = 0;

PP = [Upp, Ypp, Zpp];
%     u,    y,   z


% Ograniczenia, inicjalizacja i wartość zadana:
Umin = 0;   Umax = 100;
Ymin = 0;   Ymax = 100;

delta_u_max = 50;

u(1:n) = 0;
% y(1:n) = 0;
z(1:n) = 0;

u(1:start) = Upp;
yzad(1:start) = Ypp;  yzad(start+1:n) = Yzad;
y(1:start) = Ypp;


% Wczytywanie
% S = load("s_obiekt_i_zaklocenia.mat");
% s = S.s_obiekt;
% sz = S.s_zaklocen;
S = load("pomiary/obiektmod.mat");
s = S.ymod;
sz = S.y_mod_zak;
clear S;
len = size(s, 1);





%% Pomiar

if strcmp(tryb, 'pomiar')
    k = 0;
    Z = 0;
    while(1)
    k = k+1
    y(k) = obiekt12(50, 27);
    stairs(y);
    drawnow 
    end

end




%% Regulator DMC

if strcmp(tryb, 'dmc')

    [Mp, Mzp, K] = dmc_offline(s, sz, D, Dz, N, Nu, lambda);

    k = 10;

    while(1)  % na rzeczywistym obiekcie

        k = k + 1

%         y(k) = obiekt12(u(k-1), 0);

        if k>D+start+Dz
            z(k:n)=Z2;
            y(k) = obiekt12(u(k-1), Z2);
            
        elseif k > D+start

            z(k:n) = Z1;
            % gdy chcemy sprawdzać bez pomiaru zakłóceń to wektor z musi być 0

            y(k) = obiekt12(u(k-1), Z1);
        else
            
          y(k) = obiekt12(u(k-1), 0);
        end

        du = regulacjaDMC(k, u, y, yzad, z, D, Dz, N, K, Mp, Mzp);
        
        if(~pomiar_zaklocen)
            du = regulacjaDMC(k, u, y, yzad, zeros(1,n), D, Dz, N, K, Mp, Mzp);
        end
        
        if du > delta_u_max
            du = delta_u_max;
        elseif du < (-1)*delta_u_max
            du =  -delta_u_max;
        end

        u(k) = u(k-1) + du;


        

        subplot(3, 1, 1)
        stairs(y); hold on; grid on;
        stairs(yzad); 
        hold off;
        drawnow

        subplot(3, 1, 2)
        stairs(u); grid on;
        drawnow

        subplot(3, 1, 3)
        stairs(z); grid on;
        drawnow


    end

end




%% błąd i wykresy

% ek = (y-yzad);
% E = ek*ek';



%% 
function [Mp, Mzp, K] = dmc_offline(s, sz, D, Dz, N, Nu, lambda)

    % macierz M
    M = zeros(N, Nu);
    for c = 1:Nu % kolumny
        for r = 1:N % wiersze

            if (r-c+1) <= 0
                M(r, c) = 0;
            elseif (r-c+1) > D
                M(r, c) = s(D);
            else
                M(r, c) = s(r-c+1);
            end

        end
    end

    % macierz Mp
    Mp = zeros(N, D-1);
    for c = 1:D-1 % kolumny
        for r = 1:N % wiersze

            if r+c > D
%                 s(c+r) = s(D);
                scr = s(D);
            else
                scr = s(c+r);
            end
            if c > D
%                 s(c) = s(D);
                sc = s(D);
            else
                sc = s(c);
            end

            Mp(r, c) = scr - sc;

        end
    end

    % Macierz Mzp
    Mzp2 = zeros(N, Dz-1);
    Mzp_kol1 = ones(N, 1);
    for c = 1:Dz-1 % kolumny
        for r = 1:N % wiersze

            if r+c > Dz
%                 sz(c+r) = sz(Dz);
                szcr = sz(Dz);
            else
                szcr = sz(c+r);
            end
            if c > Dz
%                 sz(c) = sz(Dz);
                szc = sz(Dz);
            else
                szc = sz(c);
            end
            Mzp2(r, c) = szcr - szc;


            if r > Dz
                Mzp_kol1(r) = sz(Dz);
            else
                Mzp_kol1(r) = sz(r);
            end

        end
    end

    Mzp = [Mzp_kol1, Mzp2];


    % wektor K
    I = eye(Nu);
    K = ((M'*M + lambda*I)^(-1))*M';


end
