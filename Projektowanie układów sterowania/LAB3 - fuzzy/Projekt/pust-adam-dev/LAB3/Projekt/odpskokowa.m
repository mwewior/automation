clear
n = 6;
duration = 50;
u(1:n, 1:duration) = 0;
y(1:n, 1:duration) = 0;
Kstat(1:n) = 0;
start = 7;


% symulacja
for skok=1:n
    u(skok, 1:duration) = (skok-2)*0.1;
    for k=start:duration
        y(skok, k) = symulacja_obiektu12y_p3(u(skok, k-5), u(skok, k-6), y(skok, k-1), y(skok, k-2));
    end
    stairs(y(skok, :));
    hold on;
    Kstat(skok) = (y(skok, duration) - y(skok, 1)) / u(skok, duration);
end