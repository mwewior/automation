clear;



%% TRYB

% tryb = 'pp';
% tryb = 'odp_skok';
tryb = 'pid';
% tryb = 'dmc';



%% INIT


T = 0.5;
n = 1000;
start = 10;

len = 250+start-1;


nu = 4;     % 4 wejścia
ny = 3;     % 3 wyjścia


u1 = zeros(n, 1);
u2 = zeros(n, 1);
u3 = zeros(n, 1);
u4 = zeros(n, 1);
U = [u1, u2, u3, u4];

y1 = zeros(n, 1);
y2 = zeros(n, 1);
y3 = zeros(n, 1);
Y = [y1, y2, y3];

YZ1 = 1;
YZ2 = 1.2;
YZ3 = 0.8;
yzad1(1:start-1, 1) = 0; yzad1(start:n, 1) = YZ1;
yzad2(1:start-1, 1) = 0; yzad2(start:n, 1) = YZ2;
yzad3(1:start-1, 1) = 0; yzad3(start:n, 1) = YZ3;
YZAD = [yzad1, yzad2, yzad3];


%% PUNKT PRACY

if strcmp(tryb, 'pp')

    for k = start:n
        
        [y1(k),y2(k),y3(k)] = symulacja_obiektu12y_p4( ...
            u1(k-1), u1(k-2), u1(k-3), u1(k-4), ...
            u2(k-1), u2(k-2), u2(k-3), u2(k-4), ...
            u3(k-1), u3(k-2), u3(k-3), u3(k-4), ...
            u4(k-1), u4(k-2), u4(k-3), u4(k-4), ...
            ...
            y1(k-1), y1(k-2), y1(k-3), y1(k-4), ...
            y2(k-1), y2(k-2), y2(k-3), y2(k-4), ...
            y3(k-1), y3(k-2), y3(k-3), y3(k-4) ...
        );
    
    end
    
    f_pp = figure;
    grid on;
    hold on;
    legenda = {};
    stairs(u1); legenda{1} = "u1";
    stairs(u2); legenda{2} = "u2";
    stairs(u3); legenda{3} = "u3";
    stairs(u4); legenda{4} = "u4";
    stairs(y1); legenda{5} = "y1";
    stairs(y2); legenda{6} = "y2";
    stairs(y3); legenda{7} = "y3";
    legend(legenda, 'Location', 'southeast');

end



%% ODPOWIEDŹ SKOKOWA

if strcmp(tryb, 'odp_skok') || strcmp(tryb, 'dmc') 


    S = cell(len, 1);
    nullS = zeros(3, 4);
    %            ny, nu


    for i = 1:len
        S{i} = nullS;
    end


    for wejscie = 1:nu
    
        if      wejscie == 1
            u1(start:n) = 1;

        elseif  wejscie == 2
            u2(start:n) = 1;
        
        elseif  wejscie == 3
            u3(start:n) = 1;
        
        elseif  wejscie == 4
            u4(start:n) = 1;
        
        end


        for k = start:len+1
    
            [y1(k),y2(k),y3(k)] = symulacja_obiektu12y_p4( ...
                u1(k-1), u1(k-2), u1(k-3), u1(k-4), ...
                u2(k-1), u2(k-2), u2(k-3), u2(k-4), ...
                u3(k-1), u3(k-2), u3(k-3), u3(k-4), ...
                u4(k-1), u4(k-2), u4(k-3), u4(k-4), ...
                ...
                y1(k-1), y1(k-2), y1(k-3), y1(k-4), ...
                y2(k-1), y2(k-2), y2(k-3), y2(k-4), ...
                y3(k-1), y3(k-2), y3(k-3), y3(k-4) ...
            );


            p = k-start+1;
    
            S{p}(1, wejscie) = y1(k);
            S{p}(2, wejscie) = y2(k);
            S{p}(3, wejscie) = y3(k);

    
        end

        [u1, u2, u3, u4, y1, y2, y3] = zerowanie(n);

    end


    for k=1:len-start+1

        p = k;

        % kolumna 1 : Sp^(ny 1)
        S11(p) = S{k}(1, 1); 
        S21(p) = S{k}(2, 1); 
        S31(p) = S{k}(3, 1);

        % kolumna 2 : Sp^(ny 2)
        S12(p) = S{k}(1, 2); 
        S22(p) = S{k}(2, 2); 
        S32(p) = S{k}(3, 2);

        % kolumna 3 : Sp^(ny 3)
        S13(p) = S{k}(1, 3); 
        S23(p) = S{k}(2, 3); 
        S33(p) = S{k}(3, 3);

        % kolumna 4 : Sp^(ny 4)
        S14(p) = S{k}(1, 4); 
        S24(p) = S{k}(2, 4); 
        S34(p) = S{k}(3, 4);

    end


    if strcmp(tryb, 'odp_skok')

    close all;
    f_odps = figure;
    
    % kolumna 1
    subplot(3, 4, 1)
    stairs(S11); grid on; title("y_1(u_1)"); ylabel("y_1", Rotation=pi/2); xlabel("k");
    subplot(3, 4, 5)
    stairs(S21); grid on; title("y_2(u_1)"); ylabel("y_2", Rotation=pi/2); xlabel("k");
    subplot(3, 4, 9)
    stairs(S31); grid on; title("y_3(u_1)"); ylabel("y_3", Rotation=pi/2); xlabel("k");

    % kolumna 2
    subplot(3, 4, 2)
    stairs(S12); grid on; title("y_1(u_2)"); ylabel("y_1", Rotation=pi/2); xlabel("k");
    subplot(3, 4, 6)
    stairs(S22); grid on; title("y_2(u_2)"); ylabel("y_2", Rotation=pi/2); xlabel("k");
    subplot(3, 4, 10)
    stairs(S32); grid on; title("y_3(u_2)"); ylabel("y_3", Rotation=pi/2); xlabel("k");

    % kolumna 3
    subplot(3, 4, 3)
    stairs(S13); grid on; title("y_1(u_3)"); ylabel("y_1", Rotation=pi/2); xlabel("k");
    subplot(3, 4, 7)
    stairs(S23); grid on; title("y_2(u_3)"); ylabel("y_2", Rotation=pi/2); xlabel("k");
    subplot(3, 4, 11)
    stairs(S33); grid on; title("y_3(u_3)"); ylabel("y_3", Rotation=pi/2); xlabel("k");

    % kolumna 4
    subplot(3, 4, 4)
    stairs(S14); grid on; title("y_1(u_4)"); ylabel("y_1", Rotation=pi/2); xlabel("k");
    subplot(3, 4, 8)
    stairs(S24); grid on; title("y_2(u_4)"); ylabel("y_2", Rotation=pi/2); xlabel("k");
    subplot(3, 4, 12)
    stairs(S34); grid on; title("y_3(u_4)"); ylabel("y_3", Rotation=pi/2); xlabel("k");


