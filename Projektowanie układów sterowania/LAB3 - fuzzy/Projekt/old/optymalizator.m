%% Optymalizacja nastawów DMC

% objective = @(x) DMC (x(1), x(2), x(3), x(4));

% lb = [10, 10, 5, 0];
% ub = [500, 500, 500, 1000];
% 
% nonlcon = [];
% 
% options = optimoptions('fmincon', 'Display', 'iter');
% [x_optimal, fval] = fmincon(objective, x_initial, [], [], [], [], lb, ub, nonlcon, options);
% 

% gaoptimset
% options = optimoptions('Generations', 100, 'PopulationSize', 50);
%     'intcon', 1);




objective = @(x) DMC (x(1), x(2), x(3), x(4), x(5));

x_initial = [200, 80, 200, 80, 10];
lb = [10, 10, 10, 1, 0];
ub = [240, 120, 240, 240, 100];

options = optimoptions('ga', 'MaxGenerations', 100, 'PopulationSize', 50, 'Display','iter');

% [x_optimal, fval] = ga(objective, 5, [], [], [], [], lb, ub, 1:5, options);
[x_optimal, fval] = ga(objective, 5, [], [], [], [], lb, ub, [], options);



function E = DMC(D, Dz, N, Nu, lambda)


    D = round(D);
    Dz = round(Dz);
    N = round(N);
    Nu = round(Nu);


    pomiar_zakl = 1;
    n = 1000;
    start = 10;
%     ust = 150;

    u(1:n) = 0;
    y(1:n) = 0;
    z(1:n) = 0;

    yzad(start:n) = 1;
    
    
    u(start:n) = 1;
    z(start:n) = 0;

    for k = start:n
        y(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2));
    end

    s = y(start:D+start)';

    u(start:n) = 0;
    z(start:n) = 1;

    for k=start:n
        y(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2));
    end

    sz = y(start:Dz+start)';

    k = start;
    while k < n
        k = k +1;

        y(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2));
    
        [Mp, Mzp, K] = dmc_offline(s, sz, D, Dz, N, Nu, lambda);

        if pomiar_zakl == 0
            zpom = zeros(1,n);
        else
            zpom = z;
        end
        
        du = regulacjaDMC(k, u, y, yzad, z, zpom, D, Dz, N, K, Mp, Mzp);
        
        u(k) = u(k-1) + du;

    end

    ek = (y-yzad);
    E = ek*ek';

    
disp(['D: ', num2str(D)]);
disp(['Dz: ', num2str(Dz)]);
disp(['N: ', num2str(N)]);
disp(['Nu: ', num2str(Nu)]);
disp(['lambda: ', num2str(lambda)]);
disp(['E: ', num2str(E)])
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

% %fmincon
% objective = @(x) DMC (x(1), x(2), x(3), x(4));
% x_initial = [130, 140, 10, 10];
% lb = [10, 10, 5, 0];
% ub = [500, 500, 500, 1000];
% 
% nonlcon = [];
% 
% options = optimoptions('fmincon', 'Display', 'iter');
% [x_optimal, fval] = fmincon(objective, x_initial, [], [], [], [], lb, ub, nonlcon, options);
% 
% 
% function E = DMC(D, N, Nu, lambda)
%     D = round(D);      % horyzont dynamiki
%     N = round(N);      % horyzont predykcji
%     Nu = round(Nu);      % horyzont sterowania
% 
%     Upp = 0.9;
%     Ypp = 3.5;
% 
%     n = 500;
% 
%     Umin = 0.7;
%     Umax = 1.1;
%     dumax = 0.01;
%     
%     kp = 12;
%     kk = N+D-1;
%     
%     % dane do odpowiedzi skokowej
%     y(1:kp-1) = Ypp;      % Ypp
%     u(1:kp-1) = Upp;      % Upp
%     u(kp:kk+kp) = 1;      % skok (kp => odpowiednik k=0)
%     
%     % ???????????????
%     yzad(1:n) = Ypp + 0.2;      % wartość zadana 
%     % ???????????????
%     
%     % odpowiedź skokowa
%     for k = kp : kk + kp
%         y(k) = symulacja_obiektu12y_p1(u(k-10), u(k-11), y(k-1), y(k-2));
%     end
%     s(1:kk) = (y(kp+1:end)-ones(1, kk)*Ypp)/(1-Upp);
%     
%     
%     % macierz M
%     M = zeros(N, Nu);
%     for i = 1 : Nu
%         M(i : N, i) = s(1 : (N - i + 1))';
%     end
%     
%     
%     % macierz Mp
%     Mp = zeros(N, D-1);
%     for i = 1 : N
%         for j = 1 : D-1
%             Mp(i, j) = s(i+j) - s(j);
%         end
%     end
%     
%     
%     % obliczam K
%     I = eye(Nu);
%     K = ((M'*M + lambda*I)^(-1))*M';
%     
%     
%     % oszczędna wersja DMC - parametry
%     Ke = 0;
%     for i = 1 : N
%         Ke = Ke + K(1, i);
%     end
%     ku = K(1, :) * Mp;
%     
%     
%     % symulacja
%     y(1:kp-1) = Ypp;
%     u(1:kp-1) = Upp;
%     
%     for k = kp : n
%         % obiekt
%         y(k) = symulacja_obiektu12y_p1(u(k-10), u(k-11), y(k-1), y(k-2));
%         
%         % oszczędna wersja DMC - algorytm
%         e = yzad(k) - y(k);
%         elem = 0;
%         for j = 1 : D-1
%             %??????????????????
%             if k-j <= 1
%                 du = 0;
%             else
%                 du = u(k-j) - u(k-j-1);
%             end
%             %??????????????????
%             elem = elem + ku(j)*du;
%         end
%         
%     
%         % optymalny przyrost sygnału sterującego w chwili k (du(k|k))
%         dukk = Ke * e - elem;
%     
%         if dukk > dumax
%             dukk = dumax;
%         elseif dukk < -dumax
%             dukk = -dumax;
%         end
%     
%     
%         % prawo regulacji
%         u(k) = dukk + u(k-1);
%     
%         if u(k) > Umax
%             u(k) = Umax;
%         elseif u(k) < Umin
%             u(k) = Umin;
%         end    
%     end
% 
% 
%     % wskaźnik jakości regulacji
%     E = 0;
%     for k = 1 : n
%         E = E + (yzad(k)-y(k))^2;
%     end
%     
% end
% 
