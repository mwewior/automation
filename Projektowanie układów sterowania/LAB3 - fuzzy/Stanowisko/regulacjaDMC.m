function du = regulacjaDMC(k, u, ypom, yzad, D, N, K, Mp)

    e(k) = yzad(k) - ypom(k);

    ster = 0;

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



    du = Ke * e(k) - ster;

end

