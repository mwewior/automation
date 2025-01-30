clear

zadanie = 'dmc';
%{
Yk = symulacja_obiektu12y_p1(Ukm10,Ukm11,Ykm1,Ykm2)
 Parametry:
  Ukm10 -- u(k-10)
  Ukm11 -- u(k-11)
  Ykm1  -- y(k-1)
  Ykm2  -- y(k-2)
 Wartość zwracana:
  Yk    -- y(k)
 Ograniczenia:
  7.000000e-01 <= u <= 1.100000e+00
 Punkt pracy:
  Upp = 9.000000e-01
  Ypp = 3.500000e+00
%}

n = 200;
Upp = 9.000000e-01;
Ypp = 3.500000e+00;
delay = 20;

%% ZADANIE 1
if strcmp(zadanie, 'poprawnoscpp')
u(1:n) = Upp;
y(1:12) = Ypp;

for k = 13:n
    y(k) = symulacja_obiektu12y_p1(u(k-10), u(k-11), y(k-1), y(k-2));
end
%}
%%% wykres:

figure
Legenda = cell(2, 1);
stairs(u); hold on; Legenda{1} = "Upp";
stairs(y); hold on; Legenda{2} = "Ypp";
grid on;
title("Sygnały wejściowy i wyjściowy"); xlabel('k');
legend(Legenda, 'Location', 'East');

% matlab2tikz('poprawnoscpp.tex');

end

%% ZADANIE 2
if strcmp(zadanie, 'odp_skok')
highU = 1.1;
lowU = 0.7;
midU = 1.0;

for i=1:3
    y(1:n, i) = 0;
    y(1:delay, i) = Ypp;
    u(1:delay, i)= Upp;
    if i==1
        u(delay+1:n, i) = highU;
        
        for k=delay:n
            y(k, i) = symulacja_obiektu12y_p1(u(k-10, i), u(k-11, i), y(k-1, i), y(k-2, i));
        end
    end

    if i==2
        u(delay+1:n, i) = midU;
        for k=delay:n
            y(k, i) = symulacja_obiektu12y_p1(u(k-10, i), u(k-11, i), y(k-1, i), y(k-2, i));
        end
    end

    if i==3
        u(delay+1:n, i) = lowU;
        for k=delay:n
            y(k, i) = symulacja_obiektu12y_p1(u(k-10, i), u(k-11, i), y(k-1, i), y(k-2, i));
        end
    end
end

%{
figure
subplot(2,1, 1)
title('Skokowe zmiany sygnału sterującego')
stairs(u(:,1)); hold on; stairs(u(:,2)); hold on; stairs(u(:,3));
legend('skok do 1.1', 'skok do 1.0', 'spadek do 0.7')
legend('Location','southeast');
xlabel('k'); ylabel('u');

subplot(2,1, 2)
% figure
title('Odpowiedzi skokowe dla różnych zmian sterowania')
stairs(y(:,1)); hold on; stairs(y(:,2)); hold on; stairs(y(:,3));
legend('skok do 1.1', 'skok do 1.0', 'spadek do 0.7')
legend('Location','southeast');
xlabel('k'); ylabel('y');
matlab2tikz('tikz/odpskokowa.tex');
%}


end
%% ZADANIE 3
%

u(1:delay-1) = Upp;
S(n) = 0;
skokU = 1;
u(delay:n) = skokU;
deltaU = skokU - Upp;
y(1:delay-1) = Ypp; 

for k=delay:n
    y(k) = symulacja_obiektu12y_p1(u(k-10), u(k-11), y(k-1), y(k-2));
    S(k-delay+1) = (y(k) - Ypp)/deltaU;
end
S(n-delay+1:n) = S(n-delay);

clearvars y

%{
figure
stairs(S)
%}

%% ZADANIE 4
% PID [pid]
if strcmp(zadanie, 'pid')
    % inicjalizacja:
    T = 0.5;
    start = 20;
    u(1:19) = Upp;
    y(1:19) = Ypp;
    yzad(1:19) = Ypp;
    yzad(20:n) = Ypp + 0.4;
    e(1:19) = 0;
    E = 0;
    
    % K_pid = 1.27; Ti = 5; Td = 5;
     % K_pid = 1.25; Ti = 8; Td = 3;
    
    %fmincon wylicza gorzej xdd
      K_pid = 1.3338; Ti = 8.7722; Td = 4.4151;
    
    
    r0 = K_pid*(1+T/(2*Ti) +Td/T);
    r1 = K_pid*(T/(2*Ti)-2*Td/T-1);
    r2 = K_pid*Td/T;
    
    for k = start:n
        y(k) = symulacja_obiektu12y_p1(u(k-10), u(k-11), y(k-1), y(k-2));
        e(k) = yzad(k)-y(k);
        u(k) = r2*e(k-2) + r1*e(k-1) + r0*e(k) + u(k-1);
        delta_u = u(k) - u(k-1);
        delta_u_max = 0.0559;
    
        if u(k) < 0.7
            u(k) = 0.7;
        elseif u(k)>1.1
            u(k) = 1.1;
        end
    
      
        if delta_u > 0.0559
            u(k) = u(k-1) + delta_u_max;
        elseif delta_u < -0.0559
            u(k) = u(k-1) - delta_u_max;
        end
     
        E = E + (yzad(k) - y(k))^2;
    end
    
    
    figure
    subplot(2,1,1)
    stairs(yzad); hold on;
    stairs(y); hold on;
    grid on; legend('yzad', 'y','Location', "SouthEast");
    subplot(2,1,2)
    stairs(u); grid on; legend('u','Location', "SouthEast")
    
    end


%% ZAD.4,5,6    algorytm DMC
if strcmp(zadanie, 'dmc')

    %
    % metoda fmincon
    D = 130;
    N = 140;
    Nu = 16;
    lambda = 2.27;

    %}

    %{
    % metoda eksperymentalna
    D = 130;      % horyzont dynamiki
    N = 140;      % horyzont predykcji
    Nu = 10;      % horyzont sterowania
    lambda = 10;   
    %}

    Umin = 0.7;
    Umax = 1.1;
    dumax = 0.0599;
    
    kp = 12;
    kk = N+D-1;
    
    % dane do odpowiedzi skokowej
    y(1:kp-1) = Ypp;      % Ypp
    u(1:kp-1) = Upp;      % Upp
    u(kp:kk+kp) = 1;      % skok (kp => odpowiednik k=0)
    
    % ???????????????
    yzad(kp:n) = Ypp + 0.2;      % wartość zadana 
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
    

    % wykresy
    % subplot(2, 1, 1)
    stairs(y, 'LineWidth',0.9);
    hold on;
    stairs(yzad);
    grid on
    axis([0 n Ypp 3.73])
    title("Regulator DMC")
    xlabel('k');
    ylabel('odpowiedź y');
    legend("y(k)", "yzad", 'Location','southeast')
    matlab2tikz('tikz\dmc_optymalny.tex');
    % subplot(2, 1, 2)
    % plot(1:n, u)
    % grid on
    % axis([0 n 0.9 1.12])
    % legend("u(k)")
end









