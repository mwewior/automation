%% dane

%                   4.3 
% G(s) = ------------------------ * e^{-5s}
%       9.2988s^2 + 6.81s + 1

clear
K = 4.3;
T0 = 5;
T1 = 1.89;
T2 = 4.92;


licz_c = K*exp(-T0);
mian_c = [T1*T2 T1+T2 1];
Tp = 0.5;

[licz_d, mian_d] = c2dm(licz_c, mian_c, Tp, 'zoh');
% po uwzględnieniu z^-10
licz_dz = [zeros(1,9) licz_d];
mian_dz = [mian_d zeros(1,9)];

%pierwszy wariant
[A_1, B_1, C_1, D] = tf2ss(licz_c, mian_c);
% drugi wariant:
Ac = transpose(A_1);
Bc = transpose(C_1);
Cc = transpose(B_1);
% sys_c = ss(Ac, Bc, Cc, D);

[Az1, Bz1, Cz1, Dz] = tf2ss(licz_d, mian_d); % do uwzględnienia z^-10 zamiast _d będzie _dz
% drugi wariant
Az = transpose(Az1);
Bz = transpose(Cz1);
Cz = transpose(Bz1);
% sys_d = ss(Az, Bz, Cz, Dz, 0.5);


