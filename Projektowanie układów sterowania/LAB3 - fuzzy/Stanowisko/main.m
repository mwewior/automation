clear

n = 1000;

% TODO NA LABACH
% 3. DLA TRAJEKTORII ZMIAN SYGNALOW?????
% UZYC DMC I PID Z LAB1
% tryb = 'pid_lab1';
%   tryb = 'dmc_lab1';

%% Tryb:
tryb = 'pid_roz';
%  tryb = 'dmc_roz';
% tryb = 'pomiar';

%% Parametry do ustawiania


% DMC
D = 290;      % horyzont dynamiki
N = 290;      % horyzont predykcji
Nu = 290;     % horyzont sterowania
lambda = 1;

%% Parametry stałe:
start = 300;
T = 1;
k = 0;

% Punkt Pracy
Upp = 27;
Ypp = 34.3;
Yzad = Ypp; 


PP = [Upp, Ypp];
%     u,    y

% Ograniczenia, inicjalizacja i wartość zadana:
Umin = 0;   Umax = 100;
Ymin = 0;   Ymax = 100;

 yzad(1:start) = Ypp;
 yzad(start+1:450) = Yzad+5;
 yzad(451:700) = Yzad+15;
 yzad(701:1000)=Ypp;
 
 
 y(1:start) = Ypp;
 
 u(1:start) = Upp;


%% Pomiar

if strcmp(tryb, 'pomiar')
    k = 0;
    while(1)
    k = k+1
%     y(k) = obiekt12(u);
     y(k) = obiekt12(27);
    
    stairs(y);
    drawnow 
    end
end

%% PID
if strcmp(tryb, 'pid_lab1')
    % parametry:
    K_pid = 4;
    Ti = 60;
    Td = 0.3;
    k = 10;
    
    while(1)  % na rzeczywistym obiekcie 
        
        k = k + 1;
        
        y(k) = obiekt12(u(k-1)); % rzeczywisty obiekt

        if y(k) > Ymax
            y(k) = Ymax;
        elseif y(k) < Ymin
            y(k) = Ymin;
        end

        u(k) = regulacjaPID(T, k, u, y, yzad, K_pid, Ti, Td);

        if u(k) > Umax
            u(k) = Umax;
        elseif u(k) < Umin
            u(k) = Umin;
        end
        
        subplot(2, 1, 1)
        stairs(y); hold on; grid on;
        stairs(yzad); 
        hold off;
        drawnow;
        
        subplot(2, 1, 2)
        stairs(u);
        drawnow
    end
end

if(strcmp(tryb, 'pid_roz'))
    K_pid = 4;
    Ti = 60;
    Td = 0.3;
    k = 280;
    
    Pid1 = [4, 60, 0.3];
    Pid2 = [8, 60, 0.3];
    Pid3 = [14, 60, 0.3];

%     [E, y, u, u1, u2, u3, W1, W2, W3] = PID_rozmytysim(Pid1, Pid2, Pid3, T, k, u, y, yzad);

    while(1)  % na rzeczywistym obiekcie 
        
        k = k + 1;
        
        y(k) = obiekt12(u(k-1)); % rzeczywisty obiekt

        if y(k) > Ymax
            y(k) = Ymax;
        elseif y(k) < Ymin
            y(k) = Ymin;
        end

        u(k) = PID_rozmytysim(Pid1, Pid2, Pid3, T, k, u, y, yzad);

        if u(k) > Umax
            u(k) = Umax;
        elseif u(k) < Umin
            u(k) = Umin;
        end
        
        subplot(2, 1, 1)
        stairs(y); hold on; grid on;
        stairs(yzad); 
        hold off;
        drawnow;
        
        subplot(2, 1, 2)
        stairs(u);
        drawnow
    end

   
end

%% DMC LAB1

if strcmp(tryb, 'dmc_lab1')
    k = 10
    h = load("aproksymacja_obszar1");
    s = h.ymod;

    [Mp, K] = dmc_offline(s, D, N, Nu, lambda);

    while(1)  % na rzeczywistym obiekcie
        k = k + 1 
        y(k) = obiekt12(u(k-1));
   
        du = regulacjaDMC(k, u, y, yzad, D, N, K, Mp);
        
