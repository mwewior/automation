function [K, Mp] = dmc_mimo_offline(S, D, N, ny, Nu, nu, Mi, Lambda)

    nullS = zeros(ny, nu);

    m_rows = ny * N;            % size(S{1}, 1) * N
    m_cols = nu * Nu;           % size(S{1}, 2) * (N-Nu+1)
    M = zeros(m_rows, m_cols);  % N x Nu
    
    for c = 1:nu:m_cols % kolumny
        C = (c-1)/nu + 1;
        
        for r = 1:ny:m_rows % wiersze
            R = (r-1)/ny + 1;
    
            if (R - C + 1) <= 0
                M(r:r+ny-1, c:c+nu-1) = nullS;
    
            elseif (R - C + 1) > D
                M(r:r+ny-1, c:c+nu-1) = S{D};
    
            else
                M(r:r+ny-1, c:c+nu-1) = S{R-C+1};
    
            end
    
            % fprintf('r = %d, c = %d\n', r, c)
            % fprintf('R = %d, C = %d\n\n', R, C)
        
        end
    end
    
    
    mp_rows = ny * N;               % size(S{1}, 1) * N
    mp_cols = nu * (D-1);           % size(S{1}, 2) * (D-1)
    Mp = zeros(mp_rows, mp_cols);   % N x (D-1)
    
    for c = 1:nu:mp_cols % kolumny
        C = (c-1)/nu + 1;
    
        for r = 1:ny:mp_rows % wiersze
            R = (r-1)/ny + 1;
            
            if R + C > D
                Scr = S{D};
            else
                Scr = S{C+R};
            end

            if C > D
                Sc = S{D};
            else
                Sc = S{C};
            end
            
            Scur = Scr - Sc; 
            Mp(r:r+ny-1, c:c+nu-1) = Scur; 
    
        end
    
    end
    
    
    PSI = eye(N*ny);
    Mi_enum = Mi;
    
    for J = 1:N
        for j = 1:ny
            diag = (J-1)*ny+j;
            PSI(diag, diag) = Mi_enum;%{j};
        end
    end
    
    
    LAMBDA = eye(Nu*nu);
    Lambda_enum = Lambda;
    
    for J = 1:Nu
        for j = 1:nu
            diag = (J-1)*nu+j;
            LAMBDA(diag, diag) = Lambda_enum;%{j};
        end
    end
    
    
    K = ((M' * PSI * M + LAMBDA)^(-1)) * M' * PSI;

end
