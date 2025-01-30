function ymod_k = obiekt_aproksymacja(k, u, y)
% function ymod_k = obiekt_aproksymacja()

% duration = 600;
% % for k=20:duration
% ymod_k(1:duration) = 0;
% u(1:19) = 0;
% u(20:duration) = 1;
% e(1:duration) = 0;
% err = 0;
% end

% liczba eulera
eu = exp(1);

% stałe wyliczone przez fmincon
% [10.000257759010971,75.069958064556530,0.307368246341753]
T1 = 10; %.000257759010971;
T2 = 75; %.564049105257986;
K = 0.307368246341753;

% opoznienie obiektu wynosi 17s
Td = 17;


%         Td = 17;
%         a1 = -1.891592579843155;
%         a2 = 0.892852992843278;
%         b1 = 1.973637272890068e-04;
%         b2 = 1.900472062252068e-04;
% 
%         y(k) = b1*u(k-Td-1) + b2*u(k-Td-2) - a1*y(k-1) - a2*y(k-2);
%         yp(k) = y(k);


% wyliczenie współczynników
alfa1 = eu^(-1/T1);
alfa2 = eu^(-1/T2);
a1 = -alfa1 - alfa2;
a2 = alfa1*alfa2;
b1 = (K/(T1-T2))*(T1*(1-alfa1)-T2*(1-alfa2));
b2 = (K/(T1-T2))*(alfa1*T2*(1-alfa2)-alfa2*T1*(1-alfa1));

% for k=20:duration
ymod_k = b1*u(k-Td-1) + ...
    b2*u(k-Td-2) - ...
    a1*y(k-1) - ...
    a2*y(k-2);
% 
end