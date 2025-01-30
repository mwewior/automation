function [u1k, u2k, u3k, u4k, Y0k] = dmc_mimo(k, U, Y, Yzad, D, N, ny, nu, K, Mp)

%     mode = 'klasyczny';
    mode = 'prosty';

    u1 = U(:, 1);
    u2 = U(:, 2);
    u3 = U(:, 3);
    u4 = U(:, 4);
    U_enum = {u1, u2, u3, u4};
    
    yzad1 = Yzad(k,1);
    yzad2 = Yzad(k,2);
    yzad3 = Yzad(k,3);
    Yzad_enum = {yzad1, yzad2, yzad3};

    y1 = Y(k, 1);
    y2 = Y(k, 2);
    y3 = Y(k, 3);
    Y_enum = {y1, y2, y3};

    
    %%% OSZCZĘDNA WERSJA
    if strcmp(mode, 'prosty')

        Y0k = [yzad1 - y1; yzad2 - y2; yzad3 - y3];


        Ke = zeros(nu, ny);

        for J=1:N
            cur = (J-1)*ny+1;
            Ke = Ke + K(1:nu, cur:cur+ny-1);
        end


        K1 = K(1:nu,:);
        
        Ku = {D-1};
        for i = 1:D-1
            cur = (i-1)*nu+1;
            Mpj = Mp(:, cur:cur+nu-1);
            Ku{i} = K1 * Mpj;
        end


        elem = zeros(nu, 1);
        for i = 1:D-1

            if k-i <= 1
                du = zeros(nu, 1);
            else
                du = [
                    u1(k-i) - u1(k-i-1);
                    u2(k-i) - u2(k-i-1);
                    u3(k-i) - u3(k-i-1);
                    u4(k-i) - u4(k-i-1)
                ];
            end

            elem = elem + Ku{i}*du;
        end

        
        dUk = Ke * Y0k - elem;

    end


    u1k = u1(k-1) + dUk(1);
    u2k = u2(k-1) + dUk(2);
    u3k = u3(k-1) + dUk(3);
    u4k = u4(k-1) + dUk(4);

%     fprintf('K: %d\n', size(K))
%     fprintf('Y0k: %d\n', size(Y0k))
%     fprintf('Mp: %d\n', size(Mp))
%     fprintf('DeltaUpk: %d\n', size(DeltaUpk))
%     disp(dUk);

end



%{

%%% PEŁNA WERSJA
    if strcmp(mode, 'klasyczny')
    

        Y0k = zeros(N*ny, 1);

        for J = 1:N
            for j = 1:ny
                cur = (J-1)*ny+j;
                Y0k(cur) = Yzad_enum{j} - Y_enum{j};
            end
        end

    
    
        DeltaUpk = zeros(nu*(D-1), 1);
    
        for J = 1:D-1
            for j = 1:nu
                
                if k-J-1 <= 1
                    chwila = 2;
                else
                    chwila = k-J;    
                end
                
                cur = (J-1)*nu+j;
                DeltaUpk(cur) = U_enum{j}(chwila) - U_enum{j}(chwila-1);
            
            end
        end
    
        dUk = K * (Y0k - Mp*DeltaUpk);
    
    end

    

%}
