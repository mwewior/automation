%% Optymalizacja modelu

%  fmincon dla obiektu
  objective = @(x) aproksymacja (x(1), x(2), x(3));
 x_initial = [90, 100, 0.3];
 lb = [10, 11, 0];
 ub = [150, 151, 1];
 
 nonlcon = [];
 
 options = optimset('Display', 'iter'); % Display the optimization process
 [x_optimal, fval] = fmincon(objective, x_initial, [], [], [], [], lb, ub, nonlcon, options);

% fmincon dla zakłóceń
% objective = @(x) aproksymacja (x(1), x(2), x(3));
% z_initial = [70, 10, 0.15];
% lb = [15, 9, 0.1];
% ub = [150, 151, 0.30];
% 
% nonlcon = [];
% 
% options = optimset('Display', 'iter'); % Display the optimization process
% [z_optimal, fvalz] = fmincon(objective, z_initial, [], [], [], [], lb, ub, nonlcon, options);
% 


wizualizacja = 1;


%% Wizualizacja
if wizualizacja == 1
    load("../pomiary/lab1_pomiary.mat");
         for k = 1:300
             if k > 10
 
                 sp(k-10) = (z2_27_35(k)-z2_27_35(10))/8;
             
             end
         end
         
      duration = size(sp, 2);

%     Sz = load("s_z.mat");
%     s_z = Sz.s_z';
%     duration = size(s_z, 2);
    
    % liczba eulera
    eu = exp(1);
    
    % stałe wyliczone przez fmincon
    T1 = round(x_optimal(1));
    T2 = round(x_optimal(2));
    K = x_optimal(3);
    
    % opoznienie dla pomiaru sp wynosi 17s
    Td = 17;
    
    
    % wyliczenie współczynników
    alfa1 = eu^(-1/T1);
    alfa2 = eu^(-1/T2);
    a1 = -alfa1 - alfa2;
    a2 = alfa1*alfa2;
    b1 = (K/(T1-T2))*(T1*(1-alfa1)-T2*(1-alfa2));
    b2 = (K/(T1-T2))*(alfa1*T2*(1-alfa2)-alfa2*T1*(1-alfa1));
    
    % inicjalizacja modelu
    ymod(1:duration) = 0;
    u(1:19) = 1;
    u(20:duration) = 1;
    e(1:duration) = 0;
    err = 0;
    
    for k=20:duration
        ymod(k) = b1*u(k-Td-1) + ...
            b2*u(k-Td-2) - ...
            a1*ymod(k-1) - ...
            a2*ymod(k-2);
    
        % na wypadek gdyby ktos nie wierzyl fminconowi
        % e(k) = sp(k) - ymod(k);
        % err = err + e(k)^2;
    
    end


    %
    stairs(sp);
    hold on;
    stairs(ymod);
    legend('sp', 'ymod');
    legend('Location','southeast');
    xlabel('k');
    ylabel('wyjście y')
    grid on;
%     matlab2tikz('tikz/odpowiedz_i_model.tex');
    %}
    
end  

%% Funkcja błędu:

% funkcja bledu dla fmincon
function err = aproksymacja(T1, T2, K)

    % opoznienie
    Td = 17;

    % kiedy T1 == T2 wspolczynniki wychodza NaN
    if(T1 ~= T2)

         load("lab1_pomiary.mat");
         pomiary = z2_27_35;
         for k = 1:300
             if k > 10
                 sp(k-10) = (pomiary(k)-pomiary(10))/8;
           
             end
         end

%         Sz = load("s_z.mat");
%         s_z = Sz.s_z;
        
        
        
    
        % czas trwania procesu
         duration = size(sp, 2);
%         duration = size(s_z, 2);
    
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
        u(1:19) = 1;
        u(20:duration) = 1;
        e(1:duration) = 0;
        
        
        % fmincon czasem wylicza niepoprawne wspolczynniki
        if(~isnan(a1) && ~isnan(a2) && ~isnan(b1) && ~isnan(b2))

            err = 0;

            for k=20:duration
                ymod(k) = b1*u(k-Td-1) + ...
                    b2*u(k-Td-2) - ...
                    a1*ymod(k-1) - ...
                    a2*ymod(k-2);
    
                 e(k) = sp(k) - ymod(k);
%                 e(k) = s_z(k) - ymod(k);
                err = err + e(k)^2;
        
            end
        end
    end
end
