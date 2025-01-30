%% GŁÓWNY PLIK

clear

% tryb = '';
 tryb = 'zaklocenia';

n=500;
start = 10;

Yzad = 1;
yzad(1:start) = 0;
yzad(start+1:n) = Yzad;

delta_u_max = 50;  % do sprawdzenia na obiekcie

Umax = 100;
Umin = 0;
Ymax = 100;
Ymin = 0;

u(1:start-1) = 0;
z(1:n) = 0;
s(1:n) = 0;
u(start:n) = 1;
y(1:n) = 0;


% odpowiedz s
for k=start:n
    y(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2));
    s(k) = y(k);
end

D = 160;
s = y(start:D+start)';

% odpowiedz s_z
u(1:n) = 0;
z(1:start-1) = 0;
z(start:n) = 1;
s_z(1:n) = 0;
y_z(1:n) = 0;

for k=start:n
    y_z(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y_z(k-1), y_z(k-2));
    s_z(k) = y_z(k);
end

if strcmp(tryb, 'zaklocenia')
    k_stabilne = 130;
    z(130:n) = 1;
elseif strcmp(tryb, 'zaklocenia_sin')
    zak = 1;
    x = 0:1:n;
    z = sin(0.1*x)*zak;
end

Dz = 60;
s_z = y(start:Dz+start)';


% DMC

% parametry - do nastawienia
D = 160;      % horyzont dynamiki
N = 40;      % horyzont predykcji
Nu = 3;     % horyzont sterowania
Dz = 60;     % horyzont zakłóceń
lambda = 2;

start = 10;
u(1:n) = 0;
y(1:n) = 0;

yzad(start:n)=10;

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

% macierz Mzp
Mzp = zeros(N, Dz);
for i = 1 : N
    for j = 1 : Dz
        if j == 1
            Mzp(i, j) = s_z(i);
        elseif i+j>Dz
            Mzp(i, j) = s_z(Dz) - s_z(j);
        else
            Mzp(i, j) = s_z(i+j) - s_z(j);
        end
    end
end

% obliczam K
I = eye(Nu);
K = ((M'*M + lambda*I)^(-1))*M';


 % while(1)  % na rzeczywistym obiekcie
 k = start;
 z(130:n) = 3;
 while k < n % symulacja

    k = k + 1;
    
    % szumy
    %{
    if k == 20 || k == 21 || k == 22 || k == 100
        z(k) = 1.5*z(k);
    elseif k == 30 || k == 31 || k == 32 || k == 150
        z(k) = 0.5*z(k);
    end
    %}

    
    % y(k) = obiekt12(u(k-1), k); % rzeczywisty obiekt
    y(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2)); % symulacja
    
%   y(k) = obiekt_aproksymacja(k, u, y);

    % if y(k) > Ymax
    %     y(k) = Ymax;
    % elseif y(k) < Ymin
    %     y(k) = Ymin;
    % end

    du = regulacjaDMC(k, u, y, z, yzad, D, N, K, Mp, Mzp, Dz);


    % if du > delta_u_max
    %     du = delta_u_max;
    % elseif du < (-1)*delta_u_max
    %     du =  -delta_u_max;
    % end
 
    u(k) = u(k-1) + du;

end



%% błąd i wykresy

ek = (y-yzad);
E = ek*ek';



figure;
stairs(u); grid on;
figure;
stairs(yzad, '--'); hold on;
stairs(y); grid on;

