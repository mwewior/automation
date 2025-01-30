function uk = regulacjaPID(T, k, u, ypom, yzad, K_pid, Ti, Td)

    r0 = K_pid * (1 + T/(2*Ti) + Td/T);
    r1 = K_pid * (T/(2*Ti) - 2*Td/T - 1);
    r2 = K_pid * Td/T;
    
    e(k) = yzad(k) - ypom(k);
    e(k-1) = yzad(k-1) - ypom(k-1);
    e(k-2) = yzad(k-2) - ypom(k-2);
    
    uk = r2*e(k-2) + r1*e(k-1) + r0*e(k) + u(k-1); % u jest przekazywane jako u(k-1)

end
