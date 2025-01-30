clear
% ws -> workspace
ws = load('skok30git.mat');
% s = S.y(110:end)/1000;
clear s;
y = ws.y;
u = ws.u;
len = size(ws.y, 2);


D = 250;
N = 100;
Nu = 10;
lambda = 1;


skok_sterowania = 30;
s = get_s_approx(skok_sterowania, D, len, ws.y);

odps = figure;
stairs(y); hold on; grid on;
stairs(s*skok_sterowania+y(1)); grid on; 



M = zeros(N, Nu);

for c = 1:Nu % kolumny

    for r = 1:N % wiersze

        if (r-c+1) <= 0
            M(r, c) = 0;
        elseif (r-c+1) > D
            M(r, c) = s(D);
        else
            M(r, c) = s(r-c+1);
        end

    end

end



Mp = zeros(N, D-1);

for c = 1:D-1 % kolumny

    for r = 1:N % wiersze

        if r+c > D
            scr = s(D);
        else
            scr = s(c+r);
        end

        if c > D
            sc = s(D);
        else
            sc = s(c);
        end

        Mp(r, c) = scr - sc;

    end

end



K = (M'*M + lambda*eye(Nu, Nu)) \ M';

K_1 = K(1,:);


Ke = 0;

for i = 1:size(K_1, 2)  % 1 : N
    Ke = Ke + K_1(i);
end


Kuj = zeros(1, D-1);

for j = 1:D-1
    ku_j = K_1 * Mp(:,j);
    Kuj(j) = ku_j;
end

% figure;
% subplot(2,1,1);
% stairs(y); grid on;
% subplot(2,1,2);
% stairs(s); grid on;

% csvwrite('Kuj_0', Kuj);