%         if(~pomiar_zaklocen)
%             du = regulacjaDMC(k, u, y, yzad, zeros(1,n), D, Dz, N, K, Mp, Mzp);
%         end

        u(k) = u(k-1) + du;       

        subplot(3, 1, 1)
        stairs(y); hold on; grid on;
        stairs(yzad); 
        hold off;
        drawnow

        subplot(3, 1, 2)
        stairs(u); grid on;
        drawnow
    end
end

if strcmp(tryb, 'dmc_roz')
    k = 10
    %% skok 
    h1 = load("aproksymacja_obszar1");
    s{1} = h1.ymod;
    h2 = load("aproksymacja_obszar2");
    s{2} = h2.ymod;
    h3 = load("aproksymacja_obszar3");
    s{3} = h3.ymod;

    while(1)  % na rzeczywistym obiekcie
        k = k + 1 
        y(k) = obiekt12(u(k-1));
   
        u(k) = dmc_romzyty(D, N, Nu, lambda, k, T, s{1}, s{2}, s{3})
        
%         if(~pomiar_zaklocen)
%             du = regulacjaDMC(k, u, y, yzad, zeros(1,n), D, Dz, N, K, Mp, Mzp);
%         end

%         u(k) = u(k-1) + du;       

        subplot(3, 1, 1)
        stairs(y); hold on; grid on;
        stairs(yzad); 
        hold off;
        drawnow

        subplot(3, 1, 2)
        stairs(u); grid on;
        drawnow
    end
