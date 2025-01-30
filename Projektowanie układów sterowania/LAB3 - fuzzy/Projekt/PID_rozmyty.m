clear
%   tryb = 'minimalizacja';
  tryb = 'symulacja';

if(strcmp(tryb, 'minimalizacja'))
options = gaoptimset('StallGenLimit', 5, 'PopulationSize', 300, 'Generations', 400);
% options = optimoptions('ga', 'MaxGenerations', 400, 'PopulationSize', 50, 'Display','iter');


% Create an anonymous function that takes a vector X and unpacks its values
objFunc = @(X) PID_rozmytysim(X(1), X(2), X(3), X(4), X(5), X(6));

% Use the modified objective function with ga
[X] = ga(objFunc, 6, [], [], [], [], [], [], [], [], options);

% Display the optimized parameters
disp('Optimized parameters:');
disp(X);


elseif(strcmp(tryb, 'symulacja'))
    PID_rozmytysim(3.1700 ,  -3.7579  ,  4.2122 ,  -1.2294  , -8.0639  ,  2.5607)
end


function E = PID_rozmytysim(K_pid1, Ti1, Td1, K_pid2, Ti2, Td2)

% K_pid1 = 2; Ti1 = 0.8; Td1 = 1;
% K_pid2 = 0.2; Ti2 = 0.8; Td2 = 1;

% inicjalizacja
Upp = 0;      Ypp = 0;      
Umin = -1;     Umax = 1;          
% dumax = 0.0559;
kp = 12;        
n = 100;        
T = 0.5;

u(1:kp-1) = Upp;        y(1:kp-1) = Ypp;
yzad(1:kp-1) = Ypp;     yzad(kp:n) = Ypp - 0.04;
e(1:kp-1) = 0;

u1(1:kp-1) = 0;
u2(1:kp-1) = 0;

% parametry r regulatora PID
r0_1 = K_pid1*(1+T/(2*Ti1)+Td1/T);
r1_1 = K_pid1*(T/(2*Ti1)-2*Td1/T-1);
r2_1 = K_pid1*Td1/T;

r0_2 = K_pid2*(1+T/(2*Ti2)+Td2/T);
r1_2 = K_pid2*(T/(2*Ti2)-2*Td2/T-1);
r2_2 = K_pid2*Td2/T;

% w1 = -10/6 x + 1/3
% w2 = 10/6 x + 2/3

for k = kp:n
    % symulacja obiektu
    y(k) = symulacja_obiektu12y_p3(u(k-5), u(k-6), ...
                            y(k-1), y(k-2));
    
    % uchyb regulacji
    e(k) = yzad(k)-y(k);
    
    % sygnał sterujący regulatora PID
    u1(k) = r2_1*e(k-2) + r1_1*e(k-1) + r0_1*e(k) + u(k-1);
    u2(k) = r2_2*e(k-2) + r1_2*e(k-1) + r0_2*e(k) + u(k-1);
    
    % liczenie wag kiedy u(k-1) w obszarze rozmytym
    if(u(k-1)>=0.2)
        w1 = 1;
        w2 = 0;

    elseif(u(k-1)<=(-0.4))
        w1 = 0;
        w2 = 1;

    elseif(u(k-1)>(-0.4) && u(k-1)<0.2)
        w1 = u(k-1) * (-10/6) + 1/3;
        w2 = u(k-1) * (10/6) + 2/3;
        
    end

    u(k) = (w1*u1(k) + w2*u2(k))/(w1+w2);


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