%     clear u1 u2 u3 u4 y1 y2 y3

    end
    

    clear S11 S21 S31 S12 S22 S32 S13 S23 S33 S14 S24 S34

end


%% PID

if strcmp(tryb, 'pid')

    %       K       Ti      Td
    Pid1 = [0.7,    9e3,      0];
    Pid2 = [0.7,    9e3,      0];
    Pid3 = [0.7,    9e3,      0];
    
    for k=start:n
        
        [y1(k),y2(k),y3(k)] = symulacja_obiektu12y_p4( ...
            u1(k-1), u1(k-2), u1(k-3), u1(k-4), ...
            u2(k-1), u2(k-2), u2(k-3), u2(k-4), ...
            u3(k-1), u3(k-2), u3(k-3), u3(k-4), ...
            u4(k-1), u4(k-2), u4(k-3), u4(k-4), ...
            ...
            y1(k-1), y1(k-2), y1(k-3), y1(k-4), ...
            y2(k-1), y2(k-2), y2(k-3), y2(k-4), ...
            y3(k-1), y3(k-2), y3(k-3), y3(k-4) ...
        );

%         U_km1 = [u1(k-1), u2(k-1), u3(k-1), u4(k-1)];
        Y = [y1, y2, y3];
        YZAD = [yzad1, yzad2, yzad3];

        [u1(k), u2(k), u3(k), u4(k)] = pid_mimo(T, k, U, Y, YZAD, Pid1, Pid2, Pid3);
        U = [u1, u2, u3, u4];

    end


    f_pid_y = figure;
    hold on;
    stairs(y1); 
    stairs(y2); 
    stairs(y3); 
    grid on;
    legenda_y = {};
    stairs(y1, 'Color', [0.000 0.447 0.741]); legenda_y{1} = "y1";
    stairs(y2, 'Color', [0.850 0.325 0.098]); legenda_y{2} = "y2";
    stairs(y3, 'Color', [0.929 0.694 0.125]); legenda_y{3} = "y3";
    stairs(yzad1, '-- ', 'Color', [0.000 0.447 0.741]); legenda_y{4} = "yzad1";
    stairs(yzad2, '-- ', 'Color', [0.850 0.325 0.098]); legenda_y{5} = "yzad2";
    stairs(yzad3, '-- ', 'Color', [0.929 0.694 0.125]); legenda_y{6} = "yzad3";
    legend(legenda_y, 'Location', 'southeast');
    
    f_pid_u = figure;
    hold on;
    stairs(u1);
    stairs(u2);
    stairs(u3);
    stairs(u4);
    grid on;
    legenda_u = {};
    stairs(u1, 'Color', [0.000 0.447 0.741]); legenda_u{1} = "u1";
    stairs(u2, 'Color', [0.850 0.325 0.098]); legenda_u{2} = "u2";
    stairs(u3, 'Color', [0.929 0.694 0.125]); legenda_u{3} = "u3";
    stairs(u4, 'Color', [0.494 0.184 0.556]); legenda_u{4} = "u4";
    legend(legenda_u, 'Location', 'southeast');

end


%% DMC

