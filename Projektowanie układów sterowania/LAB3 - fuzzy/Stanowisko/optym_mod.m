clear
%% Optymalizacja modelu

% fmincon
apr = "III";

objective = @(x) aproksymacja (x(1), x(2), x(3));
x_initial = [10, 250, 0.27];
lb = [0, 0, 0.2];
ub = [100, 100, 0.3];

nonlcon = [];

options = optimset('Display', 'iter'); % Display the optimization process
[x_optimal, fval] = fmincon(objective, x_initial, [], [], [], [], lb, ub, nonlcon, options);


wizualizacja = 1;


%% Wizualizacja
if wizualizacja == 1
    
        handler = load("s_nieliniowy.mat");
        
        if(strcmp(apr, "I"))
            sp = odpskokowe(handler.pomiar20, -7);
        elseif(strcmp(apr, "II"))
            sp = odpskokowe(handler.pomiar70, 10);
        elseif(strcmp(apr, "III"))
            sp = odpskokowe(handler.pomiar80, 10);
        end


    
    % liczba eulera
    eu = exp(1);
    
    % stałe wyliczone przez fmincon
    T1 = round(x_optimal(1));
    T2 = round(x_optimal(2));
    K = x_optimal(3);
    
    % opoznienie dla pomiaru sp wynosi 17s
    Td = 13;

    duration = length(sp);
    
    
    % wyliczenie współczynników
    alfa1 = eu^(-1/T1);
    alfa2 = eu^(-1/T2);
    a1 = -alfa1 - alfa2;
    a2 = alfa1*alfa2;
    b1 = (K/(T1-T2))*(T1*(1-alfa1)-T2*(1-alfa2));
    b2 = (K/(T1-T2))*(alfa1*T2*(1-alfa2)-alfa2*T1*(1-alfa1));
    
    % inicjalizacja modelu
    ymod(1:duration) = 0;
    u(1:9) = 1;
    u(10:duration) = 1;
    e(1:duration) = 0;
    err = 0;
    
    for k=1:duration
        if(k>Td+3)
            ymod(k) = b1*u(k-Td-1) + ...
                b2*u(k-Td-2) - ...
                a1*ymod(k-1) - ...
                a2*ymod(k-2);

            e(k) = sp(k) - ymod(k);
            err = err + e(k)^2;
            if(isnan(err))
                        err = 1000000000;
            end
        end
        
    end


    % shift vector
    sp = sp(Td+1:end);
    ymod = ymod(Td+1:end);
    %
    stairs(sp);
    hold on;
    stairs(ymod);
%     legend('sp', 'ymod');
    grid on;
    %}
    
end  

%% Funkcja błędu:

% funkcja bledu dla fmincon
function err = aproksymacja(T1, T2, K)
    apr = "I";

    % opoznienie
    Td = 10;

    % kiedy T1 == T2 wspolczynniki wychodza NaN
    if(T1 ~= T2)

        handler = load("s_nieliniowy.mat");
        
        if(strcmp(apr, "I"))
            sp = odpskokowe(handler.pomiar20, -7);
        elseif(strcmp(apr, "II"))
            sp = odpskokowe(handler.pomiar70, 10);
        elseif(strcmp(apr, "III"))
            % TODO
        end
    
        % czas trwania procesu
        duration = length(sp);

    
        % liczba eulera
        eu = exp(1);
    
        % wyliczenie stałych
        alfa1 = eu^(-1/T1);
        alfa2 = eu^(-1/T2);
        a1 = -alfa1 - alfa2;
        a2 = alfa1*alfa2;
        b1 = (K/(T1-T2))*(T1*(1-alfa1)-T2*(1-alfa2));
        b2 = (K/(T1-T2))*(alfa1*T2*(1-alfa2)-alfa2*T1*(1-alfa1));

    
        % inicjalizacja modelu
        ymod(1:duration) = 0;
        u(1:9) = 1;
        u(10:duration) = 1;
        e(1:duration) = 0;
        err = 1000000000;
        
        
        % fmincon czasem wylicza niepoprawne wspolczynniki
        if(~isnan(a1) && ~isnan(a2) && ~isnan(b1) && ~isnan(b2))

            err = 0;

            for k=1:duration
                if(k>Td+3)
                    ymod(k) = b1*u(k-Td-1) + ...
                        b2*u(k-Td-2) - ...
                        a1*ymod(k-1) - ...
                        a2*ymod(k-2);
        
                    e(k) = sp(k) - ymod(k);
                    err = err + e(k)^2;
                    if(isnan(err))
                        err = 10000000000000000000000000;
                     else
                         err=100000;
                    end

                end
        
            end
        end
    end
end


function [s] = odpskokowe(handle, skoku)
    Tp = 10;
    for k = 1:length(handle)
            % if k > Tp
                s(k) = (handle(k)-handle(1))/skoku;
            
            % end
    end

end