end
%% 
function [Mp, K] = dmc_offline(s, D, N, Nu, lambda)

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

   
    % wektor K
    I = eye(Nu);
    K = ((M'*M + lambda*I)^(-1))*M';
end



% [y, u, u1, u2, u3, W1, W2, W3]
function u_wyj = PID_rozmytysim(Pid1, Pid2, Pid3, T, k, u, y, yzad)
    
K_pid1 = Pid1(1); Ti1 = Pid1(2); Td1 = Pid1(3);
K_pid2 = Pid2(1); Ti2 = Pid2(2); Td2 = Pid2(3);
K_pid3 = Pid3(1); Ti3 = Pid3(2); Td3 = Pid3(3);


% inicjalizacja
% Upp = -0.6;      Ypp = -1.09; %0.2 %0.0481101;  %0.9  %0.0597175;
% Upp = 0.4;  Ypp = 0.0595425;
% Umin = -1;     Umax = 1;          

% kp = 10;        
% n = 200;        
% T = 0.5;

%reg3:
% Upp = 0.8;
% Ypp = 0.0701173;
% Yzad = 0.0634483;

% Yzad = 0.055;

% u(1:kp-1) = Upp;        y(1:kp-1) = Ypp;
% yzad(1:kp-1) = Ypp;     yzad(kp:n) = Yzad; %0.07;%0.0727849;
% e(1:kp-1) = 0;

% u1(1:n) = 0;
% u2(1:n) = 0;
% u3(1:n) = 0;


% parametry r regulatora PID
r0_1 = K_pid1*(1+T/(2*Ti1)+Td1/T);
r1_1 = K_pid1*(T/(2*Ti1)-2*Td1/T-1);
r2_1 = K_pid1*Td1/T;

r0_2 = K_pid2*(1+T/(2*Ti2)+Td2/T);
r1_2 = K_pid2*(T/(2*Ti2)-2*Td2/T-1);
r2_2 = K_pid2*Td2/T;

r0_3 = K_pid3*(1+T/(2*Ti3)+Td3/T);
r1_3 = K_pid3*(T/(2*Ti3)-2*Td3/T-1);
r2_3 = K_pid3*Td3/T;


% for k = kp:n
    % symulacja obiektu
%     y(k) = symulacja_obiektu12y_p3(u(k-5), u(k-6), ...
%                             y(k-1), y(k-2));

    % uchyb regulacji
    e(k) = yzad(k)-y(k);
    e(k-1) = yzad(k-1)-y(k-1);
    e(k-2) = yzad(k-2)-y(k-2);
    
    % sygnał sterujący regulatora PID
    u1 = r2_1*e(k-2) + r1_1*e(k-1) + r0_1*e(k) + u(k-1);
    u2 = r2_2*e(k-2) + r1_2*e(k-1) + r0_2*e(k) + u(k-1);
    u3 = r2_3*e(k-2) + r1_3*e(k-1) + r0_3*e(k) + u(k-1);


    % liczenie wag
    
    if(y(k-1)<=43)
    % Full pid1
        w1 = 1;
        w2 = 0;
        w3 = 0;

%     elseif(y(k-1) >45 && y(k-1) < 52)
%     % pid1 + pid2
%         a1 = 10/3;  b11 = -4/3; b12 = 7/3;
%         w1 = -a1*u(k-1) + b11;
%         w2 = a1*u(k-1) + b12;
%         w3 = 0;

    elseif (y(k-1) >= 43 && y(k-1) <= 49)
    % Full pid2
        w1 = 0;
        w2 = 1;
        w3 = 0;

%     elseif(u(k-1) > 65 && u(k-1) < 72)
%     % pid2 + pid3    
%         X = 10/4 * ( u(k-1) + 0.2);
%         bell = 2.^(X.^7) - 1;
% 
%         w1 = 0;
%         w2 = -bell +1;
%         w3 = bell;
    
    elseif(y(k-1)>=49)
    % Full pid3
        w1 = 0;
        w2 = 0;
        w3 = 1;
    end
% 
%     W1(k) = w1;
%     W2(k) = w2;
%     W3(k) = w3;
    

    u_wyj = (w1*u1 + w2*u2 + w3*u3) / (w1+w2+w3);

    % du = u(k) - u(k-1);

    % ograniczenia wartości sygnału sterującego
%     if u(k) < Umin
%         u(k) = Umin;
%     elseif u(k) > Umax
%         u(k) = Umax;
%     end     
    
end
% end
 

function uResult = dmc_romzyty(D, N, Nu, lambda, k, T, s{1}, s{2}, s{3})

    % D = 200;
    % N = 200;
    % Nu = 2;
    % lambda = 1;

    % kp = 7;
    % kk = 2500;
    lRegul = 3;

%% inicjalizacja sterowania i wyjscia symulacji
for r = 1:lRegul
    u{r} = ones(1, kk)*Upp;
end
y(1:kp-1) = Ypp;        
y(kp:kk) = 0;
uResult(1:kp-1) = Upp;
uResult(kp:kk) = 0;


%% macierz M
for r = 1:lRegul
    m = zeros(N, Nu);
    for i = 1 : Nu
        m(i : N, i) = s{r}(1 : (N - i + 1))';
    end
    M{r} = m;
end

%% macierz Mp
for r = 1:lRegul
    mp = zeros(N, D-1);
    for i = 1 : N
       for j = 1 : D-1
          if i+j <= D
             mp(i, j) = s{r}(i+j) - s{r}(j);
          else
             mp(i, j) = s{r}(D) - s{r}(j);
          end    
       end
    end
    Mp{r} = mp;
end

%% obliczam K
I = eye(Nu);
for r = 1:lRegul
    K{r} = ((M{r}'*M{r} + lambda*I)^(-1))*M{r}';
end

%% oszczędna wersja DMC - parametry
for r = 1:lRegul
    Ke{r} = sum(K{r}(1,:));
    ku{r} = K{r}(1, :)*Mp{r};
end

%% symulacja
for k = kp:kk
    % wagi
    w = wagi(uResult(k-1));

    % obiekt
    y(k) = obiek12(u(k-1))
    
    % uchyb
    e = yzad(k) - y(k);

    for r = 1:lRegul
        elem = 0;
        for j = 1 : D-1
            if k-j <= 1
                du = 0;
            else
                du = u{r}(k-j) - u{r}(k-j-1);
            end
            elem = elem + ku{r}(j)*du;
        end

        % optymalny przyrost sygnału sterującego w chwili k (du(k|k))
        dukk = Ke{r} * e - elem;

        % prawo regulacji
        u{r}(k) = dukk + u{r}(k-1);

        uResult(k) = uResult(k) + w(r)*u{r}(k);
    end
    uResult(k) = uResult(k) / sum(w);

    % ograniczenia sterowania
    if uResult(k) > Umax
        uResult(k) = Umax;
    elseif uResult(k) < Umin
        uResult(k) = Umin;
    end   
end

end