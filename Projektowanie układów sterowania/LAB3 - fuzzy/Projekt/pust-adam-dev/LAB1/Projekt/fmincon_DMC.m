%% Optymalizacja nastawów DMC

%fmincon
objective = @(x) DMC (x(1), x(2), x(3), x(4));
x_initial = [130, 140, 10, 10];
lb = [10, 10, 5, 0];
ub = [500, 500, 500, 1000];

nonlcon = [];

options = optimoptions('fmincon', 'Display', 'iter');
[x_optimal, fval] = fmincon(objective, x_initial, [], [], [], [], lb, ub, nonlcon, options);


function E = DMC(D, N, Nu, lambda)
    D = round(D);      % horyzont dynamiki
    N = round(N);      % horyzont predykcji
    Nu = round(Nu);      % horyzont sterowania

    Upp = 0.9;
    Ypp = 3.5;

    n = 500;

    Umin = 0.7;
    Umax = 1.1;
    dumax = 0.01;
    
    kp = 12;
    kk = N+D-1;
    
    % dane do odpowiedzi skokowej
    y(1:kp-1) = Ypp;      % Ypp
    u(1:kp-1) = Upp;      % Upp
    u(kp:kk+kp) = 1;      % skok (kp => odpowiednik k=0)
    
    % ???????????????
    yzad(1:n) = Ypp + 0.2;      % wartość zadana 
    % ???????????????
    
    % odpowiedź skokowa
    for k = kp : kk + kp
        y(k) = symulacja_obiektu12y_p1(u(k-10), u(k-11), y(k-1), y(k-2));
    end
    s(1:kk) = (y(kp+1:end)-ones(1, kk)*Ypp)/(1-Upp);
    
    
    % macierz M
    M = zeros(N, Nu);
    for i = 1 : Nu
        M(i : N, i) = s(1 : (N - i + 1))';
    end
    
    
    % macierz Mp
    Mp = zeros(N, D-1);
    for i = 1 : N
        for j = 1 : D-1
            Mp(i, j) = s(i+j) - s(j);
        end
    end
    
    
    % obliczam K
    I = eye(Nu);
    K = ((M'*M + lambda*I)^(-1))*M';
    
    
    % oszczędna wersja DMC - parametry
    Ke = 0;
    for i = 1 : N
        Ke = Ke + K(1, i);
    end
    ku = K(1, :) * Mp;
    
    
    % symulacja
    y(1:kp-1) = Ypp;
    u(1:kp-1) = Upp;
    
    for k = kp : n
        % obiekt
        y(k) = symulacja_obiektu12y_p1(u(k-10), u(k-11), y(k-1), y(k-2));
        
        % oszczędna wersja DMC - algorytm
        e = yzad(k) - y(k);
        elem = 0;
        for j = 1 : D-1
            %??????????????????
            if k-j <= 1
                du = 0;
            else
                du = u(k-j) - u(k-j-1);
            end
            %??????????????????
            elem = elem + ku(j)*du;
        end
        
    
        % optymalny przyrost sygnału sterującego w chwili k (du(k|k))
        dukk = Ke * e - elem;
    
        if dukk > dumax
            dukk = dumax;
        elseif dukk < -dumax
            dukk = -dumax;
        end
    
    
        % prawo regulacji
        u(k) = dukk + u(k-1);
    
        if u(k) > Umax
            u(k) = Umax;
        elseif u(k) < Umin
            u(k) = Umin;
        end    
    end


    % wskaźnik jakości regulacji
    E = 0;
    for k = 1 : n
        E = E + (yzad(k)-y(k))^2;
    end
    
end

