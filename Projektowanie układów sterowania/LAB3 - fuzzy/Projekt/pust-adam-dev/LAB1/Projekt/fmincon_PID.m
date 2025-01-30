%% Optymalizacja nastawów PID

%fmincon
objective = @(x) PID (x(1), x(2), x(3));
x_initial = [1.25; 6; 4.2844];
lb = [1.20, 5, 4.2843];
ub = [1.35, 1000000, 500];

nonlcon = [];

options = optimoptions('fmincon', 'Display', 'iter');
[x_optimal, fval] = fmincon(objective, x_initial, [], [], [], [], lb, ub, nonlcon, options);


function E = PID(K_pid, Ti, Td)
    % fmincon sprawdza inkrementując, także odwrotność Ti
    
    Upp = 0.9;
    Ypp = 3.5;

    n = 500;


    % inicjalizacja:
    T = 0.5;
    start = 20;
    u(1:19) = Upp;
    y(1:19) = Ypp;
    yzad(1:19) = Ypp;
    yzad(20:n) = Ypp + 0.4;
    e(1:19) = 0;
    
    
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
    end

    % wskaźnik jakości regulacji
    E = 0;
    for k = 1 : n
        E = E + (yzad(k)-y(k))^2;
    end
end


