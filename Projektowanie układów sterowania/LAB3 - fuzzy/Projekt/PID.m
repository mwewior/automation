clear
PIDsim(1.1, 0.8, 1)
% regulator PID K 0,60K T 0,50T T 0,12T


% PID(0.04, 1000000000000000000000000000, 0)
function E = PIDsim(K_pid, Ti, Td)
    % inicjalizacja
    Upp = 0;      Ypp = 0;      
    Umin = -1;     Umax = 1;          
%     dumax = 0.0559;
    kp = 12;        
    n = 100;        
    T = 0.5;
    
    u(1:kp-1) = Upp;        y(1:kp-1) = Ypp;
    yzad(1:kp-1) = Ypp;     yzad(kp:n) = Ypp + 0.04;
    e(1:kp-1) = 0;

%     r0 = K_pid;
%     r1 = 0;
%     r2 = 0;

    % parametry r regulatora PID
    r0 = K_pid*(1+T/(2*Ti)+Td/T);
    r1 = K_pid*(T/(2*Ti)-2*Td/T-1);
    r2 = K_pid*Td/T;

    for k = kp:n
        % symulacja obiektu
        y(k) = symulacja_obiektu12y_p3(u(k-5), u(k-6), ...
                                y(k-1), y(k-2));
        
        % uchyb regulacji
        e(k) = yzad(k)-y(k);
        
        % sygnał sterujący regulatora PID
        u(k) = r2*e(k-2) + r1*e(k-1) + r0*e(k) + u(k-1);
    
        du = u(k) - u(k-1);

        % ograniczenia wartości sygnału sterującego
        if u(k) < Umin
            u(k) = Umin;
        elseif u(k) > Umax
            u(k) = Umax;
        end

        % ograniczenia szybkości zmian sygnału sterującego
%         if du > dumax
%             u(k) = u(k-1) + dumax;
%         elseif du < -dumax
%             u(k) = u(k-1) - dumax;
%         end        
    end

    % wskaźnik jakości regulacji E
    E = 0;
    for k = 1 : n
        E = E + (yzad(k)-y(k))^2;
    end

    set(0,'defaultLineLineWidth',1);
    subplot(2, 1, 1)
    stairs(y);
    hold on;
    stairs(yzad);
    title("Algorytm PID  Kp=1.1  Ti=0.8  Td=1")
    legend("y(k)", "yzad")
    grid on

    subplot(2, 1, 2)
    plot(1:n, u)
    legend("u(k)")
    grid on

end
