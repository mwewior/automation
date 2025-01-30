%% dane

% % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                   %
%                      4.3                          %
%    G(s) = ------------------------ * e^{-5s}      %
%         9.2988s^2 + 6.81s + 1                     %
%          T1*T2      T1+T2                         %
%                                                   %
% % % % % % % % % % % % % % % % % % % % % % % % % % %

clear
close all

K0 = 4.3;
T0 = 5;
T1 = 1.89;
T2 = 4.92;

mode = 'pid';
% mode = 'dmc';
% mode = 'compare';
% mode = 'gpc';

%%% dobór długości horyzontów regulatora:
D = 74; N = 20; Nu = 2;
lambda = 200;


%% zadanie 1

licz_c = K0;
mian_c = [T1*T2 T1+T2 1];
Tp = 0.5;
% Tosc = 3;
% dzeta = 0.7;
% mian_c = [Tosc^2 2*dzeta*Tosc 1];
% Tp = 1;

[licz_d, mian_d] = c2dm(licz_c, mian_c, Tp, 'zoh');
%%% po uwzględnieniu z^-10
licz_dz = [zeros(1,9) licz_d];
mian_dz = [mian_d zeros(1,9)];

sys_c = tf(licz_c, mian_c, 'InputDelay', T0);
sys_d = tf(licz_d, mian_d, Tp, 'InputDelay', T0/Tp);
% Kstat_c = step(sys_c, 60);
Ydys = step(sys_d, 60);
czas = size(Ydys); czas = czas(1) - 1;

% figure;
% step(sys_c);
% hold on;
% step(sys_d);
% legend("model ciągły", "model dyskretny", 'Location', 'SouthEast')
% hold on;
% grid on;



%% zadanie 2

W = idpoly(mian_dz, licz_dz);
b_wszystkie = -1*W.A; sz = size(b_wszystkie,2);
b = zeros(1, sz-1);
b(1:sz-1) = b_wszystkie(2:sz); % współczynniki y(k-1)
c = W.B; % współczynniki u(k-i)

b1 = b(1); b2 = b(2);
c11 = c(11); c12 = c(12);



%% zadanie 3

%%% ziegler-nichols:

Kk = 0.50562; Ki=0; Kd=0;
Tk = 20;
% ziegler = pid(Kk, Ki, Kd);
% step(feedback(ziegler*sys_c, 1));

Kr = 0.6 * Kk;
Ti = 0.5 * Tk;
Td = 0.12 * Tk;

r0 = Kr * (1 + Tp/(2*Ti) + Td/Tp);
r1 = Kr * (Tp/(2*Ti) - 2*Td/Tp - 1);
r2 = Kr * Td / Tp;


%% zadanie 4 - PID

u(1:12) = 0; y(1:12) = 0; e(1:12) = 0;
yzad(1:12) = 0; yzad(13:czas) = 1;


for k=13:czas
    y(k) = b1*y(k-1) + b2*y(k-2) + c11*u(k-11) + c12*u(k-12);
    e(k) = yzad(k) - y(k);
    u(k) = r2*e(k-2) + r1*e(k-1) + r0*e(k) + u(k-1);
end

u_pid = u;
y_pid = y;

if strcmp(mode, 'pid')
    figure; stairs(u_pid); grid on;
    title('u'); xlabel('k');
    
    figure; stairs(y_pid); grid on;
    hold on; stairs(yzad, ':');
    title('yzad, y'); xlabel('k');
end


%% czyszczenie przestrzeni zmiennych

if strcmp(mode, 'pid') == 0
    clear sys_d sz b_wszystkie b c W;
    clear licz_c licz_d licz_dz mian_c mian_d mian_dz;
    clear Kd Ki Kk Kr r0 r1 r2 T1 T2 Td Ti Tk;
    clear u y e i j k;
end


%% Zadanie 4 - DMC

% Legend=cell(6,1);

%%% inicjalizacja:
y(1:12) = zeros(12, 1); %czas
u(1:12) = zeros(12, 1);
yzad = zeros(czas, 1); 
yzad(13:czas) = 1;

yo = zeros(N, 1);
delta_u = zeros(Nu, 1);
delta_uP = zeros(D-1, 1);

M = zeros(N, Nu);
Mp = zeros(N, D-1);

s = zeros(D,1);
Yzad = ones(N, 1);
% 
% stairs(0, ':');
% hold on;
% 
% for p=1:5
%     if p == 1
%         lambda = 1;
%     elseif p == 2
%         lambda = 50;
%     elseif p == 3
%         lambda = 100;
%     elseif p == 4
%         lambda = 200;
%     elseif p == 5
%         lambda = 400;
%     end
%     Legend{1} = ' ';
% Legend{p+1}=strcat('lambda = ', num2str(lambda));

% 
%      y(1:12) = zeros(12, 1); %czas
% u(1:12) = zeros(12, 1);
% yzad = zeros(czas, 1); 
% yzad(13:czas) = 1;
% 
% yo = zeros(N, 1);
% delta_u = zeros(Nu, 1);
% delta_uP = zeros(D-1, 1);
% 
% M = zeros(N, Nu);
% Mp = zeros(N, D-1);
% 
% s = zeros(D,1);
% Yzad = ones(N, 1);

%%% przypisywanie wartości:
for j=1:czas
    s(j) = Ydys(j+1);
end

for i=1:N
    %%% uzupełnienie macierzy M
    for j=1:Nu
        if j <= i
            M(i, j) = s(i-j+1);
        end   
    end
    %%% uzupełnienie macierzy MP
    for j=1:D-1
        if i+j>D
            Mp(i, j) = s(D) - s(j);
        else
            Mp(i, j) = s(i+j) - s(j);
        end
    end
end

K_dmc = ((M')*M + lambda*eye(Nu)) \ (M');


for k=13:czas
    
    y(k) = b1*y(k-1) + b2*y(k-2) + c11*u(k-11) + c12*u(k-12);

    yk = ones(N, 1)*y(k);
    yo = yk + Mp*delta_uP;
    delta_u = K_dmc * (Yzad - yo);
    
    delta_uP(2:D-1) = delta_uP(1:D-2);
    delta_uP(1) = delta_u(1);

    u(k) = u(k-1) + delta_u(1);

end

u_dmc = u;
y_dmc = y;

% stairs(u); grid on;
% hold on;
% title('u'); xlabel('k');
% hold on;
% 
% end
% 
% legend(Legend,'Location', 'SouthEast')

if strcmp(mode, 'dmc')

    figure; stairs(u);
    grid on;
    title('u'); xlabel('k');
    hold on;
    
    figure;
    stairs(y); grid on;
    hold on; 
    stairs(yzad, ':');
    title('y, yzad'); xlabel('k');
    hold on;
end



%% czyszczenie przestrzeni zmiennych

if strcmp(mode, 'dmc') == 0
    clear sys_d sz b_wszystkie b c W;
    clear licz_c licz_d licz_dz mian_c mian_d mian_dz;
    clear s D N Nu M Mp delta_u delta_uP lambda K_dmc;
    clear u y Ydys yk yo Yzad i j k;
end



%% porównanie regulacji

if strcmp(mode, 'compare')
    
    figure; grid on;
    stairs(u_pid); hold on;
    stairs(u_dmc); hold on;
    title('u'); xlabel('k');
    legend("pid", "dmc", 'Location', 'SouthEast')

    figure; grid on;
    stairs(y_pid); hold on;
    stairs(y_dmc); hold on;
    stairs(yzad, ':')
    title('y, yzad'); xlabel('k');
    legend("pid", "dmc", 'Location', 'SouthEast')
end






