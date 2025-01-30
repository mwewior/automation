%% GŁÓWNY PLIK

% tryb = 'pid';
tryb = 'dmc';
% tryb = 'pomiar';

T = 1;
k = 0;

PP = [27.62, 29.25];
PP2 = [29.81, 32.18];

n = 2000;

Yzad = 38;


%% inicjalizacja / ograniczenia

 
 k = k+1;
 [u0, y0] = pomiar();
  


u(1:100) = u0; y(1:100)= y0;
yzad(1:100) = y(1:100); yzad(101:n) = Yzad;

delta_u_max = 50;  % do sprawdzenia na obiekcie


% transmitancja zjada warunki początkowe - offset 
% Umax = 73;
% Umin = -27;
% 
% Ymax = 71;
% Ymin = -29;

Umax = 100;
Umin = 0;
Ymax = 100;
Ymin = 0;

k=100; % symulacja

%% VOID MILOSZ

if strcmp(tryb, 'pomiar')

   while(1)
       k = k+1
       [u(k), y(k)] = pomiar()
   end
end

%% Regulatory:
%% PID

if strcmp(tryb, 'pid')


    % parametry:
    K_pid = 5;
    Ti = 60;
    Td = 0.3;


    while(1)  % na rzeczywistym obiekcie 
%     while(k<n) % symulacja 

        stairs(y); hold on; grid on;
        stairs(yzad); 
        hold off;
        drawnow
        
        k = k + 1;
        
        y(k) = obiekt12(u(k-1), k); % rzeczywisty obiekt

%         y(k) = obiekt_aproksymacja(k, u, y);

        if y(k) > Ymax
            y(k) = Ymax;
        elseif y(k) < Ymin
            y(k) = Ymin;
        end

        u(k) = regulacjaPID(T, k, u, y, yzad, K_pid, Ti, Td);

        delta_u = u(k) - u(k-1);

        if delta_u > delta_u_max
            u(k) = u(k-1) + delta_u_max;
        elseif delta_u < (-1)*delta_u_max
            u(k) = u(k-1) - delta_u_max;
        end

        if u(k) > Umax
            u(k) = Umax;
        elseif u(k) < Umin
            u(k) = Umin;
        end
    
    end

end



%% DMC

if strcmp(tryb, 'dmc')


    S = load("aproksymacja.mat");
    s = S.ymod;
    len = size(s, 2);
%     S = load("zad2_pomiary.mat");
%     s = S.z2_27_35;

% s = S.ymod;

    % parametry - do nastawienia
    D = len;      % horyzont dynamiki
    N = len;      % horyzont predykcji
    Nu = 80;      % horyzont sterowania
    lambda = 1;

    % macierz M
    M = zeros(N, Nu);
    for i = 1 : Nu
        
        M(i : N, i) = s(1 : (N - i + 1))';
    end
    
    % macierz Mp
    Mp = zeros(N, D-1);
    for i = 1 : N
        for j = 1 : D-1
            if i+j>D
                Mp(i, j) = s(D) - s(j);
            else
                Mp(i, j) = s(i+j) - s(j);
            end
        end
    end
    
    % obliczam K
    I = eye(Nu);
    K = ((M'*M + lambda*I)^(-1))*M';
    
    
     while(1)  % na rzeczywistym obiekcie 
%     while k < n % symulacja

        k = k + 1;
    
        subplot(2, 1, 1)
        stairs(y); hold on; grid on;
        stairs(yzad);
        hold off;
        subplot(2, 1, 2)
        stairs(u);
        drawnow
        
        y(k) = obiekt12(u(k-1), k); % rzeczywisty obiekt
%         y(k) = symulacja_obiektu12y_p1(u(k-10), u(k-11), y(k-1), y(k-2)); % symulacja

%         y(k) = obiekt_aproksymacja(k, u, y);

        if y(k) > Ymax
            y(k) = Ymax;
        elseif y(k) < Ymin
            y(k) = Ymin;
        end

        du = regulacjaDMC(k, u, y, yzad, D, N, K, Mp);
    

        if du > delta_u_max
            du = delta_u_max;
        elseif du < (-1)*delta_u_max
            du =  -delta_u_max;
        end
     
        u(k) = u(k-1) + du;

        if u(k) > Umax
            u(k) = Umax;
        elseif u(k) < Umin
            u(k) = Umin;
        end


    end

end

%% błąd i wykresy

% ek = (y-yzad);
% E = ek*ek';



% figure;
% stairs(u); grid on;
% figure;
% stairs(yzad, '--'); hold on;
% stairs(y); grid on;
