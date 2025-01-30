clear all

%% parametry algorytmu DMC
D = 200;
N = 200;
Nu = 2;
lambda = 1;



%% inicjalizacja parametrów symulacji
kp = 7;
kk = 2500;
lRegul = 3;



%% inicjalizacja stałych
Umin = -1;
Umax = 1;
Ypp = 0;
Upp = 0;
Uk = 0.01;



%% inicjalizacja sterowania i wyjscia symulacji
for r = 1:lRegul
    u{r} = ones(1, kk)*Upp;
end
y(1:kp-1) = Ypp;        
y(kp:kk) = 0;
uResult(1:kp-1) = Upp;
uResult(kp:kk) = 0;
yzad(1:kp-1) = Ypp;     
yzad(kp:kk) = -0.1;
yzad(400:kk) = -0.9;
yzad(800:kk) = -0.5;
yzad(1200:kk) = -0.1;
yzad(1600:kk) = 0.07;



%% skok 
% for r = 1:lRegul
%     s{r} = odp_skokowa(Ypp, Upp, 1);
% end

Ypp1=-2.24597;  Upp1=-0.91;
Ypp2=-0.31804;  Upp2=-0.3;
Ypp3=0.0727849; Upp3=0.9;

s{1} = odp_skokowa(Ypp1, Upp1, Upp1+0.01);
s{2} = odp_skokowa(Ypp2, Upp2, Upp2+0.01);
s{3} = odp_skokowa(Ypp3, Upp3, Upp3+0.01);



%% macierz M
for r = 1:lRegul
    m = zeros(N, Nu);
    for i = 1 : Nu
        m(i : N, i) = s{r}(1 : (N - i + 1))';
    end
    M{r} = m;
end



%% macierz Mp
for r = 1:lRegul
    mp = zeros(N, D-1);
    for i = 1 : N
       for j = 1 : D-1
          if i+j <= D
             mp(i, j) = s{r}(i+j) - s{r}(j);
          else
             mp(i, j) = s{r}(D) - s{r}(j);
          end    
       end
    end
    Mp{r} = mp;
end



%% obliczam K
I = eye(Nu);
for r = 1:lRegul
    K{r} = ((M{r}'*M{r} + lambda*I)^(-1))*M{r}';
end
  


%% oszczędna wersja DMC - parametry
for r = 1:lRegul
    Ke{r} = sum(K{r}(1,:));
    ku{r} = K{r}(1, :)*Mp{r};
end



%% symulacja
for k = kp:kk
    % wagi
    w = wagi(uResult(k-1));

    % obiekt
    y(k) = symulacja_obiektu12y_p3(uResult(k-5), uResult(k-6), y(k-1), y(k-2));
    
    % uchyb
    e = yzad(k) - y(k);

    for r = 1:lRegul
        elem = 0;
        for j = 1 : D-1
            if k-j <= 1
                du = 0;
            else
                du = u{r}(k-j) - u{r}(k-j-1);
            end
            elem = elem + ku{r}(j)*du;
        end

        % optymalny przyrost sygnału sterującego w chwili k (du(k|k))
        dukk = Ke{r} * e - elem;

        % prawo regulacji
        u{r}(k) = dukk + u{r}(k-1);

        uResult(k) = uResult(k) + w(r)*u{r}(k);
    end
    uResult(k) = uResult(k) / sum(w);

    % ograniczenia sterowania
    if uResult(k) > Umax
        uResult(k) = Umax;
    elseif uResult(k) < Umin
        uResult(k) = Umin;
    end   
end


 
%% wykresy 
set(0,'defaultLineLineWidth',1);
set(0,'defaultStairLineWidth',1);

plot(y)
grid on
hold on
stairs(yzad, '--')
legend("y(k)", "yzad(k)")
print('wykresy_png\DMC_rozmyty_3_reg.png', '-dpng', '-r400')