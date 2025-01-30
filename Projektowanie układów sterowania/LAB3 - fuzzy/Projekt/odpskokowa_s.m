clear
n=200;
delay = 10;


u(1:delay-1) = 0;
z(1:n) = 0;
s(1:n) = 0;
u(delay:n) = 1;
y(1:n) = 0;

for k=delay:n
    y(k) = symulacja_obiektu12y_p3(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2));
    s(k) = y(k);
end

u(1:n) = 0;
z(1:delay-1) = 0;
z(delay:n) = 1;
s_z(1:n) = 0;
y_z(1:n) = 0;

for k=delay:n
    y_z(k) = symulacja_obiektu12y_p3(u(k-7), u(k-8), z(k-4), z(k-5), y_z(k-1), y_z(k-2));
    s_z(k) = y_z(k);
end


% s(n-delay+1:n) = s(n-delay);
% s_z(n-delay+1:n) = s_z(n-delay);


stairs(s);
title('s');
figure
stairs(s_z);
title('sz');
