duration = 200;
u(1:duration) = 0;
z(1:duration) = 0;
y(1:duration) = 0;

new_k = 9;

Ku_stat(1:10) = 0;
Kz_stat(1:10) = 0;
K = zeros(10, 10);

for u_temp = 1:10
    u(new_k:duration) = u_temp;

    for z_temp = 1:10
        % aby zmierzyc tez dla zerowych zaklocen
        z(new_k:duration) = z_temp-1;

        % symulacja
        for k=new_k:duration
            y(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2));
        end

        K(u_temp, z_temp) = y(duration);
        
        if z_temp == 1
            Ku_stat(u_temp) = (y(duration)-y(1) ) / (u(duration)-u(1));
        end

    end
       
end


for z_temp = 1:10
    % aby zmierzyc tez dla zerowych zaklocen
    z(new_k:duration) = z_temp-1;
    u(1:duration) = 0;

    % symulacja
    for k=new_k:duration
        y(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2));
    end

    Kz_stat(z_temp) = (y(duration)-y(1) ) / (z(duration)-z(1));
end
       
      
mesh(K);

%{
plot(u_stat, y_stat); grid on;
p = polyfit(u_stat, y_stat, 1);
%}