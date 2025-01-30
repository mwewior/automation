%% dane

%           {s^2 + 6s + 5}
% G(s) = ------------------------
%       {s^3 + 21s^2 + 146s + 336}

clear

%% zadanie 1

licz_c = [1 6 5];
mian_c = [1 21 146 336];
Tp = 0.5;

[licz_d, mian_d] = c2dm(licz_c, mian_c, Tp, 'zoh');

% zera_c = roots(licz_c);
% bieguny_c = roots(mian_c);
% zera_d = roots(licz_d);
% bieguny_d = roots(mian_d);


%% zadanie 2

[A_1, B_1, C_1, D] = tf2ss(licz_d, mian_d);
A_2 = transpose(A_1);
B_2 = transpose(C_1);
C_2 = transpose(B_1);


%% zadanie 3
start_x = [0 0 0];
% start_x = [-2 1 3];
% start_x = [-1; -2; -3];


%% zadanie 4

syms z zb k1 k2 k3
I = eye(3);
Ksym = [k1, k2, k3];
M = det(z*I - A_1 + B_1*Ksym); m = coeffs(M, z);
W = expand((z-zb)^3); w = coeffs(W, z);
ksym1 = solve(m(3) - w(3) == 0, k1); k1 = sym2poly(ksym1);
Ksym2 = solve(m(2) - w(2) == 0, k2); k2 = sym2poly(Ksym2);
ksym3 = solve(m(1) - w(1) == 0, k3); k3 = sym2poly(ksym3);

zb_val = 0.03;

K = zeros(1, 3);
K(1) = polyval(k1, zb_val);
K(2) = polyval(k2, zb_val);
K(3) = polyval(k3, zb_val);

%sprawdzenie numeryczne
Pr = [zb_val; zb_val; zb_val];
K0 = acker(A_1, B_1, Pr);

%% zadanie 5

% zb_val = 0.4;
% zb_val = 0.07;
% zb_val = 0.03;
% zb_val = 0.01;
% zb_val = -0.134;


%% zadanie 6

zo = 0.15;

Po = [zo; zo; zo];
L = acker(A_1', C_1', Po);


%% zadanie 7



%% zadanie 8


