

load zad2_pomiary.mat;

displayMeasurement(z2_27_20, z2_27_35, z2_27_40);

isTogether = 1;
displayS(isTogether);

% ciekawe kim byl ten Skokow
function [sp, sm, spp] = odpSkokowa()
    load zad2_pomiary.mat;

    % przypisanie pomiarów do zmiennych przeliczanych
    pomiar35 = z2_27_35;
    pomiar20 = z2_27_20;
    pomiar40 = z2_27_40;
    
    for k = 1:300
        if k > 10
            sp(k-10) = (pomiar35(k)-pomiar35(10))/8;
        
        end
    end
    
    for k = 1:300
        if k > 10
            sm(k-10) = (pomiar20(k)-pomiar20(10))/-7;
        
        end
    end
    
    for k = 1:220
        % opoznienie w pomiarach wymaga przesunięcia o offset 10
        spp(1:10) = 0;
        if k > 10
            spp(k) = (pomiar40(k)-pomiar40(10))/13;
        
        end
    end
end


function displayMeasurement(pomiar1, pomiar2, pomiar3)
    figure;
    stairs(pomiar1); hold on;
    stairs(pomiar2); hold on;
    stairs(pomiar3); hold on;
    grid on;

    legend('20', '35', '40');
    
end


function displayS(isTogether)
    [sp, sm, spp] = odpSkokowa();

    if(isTogether)
        figure;
        stairs(sp, '*-');
        grid on;
        hold on;
        
        stairs(spp, '*-');
        hold on;
        
        stairs(sm, '*-');

        legend('35', '40', '20');
    else
        figure;
        stairs(sp, '*-');
        title('35');
        grid on;
        
        figure;
        stairs(spp, '*-');
        title('40');
        grid on;
        
        figure;
        stairs(sm, '*-');
        title('20');
        grid on;

    end
end
