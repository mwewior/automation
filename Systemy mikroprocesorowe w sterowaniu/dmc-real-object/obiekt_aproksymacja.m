function ymod_k = obiekt_aproksymacja(k, u, y)

eu = exp(1);

T1 = 7;
T2 = 77;
K = 0.307368246341753;

% opoznienie obiektu wynosi 17s
Td = 17;

% wyliczenie współczynników
alfa1 = eu^(-1/T1);
alfa2 = eu^(-1/T2);
a1 = -alfa1 - alfa2;
a2 = alfa1*alfa2;
b1 = (K/(T1-T2))*(T1*(1-alfa1)-T2*(1-alfa2));
b2 = (K/(T1-T2))*(alfa1*T2*(1-alfa2)-alfa2*T1*(1-alfa1));


ymod_k = b1*u(k-Td-1) + ...
    b2*u(k-Td-2) - ...
    a1*y(k-1) - ...
    a2*y(k-2);

end

