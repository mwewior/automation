clearvars -except tabelaE_oe tabelaE_arx;
close all;

%% DANE zadanie 1:
uczace = importdata("danedynucz43.txt");
weryfikujace = importdata("danedynwer43.txt");

Uucz = uczace(:,1);
Yucz = uczace(:,2);
Uwer = weryfikujace(:,1);
Ywer = weryfikujace(:,2);

sz = size(uczace, 1);
rzd = 3;

% p = 4;

% mode = 'lin';
mode = 'poly';


%% A

% dane = plot(Uucz, Yucz, 'o' );
% dane = plot(Yucz);
% dane = plot(Uwer, Ywer, 'o');
% hold on;
% dane = plot(Ywer);
% ylabel("y", 'Rotation', pi/2);
% xlabel("nr próbki")
% hold on;
% grid on;

%% B

if strcmp(mode, 'lin')

if exist("tabelaE_arx", "var")==0
    tabelaE_arx = zeros(3, 2);
end
if exist("tabelaE_oe", "var")==0
    tabelaE_oe = zeros(3, 2);
end

% rekurencja = 1; % 0: bez rekurencji (ARX)
                % 1: z rekurencją (OE)

for rekurencja=0:1
    for n=1:3
    
        % n = 3;
        
        Y = zeros(sz-n,1);
        M = zeros(sz-n,2*n);
        Ymoducz = Yucz(1:sz-4,:);
        Ymodwer = Ywer(1:sz-4,:);
        Yerrucz = Yucz(1:sz-4,:);
        Yerrwer = Ywer(1:sz-4,:);
        
        if n == 1
            for i=1:sz-n
                Y(i)=Yucz(i+n);
                M(i,1)=Uucz(i);
                M(i,2)=Yucz(i);
            end
        
            w1=M\Y;
            b1 = w1(1);
            a1 = w1(2);
        
            if rekurencja==0
                for k=4:sz
                    Ymoducz(k-3) = b1*Uucz(k-1) + a1*Yucz(k-1);
                    Ymodwer(k-3) = b1*Uwer(k-1) + a1*Ywer(k-1);
                    Yerrucz(k-3) = Yucz(k);
                    Yerrwer(k-3) = Ywer(k);
                end
            elseif rekurencja==1
                %inicjalizacja:
                Ymoducz(1) = b1*Uucz(3) + a1*Yucz(3);
                Ymodwer(1) = b1*Uwer(3) + a1*Ywer(3);
    
                for k=5:sz
                    Ymoducz(k-3) = b1*Uucz(k-1) + a1*Ymoducz(k-4);
                    Ymodwer(k-3) = b1*Uwer(k-1) + a1*Ymodwer(k-4);
                    Yerrucz(k-3) = Yucz(k);
                    Yerrwer(k-3) = Ywer(k);
                end
            end
        
        elseif n == 2
            for i=1:sz-n
                Y(i)=Yucz(i+n);
                M(i,1)=Uucz(i+1);
                M(i,2)=Uucz(i);
                M(i,3)=Yucz(i+1);
                M(i,4)=Yucz(i);
            end
        
            w2=M\Y;
            b1 = w2(1);
            b2 = w2(2);
            a1 = w2(3);
            a2 = w2(4);
        
            if rekurencja==0
                for k=4:sz
                    Ymoducz(k-3) = b1*Uucz(k-1) + b2*Uucz(k-2) + a1*Yucz(k-1) + a2*Yucz(k-2);
                    Ymodwer(k-3) = b1*Uwer(k-1) + b2*Uwer(k-2) + a1*Ywer(k-1) + a2*Ywer(k-2);
                    Yerrucz(k-3) = Yucz(k);
                    Yerrwer(k-3) = Ywer(k);
                end
            elseif rekurencja==1
                %inicjalizacja:
                Ymoducz(1) = b1*Uucz(3) + b2*Uucz(2) + a1*Yucz(3) + a2*Yucz(2);
                Ymodwer(1) = b1*Uwer(3) + b2*Uwer(2) + a1*Ywer(3) + a2*Ywer(2);
                Ymoducz(2) = b1*Uucz(4) + b2*Uucz(3) + a1*Ymoducz(1) + a2*Yucz(3);
                Ymodwer(2) = b1*Uwer(4) + b2*Uwer(3) + a1*Ymodwer(1) + a2*Ywer(3);
                
                for k=6:sz
                    Ymoducz(k-3) = b1*Uucz(k-1) + b2*Uucz(k-2) + a1*Ymoducz(k-4) + a2*Ymoducz(k-5);
                    Ymodwer(k-3) = b1*Uwer(k-1) + b2*Uwer(k-2) + a1*Ymodwer(k-4) + a2*Ymodwer(k-5);
                    Yerrucz(k-3) = Yucz(k);
                    Yerrwer(k-3) = Ywer(k);
                end
            end
        
        elseif n == 3
            for i=1:sz-n
                Y(i)=Yucz(i+n);
                M(i,1)=Uucz(i+2);
                M(i,2)=Uucz(i+1);
                M(i,3)=Uucz(i);
                M(i,4)=Yucz(i+2);
                M(i,5)=Yucz(i+1);
                M(i,6)=Yucz(i);
            end
    
            w3=M\Y;
            b1 = w3(1);
            b2 = w3(2);
            b3 = w3(3);
            a1 = w3(4);
            a2 = w3(5);
            a3 = w3(6);
        
            if rekurencja==0
                for k=4:sz
                    Ymoducz(k-3) = b1*Uucz(k-1) + b2*Uucz(k-2) + b3*Uucz(k-3) + a1*Yucz(k-1) + a2*Yucz(k-2)+ a3*Yucz(k-3);
                    Ymodwer(k-3) = b1*Uwer(k-1) + b2*Uwer(k-2) + b3*Uwer(k-3) + a1*Ywer(k-1) + a2*Ywer(k-2)+ a3*Ywer(k-3);
        
                    Yerrucz(k-3) = Yucz(k);
                    Yerrwer(k-3) = Ywer(k);
                end
            elseif rekurencja==1
                %inicjalizacja:
                Ymoducz(1) = b1*Uucz(3) + b2*Uucz(2) + b3*Uucz(1) + a1*Yucz(3) + a2*Yucz(2) + a3*Yucz(1);
                Ymodwer(1) = b1*Uwer(3) + b2*Uwer(2) + b3*Uwer(1) + a1*Ywer(3) + a2*Ywer(2) + a3*Ywer(1);
                Ymoducz(2) = b1*Uucz(4) + b2*Uucz(3) + b3*Uucz(2) + a1*Ymoducz(1) + a2*Yucz(3) + a3*Yucz(2);
                Ymodwer(2) = b1*Uwer(4) + b2*Uwer(3) + b3*Uwer(2) + a1*Ymodwer(1) + a2*Ywer(3) + a3*Ywer(2);
                Ymoducz(3) = b1*Uucz(5) + b2*Uucz(4) + b3*Uucz(3) + a1*Ymoducz(2) + a2*Ymoducz(1) + a3*Yucz(3);
                Ymodwer(3) = b1*Uwer(5) + b2*Uwer(4) + b3*Uwer(3) + a1*Ymodwer(2) + a2*Ymodwer(1) + a3*Ywer(3);
                
                for k=7:sz
                    Ymoducz(k-3) = b1*Uucz(k-1) + b2*Uucz(k-2) + b3*Uucz(k-3) + a1*Ymoducz(k-4) + a2*Ymoducz(k-5)+ a3*Ymoducz(k-6);
                    Ymodwer(k-3) = b1*Uwer(k-1) + b2*Uwer(k-2) + b3*Uwer(k-3) + a1*Ymodwer(k-4) + a2*Ymodwer(k-5)+ a3*Ymodwer(k-6);
                    Yerrucz(k-3) = Yucz(k);
                    Yerrwer(k-3) = Ywer(k);
                end
            end
        
        end % if n == ...
        
        
        Eucz = (Ymoducz - Yerrucz)' * (Ymoducz - Yerrucz);
        Ewer = (Ymodwer - Yerrwer)' * (Ymodwer - Yerrwer);

        if rekurencja==0
            tabelaE_arx(n, 1) = Eucz;
            tabelaE_arx(n, 2) = Ewer;
        elseif rekurencja==1
            tabelaE_oe(n, 1)= Eucz;
            tabelaE_oe(n, 2) = Ewer;
        end
    

        figure(2*n -1);
        if rekurencja == 0
            arx = subplot(2, 1, 1);
            title("bez rekurencji");
        end
        if rekurencja == 1
            oe = subplot(2, 1, 2);
            title("z rekurencją");
        end
        plot(Yucz, '-', 'Color', 'blue', LineWidth=0.25);
        hold on;
        plot(Ymoducz,' --', 'Color', 'red', LineWidth=0.25);
        hold on;
        grid on;
        if rekurencja == 0
            msg = sprintf('Błąd = %d', Eucz);
            title(arx, {"bez rekurencji" msg});
        else
            msg = sprintf('Błąd = %d', Eucz);
            title(oe, {"z rekurencją" msg});
        end
        rzaddyn = sprintf('rząd dynamiki = %d', n);
        sgtitle({"dane uczące" rzaddyn})

        figure(2*n);
        if rekurencja == 0
            arx = subplot(2, 1, 1);
            title("bez rekurencji");
        end
        if rekurencja == 1
            oe = subplot(2, 1, 2);
            title("z rekurencją");
        end
        plot(Ywer, '-', 'Color', 'blue', LineWidth=0.25);
        hold on;
        plot(Ymodwer,' --', 'Color', 'red',LineWidth=0.25);
        hold on;
        grid on;
        if rekurencja == 0
            msg = sprintf('Błąd = %d', Ewer);
            title(arx, {"bez rekurencji" msg});
        else
            msg = sprintf('Błąd = %d', Ewer);
            title(oe, {"z rekurencją" msg});
        end
        rzaddyn = sprintf('rząd dynamiki = %d', n);
        sgtitle({"dane weryfikujące" rzaddyn})


    end     % n


