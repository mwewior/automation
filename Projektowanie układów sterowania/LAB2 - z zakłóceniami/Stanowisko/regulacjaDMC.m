function du = regulacjaDMC(k, u, ypom, yzad, z, D, Dz, N, K, Mp, Mzp)

    e(k) = yzad(k) - ypom(k);

    ster = 0;
    zakl = 0;

    Ke = 0;
    for i = 1 : N
        Ke = Ke + K(1, i);
    end


    for ju = 1:D-1

        ku = K(1,:) * Mp(:,ju);

        if k-ju < 1
            du_kmj = 0;
        elseif k-ju == 1
            du_kmj = u(k-ju);
        else
            du_kmj = u(k-ju) - u(k-ju-1);
        end

        ster = ster + ku*du_kmj;

    end


    for jz = 0:Dz-1
        
        kz = K(1,:) * Mzp(:, jz+1);
        
        if k-ju < 1
            dz_kmj = 0;
        elseif k-ju == 1
            dz_kmj = z(k-jz);
        else
            dz_kmj = z(k-jz) - z(k-jz-1);
        end
            
        zakl = zakl + kz*dz_kmj;

    end


    du = Ke * e(k) - ster - zakl;

end

