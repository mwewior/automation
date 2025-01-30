t = out.tout;
% um = out.u_mierz.signals.values;

% umierz = stairs(out.tout, out.u_mierz.signals.values);
% hold on;
% uest = stairs(out.tout, out.u_est.signals.values);
% hold on;
% xlabel('t');
% ylabel('u(k)  ', Rotation=pi/2);
% legend([umierz, uest],{'u(k) mierzone', 'u(k) estymowane'}, 'Location', 'southeast');
 
x1 = stairs(out.tout, out.x1_mierz.signals.values);
hold on
x1e = stairs(out.tout, out.x1_est.signals.values);
hold on

% x2 = stairs(out.tout, out.x2_mierz.signals.values);
% hold on;
% x2e = stairs(out.tout, out.x2_est.signals.values);
% hold on;

% x3 = stairs(out.tout, out.x3_mierz.signals.values);
% hold on;
% x3e = stairs(out.tout, out.x3_est.signals.values);
% hold on;

% xlabel('t');
% ylabel('zmienne stanu');

% legend([x1, x2, x3],{'x1(k)', 'x2(k)', 'x3(k)'}, 'Location', 'southeast');

% legend([x1, x1e],{'x1(k) mierzone', 'x1(k) estymowane'}, 'Location', 'southeast');
% legend([x2, x2e],{'x2(k) mierzone', 'x2(k) estymowane'}, 'Location', 'southeast');
% legend([x3, x3e],{'x3(k) mierzone', 'x3(k) estymowane'}, 'Location', 'southeast');
grid on;