end         % rekurencja

end



%% C


if strcmp(mode, 'poly')

Y = Yucz(rzd+1:sz,1);
Yw = Ywer(rzd+1:sz,1);
    for st=2:6
        for r = 1:rzd
            for s = 1:st
                M(:, st*(r-1)+s) = Uucz(rzd-r+1:sz-r).^s;
                M(:, st*(r-1)+s+st*rzd) = Yucz(rzd-r+1:sz-r).^s;
        
                Mwer(:, st*(r-1)+s) = Uwer(rzd-r+1:sz-r).^s;
                Mwer(:, st*(r-1)+s+st*rzd) = Ywer(rzd-r+1:sz-r).^s;
            end
        end
        
        w = M\Y;

        if st == 4
            rzd_opt = 3;
            st_opt = 4;
            w_opt = w;
        end
        
        for rekurencja=0:1
          if rekurencja==0
              Ymoducz = M * w;
              Ymodwer = Mwer * w;
            
              Eucz = (Ymoducz - Y)'*(Ymoducz - Y);
              Ewer = (Ymodwer - Yw)'*(Ymodwer - Yw);
              tabelaE_arx(st-1, 1) = Eucz;
              tabelaE_arx(st-1, 2) = Ewer;
          end
        
        
          if rekurencja==1
            Ymoducz(1) = M(1, :)*w;
            Ymodwer(1) = Mwer(1,:)*w;   
        
            for i = 2:rzd
                reku = 0; rekw = 0;
                for r = 1:i-1
                for s = 1:st
                    j = st*(r-1)+s;
                    reku = reku - M(i,rzd*st+ j).^s * w(rzd*st+j);
                    reku = reku + Ymoducz(i-r).^s;
        
                    rekw = rekw - Mwer(i,rzd*st+ j).^s * w(rzd*st+j);
                    rekw = rekw + Ymodwer(i-r).^s;
                end
                end
        
                Ymoducz(i) = M(i,:) * w + reku;
                Ymodwer(i) = Mwer(i,:)*w + rekw;
            end %inicjalizacja
        
            for k=rzd+1:sz-rzd 
                reu = 0; rew = 0;
                for r = 1:i-1
                for s = 1:st
                    j = st*(r-1)+s;
                    reu = w(rzd*st+j)*Ymoducz(k-r)^s;
                    rew = w(rzd*st+j)*Ymodwer(k-r)^s;
                end
                end
        
                Ymoducz(k) = M(k,1:rzd*st)*w(1:rzd*st) + reu;
                Ymodwer(k) = Mwer(k,1:rzd*st)*w(1:rzd*st) + rew;
            end %pozostałe wiersze
        
            Eucz = (Ymoducz - Y)'*(Ymoducz - Y);
            Ewer = (Ymodwer - Yw)'*(Ymodwer - Yw);
            tabelaE_oe(st-1, 1) = Eucz;
            tabelaE_oe(st-1, 2) = Ewer;
        
          end   % if reku==1
        
        end % rekurencja 0/1


    end     % for st

end




%% D
% jeszcze coś nie teges

syms u y
eq = -y;
for r=1:rzd_opt
    for s=1:st_opt
        j = st_opt*(r-1)+s;
        eq = eq + w_opt(j)*u^s + w_opt(12+j)*y^s;
    end
end

y_stat = zeros(201, 1);
n = 1;
for i=-1:0.01:1
    f1 = subs(eq, u, i);
    x = fsolve(matlabFunction(f1), 0);
    y_stat(n) = x; n = n +1;
end
figure;
plot(-1:0.01:1, y_stat);