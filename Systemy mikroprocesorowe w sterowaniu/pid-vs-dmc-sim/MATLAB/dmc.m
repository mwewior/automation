S = load('odp_skokowa.mat');
s = S.y(110:end)/1000;

D = 50;
N = 20;
Nu = 10;
lambda = 1;

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
            s(c+r) = s(D);
        elseif c > D
            s(c) = s(D);
        end

        Mp(r, c) = s(c+r) - s(c); 


    end

end


K = (M'*M + lambda*eye(Nu, Nu)) \ M';

K_1 = K(1,:);

Ke = 0;
for i = 1:size(K_1, 2)
    Ke = Ke + K_1(i);
end

Kuj = zeros(1, D-1);
for j = 1:D-1
    ku_j = K_1 * Mp(:,j);
    Kuj(j) = ku_j;
end

csvwrite('Kuj_L001', Kuj);