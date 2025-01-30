function s = odp_skokowa(Ypp, Upp, Uk)

% inicjalizacja parametrów symulacji
kp = 7;
kk = 800;

% sterowanie
y(1:kp-1) = Ypp;
u(1:kp-1) = Upp;
u(kp:kk+kp) = Uk;

% model
for k = kp:kk+kp
    y(k) = symulacja_obiektu12y_p3(u(k-5), u(k-6), y(k-1), y(k-2));
end
s(1:kk) = (y(kp:kk+kp-1)-ones(1, kk)*Ypp)/(Uk-Upp);

% wykres
figure
set(0,'defaultLineLineWidth',1);
plot(s)
grid on
xlabel("k")
ylabel("y(k)")
legend('show')
title("Skok sterowania u")