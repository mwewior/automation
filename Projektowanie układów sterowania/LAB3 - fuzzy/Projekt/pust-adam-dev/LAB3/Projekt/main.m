clear

% tryb = 'punktpracy';
% tryb = 'odpskokowa';
tryb = 'wzmocnienie';
% tryb = 'skokdmc';
% tryb = 'dmc';
% tryb = 'pomiar';

% zaklocenia = 'bez';
% zaklocenia = 'skok';
% zaklocenia = 'sin';
% zaklocenia = 'szum';

pomiar_zakl = 1;

dz = 65; %81; %70;
d = 213; %200;



T = 0.5;
k = 0;

PP = [0, 0, 0];
%     u, y, z

% n = 1000;
n = 400;
start = 9;

u(1:n) = 0;
y(1:n) = 0;
z(1:n) = 0; zpom(1:n) = 0;


%% Punkt Pracy:

for k = start:n
    y(k) = symulacja_obiektu12y_p3(u(k-5), u(k-6), y(k-1), y(k-2));
end

if strcmp(tryb, 'punktpracy')
    fpp = figure;
    stairs(u); hold on;
    stairs(z); grid on;
    stairs(y); hold on;
    legendLogs = {'sterowanie', 'zaklocenia', 'wyjscie'};
    legend(legendLogs, Location='southeast');
    exportgraphics(fpp, 'punktpracy.pdf');
end


%% Odpowiedź Skokowa:
if strcmp(tryb, 'odpskokowa')

    Uskok = {-1.5, 0.25, 2};

    fww = figure;
    for iter_u = 1:size(Uskok(:))

        u(start:n) = Uskok{iter_u};

        for k = start:n
            y(k) = symulacja_obiektu12y_p3(u(k-5), u(k-6), y(k-1), y(k-2));
        end

        % wykresy

        subplot(2, 1, 1);
        ylabel('u', 'Rotation', pi/2);
        grid on;
        stairs(u); hold on;

        subplot(2, 1, 2);
        ylabel('y', 'Rotation', pi/2);
        grid on;
        stairs(y); hold on;

    end

    fzw = figure;

    for k = start:n
        y(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2));
    end

    % wykres

    subplot(2, 1, 1);
    ylabel('z', 'Rotation', pi/2);
    grid on;
    stairs(z); hold on;

    subplot(2, 1, 2);
    ylabel('y', 'Rotation', pi/2);
    grid on;
    stairs(y); hold on;

end



%% Wzmocnienie:
if strcmp(tryb, 'wzmocnienie')

    u(1:n) = 0;
    y(1:n) = 0;

    % wykres i wzmocnienie dla y(u):
    for temp_u = -1:0.05:1

        u(start:n) = temp_u;

        for k = start:n
            y(k) = symulacja_obiektu12y_p3(u(k-5), u(k-6), y(k-1), y(k-2));
        end
        i = round(temp_u*20 + 21);
        Y(i) = y(n);
        U(i) = u(n);

        Ku(i) = (y(n)-y(1))/(u(n));

    end
    
    Ku(21) = 0;
    K1 = mean(Ku(1:18));
    K2 = mean(Ku(19:end));

    fku = figure;
    plot(U, Y); grid on;

end

%% Skok jednostkowy
if strcmp(tryb, 'skokdmc') || strcmp(tryb, 'dmc')

    start = 10;

    u(start:n) = 1;
    z(start:n) = 0;

    for k = start:n
        y(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2));
    end

    D = d;
    s = y(start:D+start)';

    if strcmp(tryb, 'skokdmc')
        figure;
        stairs(y); hold on;
        stairs(u, '--'); grid on;
        ylabel('y(u)', 'Rotation', pi/2);
    end


    u(start:n) = 0;
    z(start:n) = 1;

    for k=start:n
        y(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2));
    end

    Dz = dz;
    sz = y(start:Dz+start)';

    if strcmp(tryb, 'skokdmc')
        figure;
        stairs(y); hold on;
        stairs(z, '--'); grid on;
        ylabel('y(z)', 'Rotation', pi/2);
    end
    if strcmp(tryb, 'skokdmc')
        fs = figure;
        stairs(s); grid on;
        fsz = figure;
        stairs(sz); grid on;
    end
end




%% DMC


if strcmp(tryb, 'dmc')

    start = 10;
    ust = 150;

    u(1:n) = 0;
    y(1:n) = 0;
    z(1:n) = 0;

    yzad(start:n) = 1;


    % parametry - do nastawienia
    D = d;          % horyzont dynamiki sterownia       
    Dz = dz;        % horyzont dynamiki zakłóceń        
    N = 27;         % horyzont predykcji                 
    Nu = 10;        % horyzont sterowania
    lambda = 4;     % optymalna jakaś niska np 0.24


%     delta_u_max = 0.25;

    [Mp, Mzp, K] = dmc_offline(s, sz, D, Dz, N, Nu, lambda);

    if strcmp(zaklocenia, 'skok') || strcmp(zaklocenia, 'szum')
        z(ust:n) = 1;
    end

    


    k = start;
%      while(1)  % na rzeczywistym obiekcie
    while k < n % symulacja

        k = k + 1;


        if strcmp(zaklocenia, 'sin')
            A = 0.1; T = 40;
            if k>=ust
                z(k) = A*sin(2*pi * k / T + pi/2);
            end
        end

        y(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2));

        pomiar_zakl = 0;

        if pomiar_zakl == 0
            zpom = zeros(1,n);
        else
            if strcmp(zaklocenia, 'szum')
                A = 0.005;
                zpom(k) = z(k) + A*(randi(10) - randi(10));
            else
                zpom(k) = z(k);
            end
        end

        du = regulacjaDMC(k, u, y, yzad, z, zpom, D, Dz, N, K, Mp, Mzp);

        
        if exist('delta_u_max', 'var')
            if du > delta_u_max
                du = delta_u_max;
            elseif du < (-1)*delta_u_max
                du =  -delta_u_max;
            end
        end

        u(k) = u(k-1) + du;

        
    end

    ek = (y-yzad);
    E = ek*ek';

    fy = figure;
    stairs(y); hold on;
    stairs(yzad, '--'); grid on;
    legend('y', 'yzad', Location='southeast');

    fu = figure;
    stairs(u); hold on;
    stairs(z); hold on;
    stairs(zpom); grid on;
    legend('u', 'z', 'z_{mierzone}', Location='southeast');

end














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


