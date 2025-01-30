function [s, E] = get_s_approx(Upp, D, len, y)

yaprox(1:100) = 0;
uaprox(1:100) = 0;
uaprox(101:len+100) = Upp;


for i=101:len+100
    
    yaprox(i) = obiekt_aproksymacja(i, uaprox, yaprox);

end

e = (yaprox(101:100+D) - y(101:100+D));
E = e * e';

% s_aprox = (yaprox(101:D+100)-yaprox(1)) / 30;
% s = s_aprox;

s_full = (yaprox(101:end) - yaprox(1)) / Upp;
s = s_full;



% figure;
% stairs(new_y, '--'); hold on;
% stairs(yaprox + y(1)); grid on;
% title(sprintf('E = %f, T1 = %d, T2 = %d', E, T1, T2));
figure;
% stairs(s_aprox); hold on; grid on;
stairs(s_full, '--'); hold on; grid on;
stairs(s_full); hold on; grid on;

end