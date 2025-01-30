function [u1k, u2k, u3k, u4k] = pid_mimo(T, k, U, Ypom, Yzad, Pid1, Pid2, Pid3)

u1_prev = U(k-1, 1);
u2_prev = U(k-1, 2);
u3_prev = U(k-1, 3);
u4_prev = U(k-1, 4);
% u1_prev = U(1); u2_prev = U(2); u3_prev = U(3); u4_prev = U(4);

y1 = Ypom(:,1);
y2 = Ypom(:,2);
y3 = Ypom(:,3);

yzad1 = Yzad(:,1);
yzad2 = Yzad(:,2);
yzad3 = Yzad(:,3);


K_pid1 = Pid1(1); Ti1 = Pid1(2); Td1 = Pid1(3);
K_pid2 = Pid2(1); Ti2 = Pid2(2); Td2 = Pid2(3);
K_pid3 = Pid3(1); Ti3 = Pid3(2); Td3 = Pid3(3);


% parametry r regulatorów PID
r0_1 = K_pid1*(1+T/(2*Ti1)+Td1/T);
r1_1 = K_pid1*(T/(2*Ti1)-2*Td1/T-1);
r2_1 = K_pid1*Td1/T;

r0_2 = K_pid2*(1+T/(2*Ti2)+Td2/T);
r1_2 = K_pid2*(T/(2*Ti2)-2*Td2/T-1);
r2_2 = K_pid2*Td2/T;

r0_3 = K_pid3*(1+T/(2*Ti3)+Td3/T);
r1_3 = K_pid3*(T/(2*Ti3)-2*Td3/T-1);
r2_3 = K_pid3*Td3/T;


% uchyby regulacji
e1 = yzad1-y1;
e2 = yzad2-y2;
e3 = yzad3-y3;


%sygnał sterujący regulatorów PID

%{
klasycznie mieliśmy:
    u(k) = r2*e(k-2) + r1*e(k-1) + e0*e(k) + u(k-1)
           <--------- out_pid ---------->

dla wielowymiarowego regulatora nie możemy tak zrobić
musimy rozdzielić część powiązaną z uchybem od sterowania
dlatego pojawiają się zmienne out_pidX

regulator będzie wyglądał w następujący sposób:
    uX(k) = uX(k-1) + w1*out_pid1 + ... + wn*out_pidn

%}

out_pid1 = r2_1*e1(k-2) + r1_1*e1(k-1) + r0_1*e1(k);
out_pid2 = r2_2*e2(k-2) + r1_2*e2(k-1) + r0_2*e2(k);
out_pid3 = r2_3*e3(k-2) + r1_3*e3(k-1) + r0_3*e3(k);


%% TODO
% dopasować odpowiednie wyjścia do dobrych wejść!

u1k = u1_prev + (out_pid1*0.15 + out_pid2*1 + out_pid3*0.75)/1.9;
u2k = u2_prev + (out_pid1*3.5 + out_pid2*2 + out_pid3*0.8)/6.3;
u3k = u3_prev + (out_pid1*2.5 + out_pid2*0.3 + out_pid3*1)/3.8;
u4k = u4_prev + (out_pid1*1.5 + out_pid2*2.5 + out_pid3*1.9)/5.9;

end
