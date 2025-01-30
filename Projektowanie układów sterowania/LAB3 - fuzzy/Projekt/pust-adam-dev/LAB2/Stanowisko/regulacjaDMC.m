function du = regulacjaDMC(k, u, ypom, z, yzad, D, N, K, Mp, Mzp, Dz)

    e(k) = yzad(k) - ypom(k);

    elem = 0;
    elemz = 0;
    Ke = 0;

    for i = 1 : N
        Ke = Ke + K(1, i);
    end

    for j = 1:D-1

        ku = K(1,:) * Mp(:,j);

        if k-j < 1
            du_kmj = 0;
        elseif k-j == 1
            du_kmj = u(k-j);

        else
            du_kmj = u(k-j) - u(k-j-1);
        end

        elem = elem + ku*du_kmj;

    end

    % zaklocenia
     for j = 0:Dz-1

        kzj = K(1,:) * Mzp(:,j+1);

        if k-j< 1
            dz_kmj = 0;
        elseif k-j == 1
            dz_kmj = z(k-j);
        else
            dz_kmj = z(k-j) - z(k-j-1);
        end

        elemz = elemz + kzj * dz_kmj; 

    end

    du = Ke * e(k) - elem - elemz;
end

