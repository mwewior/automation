function du = regulacjaDMC_bez_zakl(k, u, ypom, yzad, D, N, K, Mp)

    e(k) = yzad(k) - ypom(k);

    elem = 0;
    Ke = 0;

    for i = 1 : N
        Ke = Ke + K(1, i);
    end

    for j = 1:D-1

        ku = K(1,:) * Mp(:,j);

        if k-j<= 1
            du_kmj = 0;
        else
            du_kmj = u(k-j) - u(k-j-1);
        end

        elem = elem + ku*du_kmj;

    end

    du = Ke * e(k) - elem;

end