if strcmp(tryb, 'dmc')

    D  = 220;
    N  = 120;
    Nu = 40;
    

    lambda1 = 2;
    lambda2 = 2;
    lambda3 = 2;
    lambda4 = 4;
    
    Lambda = {lambda1, lambda2, lambda3, lambda4};
    

    mi1 = 0.01;
    mi2 = 0.005;
    mi3 = 0.01;
    
    Mi = {mi1, mi2, mi3};


    [K, Mp] = dmc_mimo_offline(S, D, N, ny, Nu, nu, Mi, Lambda);

    Y0 = zeros(n,3);
    Y02 = zeros(n,3);

    for k=start:n
    
        [y1(k),y2(k),y3(k)] = symulacja_obiektu12y_p4( ...
                u1(k-1), u1(k-2), u1(k-3), u1(k-4), ...
                u2(k-1), u2(k-2), u2(k-3), u2(k-4), ...
                u3(k-1), u3(k-2), u3(k-3), u3(k-4), ...
                u4(k-1), u4(k-2), u4(k-3), u4(k-4), ...
                ...
                y1(k-1), y1(k-2), y1(k-3), y1(k-4), ...
                y2(k-1), y2(k-2), y2(k-3), y2(k-4), ...
                y3(k-1), y3(k-2), y3(k-3), y3(k-4) ...
        );
        
        Y = [y1, y2, y3];
        YZAD = [yzad1, yzad2, yzad3];

        [u1(k), u2(k), u3(k), u4(k), Y0k] = dmc_mimo(...
            k, U, Y, YZAD, D, N, ny, nu, K, Mp ...
        );

        U = [u1, u2, u3, u4];

        Y0(k,:) = [Y0k(1) Y0k(2) Y0k(3)];

    end

    f_dmc_y = figure;
    hold on;
    stairs(y1); 
    stairs(y2); 
    stairs(y3); 
    grid on;
    legenda_y = {6};
    stairs(y1, 'Color', [0.000 0.447 0.741]); %legenda_y{1} = "y1";
    stairs(y2, 'Color', [0.850 0.325 0.098]); %legenda_y{2} = "y2";
    stairs(y3, 'Color', [0.929 0.694 0.125]); %legenda_y{3} = "y3";
    stairs(yzad1, '-.', 'Color', [0.000 0.447 1]); %legenda_y{4} = "yzad1";
    stairs(yzad2, '-.', 'Color', [1 0.325 0.098]); %legenda_y{5} = "yzad2";
    stairs(yzad3, '-.', 'Color', [0.929 0.7 0.125]); %legenda_y{6} = "yzad3";
    legenda_y{1} = "y1";
    legenda_y{2} = "y2";
    legenda_y{3} = "y3";
    legenda_y{4} = "yzad1";
    legenda_y{5} = "yzad2";
    legenda_y{6} = "yzad3";
    legend(legenda_y, 'Location', 'southeast');
    
    f_dmc_u = figure;
    hold on;
    stairs(u1);
    stairs(u2);
    stairs(u3);
    stairs(u4);
    grid on;
    legenda_u = {};
    stairs(u1, 'Color', [0.000 0.447 0.741]); legenda_u{1} = "u1";
    stairs(u2, 'Color', [0.850 0.325 0.098]); legenda_u{2} = "u2";
    stairs(u3, 'Color', [0.929 0.694 0.125]); legenda_u{3} = "u3";
    stairs(u4, 'Color', [0.494 0.184 0.556]); legenda_u{4} = "u4";
    legend(legenda_u, 'Location', 'southeast');

end



%% INNE FUNKCJE


function [u1, u2, u3, u4, y1, y2, y3] = zerowanie(n)

    u1 = zeros(n, 1);
    u2 = zeros(n, 1);
    u3 = zeros(n, 1);
    u4 = zeros(n, 1);
    y1 = zeros(n, 1);
    y2 = zeros(n, 1);
    y3 = zeros(n, 1);

end

%% INFO

% [Y1k,Y2k,Y3k]=symulacja_obiektu12y_p4(...
% 	U1km1,U1km2,U1km3,U1km4, ...
% 	U2km1,U2km2,U2km3,U2km4, ...
% 	U3km1,U3km2,U3km3,U3km4, ...
% 	U4km1,U4km2,U4km3,U4km4, ...
% 	Y1km1,Y1km2,Y1km3,Y1km4, ...
% 	Y2km1,Y2km2,Y2km3,Y2km4, ...
% 	Y3km1,Y3km2,Y3km3,Y3km4);

% [y1(k),y2(k),y3(k)] = symulacja_obiektu12y_p4( ...
%     u1(k-1), u1(k-2), u1(k-3), u1(k-4), ...
%     u2(k-1), u2(k-2), u2(k-3), u2(k-4), ...
%     u3(k-1), u3(k-2), u3(k-3), u3(k-4), ...
%     u4(k-1), u4(k-2), u4(k-3), u4(k-4), ...
%     ...
%     y1(k-1), y1(k-2), y1(k-3), y1(k-4), ...
%     y2(k-1), y2(k-2), y2(k-3), y2(k-4), ...
%     y3(k-1), y3(k-2), y3(k-3), y3(k-4) ...
% );
