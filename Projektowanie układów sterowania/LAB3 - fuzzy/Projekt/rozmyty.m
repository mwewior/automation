
% K_pid1 = 0;         Ti1 = 999999999;    Td1 = 0;

% K_pid1 = 0.2;    Ti1 = 3.5;   Td1 = 1;
% K_pid2 = 0;     Ti2 = 99999;   Td2 = 0;
% K_pid3 = 6;      Ti3 = 1;    Td3 =  1.5;

%         K    Ti   Td
Pid1 = [0.15, 3.5, 0.8];
Pid2 = [0.4, 3, 0.7];
Pid3 = [14, 3, 0.3];

[E, y, u, u1, u2, u3, W1, W2, W3] = PID_rozmytysim(Pid1, Pid2, Pid3);


function [E, y, u, u1, u2, u3, W1, W2, W3] = PID_rozmytysim(Pid1, Pid2, Pid3)


K_pid1 = Pid1(1); Ti1 = Pid1(2); Td1 = Pid1(3);

K_pid2 = Pid2(1); Ti2 = Pid2(2); Td2 = Pid2(3);

K_pid3 = Pid3(1); Ti3 = Pid3(2); Td3 = Pid3(3);


% inicjalizacja
% Upp = -0.6;      Ypp = -1.09; %0.2 %0.0481101;  %0.9  %0.0597175;
% Upp = 0.4;  Ypp = 0.0595425;
Umin = -1;     Umax = 1;          
% dumax = 0.0559;
kp = 10;        
n = 200;        
T = 0.5;

% reg1:
% Upp = -0.9;
% Ypp = -2.2;
% Yzad = -1.467;

%reg2:
% Upp = -0.35;
% Ypp = -0.416139;
% Yzad = -0.31804;

%reg3:
Upp = 0.8;
Ypp = 0.0701173;
% Yzad = 0.0634483;

Yzad = 0.055;

u(1:kp-1) = Upp;        y(1:kp-1) = Ypp;
yzad(1:kp-1) = Ypp;     yzad(kp:n) = Yzad; %0.07;%0.0727849;
e(1:kp-1) = 0;

u1(1:n) = 0;
u2(1:n) = 0;
u3(1:n) = 0;


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


for k = kp:n
    % symulacja obiektu
    y(k) = symulacja_obiektu12y_p3(u(k-5), u(k-6), ...
                            y(k-1), y(k-2));
    
    % uchyb regulacji
    e(k) = yzad(k)-y(k);
    
    % sygnał sterujący regulatora PID
    u1(k) = r2_1*e(k-2) + r1_1*e(k-1) + r0_1*e(k) + u(k-1);
    u2(k) = r2_2*e(k-2) + r1_2*e(k-1) + r0_2*e(k) + u(k-1);
    u3(k) = r2_3*e(k-2) + r1_3*e(k-1) + r0_3*e(k) + u(k-1);


    % liczenie wag
    
    if(u(k-1)<=(-0.7))
    % Full pid1
        w1 = 1;
        w2 = 0;
        w3 = 0;

    elseif(u(k-1) > -0.7 && u(k-1) < -0.4)
    % pid1 + pid2
        a1 = 10/3;  b11 = -4/3; b12 = 7/3;
        w1 = -a1*u(k-1) + b11;
        w2 = a1*u(k-1) + b12;
        w3 = 0;

    elseif (u(k-1) >= (-0.4) && u(k-1) <= (-0.2))
    % Full pid2
        w1 = 0;
        w2 = 1;
        w3 = 0;

    elseif(u(k-1) > -0.35 && u(k-1) < 0.2)
    % pid2 + pid3    
        X = 10/4 * ( u(k-1) + 0.2);
        bell = 2.^(X.^7) - 1;

        w1 = 0;
        w2 = -bell +1;
        w3 = bell;
    
    elseif(u(k-1)>=0.2)
    % Full pid3
        w1 = 0;
        w2 = 0;
        w3 = 1;
    end

    W1(k) = w1;
    W2(k) = w2;
    W3(k) = w3;

    u(k) = (w1*u1(k) + w2*u2(k) + w3*u3(k)) / (w1+w2+w3);



    % du = u(k) - u(k-1);

    % ograniczenia wartości sygnału sterującego
    if u(k) < Umin
        u(k) = Umin;
    elseif u(k) > Umax
        u(k) = Umax;
    end

    % ograniczenia szybkości zmian sygnału sterującego
    % if du > dumax
    %     u(k) = u(k-1) + dumax;
    % elseif du < -dumax
    %     u(k) = u(k-1) - dumax;
    % end        
end

% wskaźnik jakości regulacji E
E = 0;
for k = 1 : n
    E = E + (yzad(k)-y(k))^2;
end

% set(0,'defaultLineLineWidth',1);
    froz = figure;
    subplot(2, 1, 1)
    stairs(y);
    hold on;
    stairs(yzad);
    % title("Algorytm PID  Kp=0.04  Ti=3.3  Td=0.01")
    legend("y(k)", "yzad")
    grid on
    
    subplot(2, 1, 2)
    stairs(u);
    legend("u(k)")
    grid on

end