D = 85;
len = D;
start = 5;
nullS = zeros(2, 2);
S = cell(len, 1);

ws1 = load('odp_skokowa_g1_300.mat');


ws2 = load('odp_skokowa_g2_300.mat');

for k=start:D+start

    p = k-start+1;

    y1o1 = (ws1.y1(k) - ws1.y1(start))/300;
    y2o1 = (ws1.y2(k) - ws1.y2(start))/300;

    y1o2 = (ws2.y1(k) - ws2.y1(start))/300;
    y2o2 = (ws2.y2(k) - ws2.y2(start))/300;
    
    S{p} = [
        y1o1,   y1o2;
        y2o1,   y2o2;
    ];
end

for k=1:len-start+1

    p = k;
    S11(p) = S{k}(1, 1); 
    S21(p) = S{k}(2, 1); 

    S12(p) = S{k}(1, 2); 
    S22(p) = S{k}(2, 2); 
end

N = 50;
Nu = 10;
nu = 2; ny =2;
Mi = 1;
Lambda = 1;

[K, Mp] = dmc_mimo_offline(S, D, N, ny, Nu, nu, Mi, Lambda);

% oszczędna wersja DMC - parametry
Ke = 0;
for i = 1 : N
    Ke = Ke + K(1, i);
end
ku = K(1, :)*Mp



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


% ku_str = "double ku[] = {"
% for i = 1:length(ku)
%     if i < length(ku)
%         ku_str = ku_str + ku(i) + ",";
%     else
%         ku_str = ku_str + ku(i);
%     end
% end
% ku_str = ku_str + "};"+newline;
% 
% ku_str = ku_str+"double ke = "+Ke+";"

for i =1:length(ku)
    fprintf('Ku[%d] := %f;\n',i-1,ku(i));
end
for i=1:75
    fprintf('dU1[%d] := 0.0;\n',i-1);
    fprintf('dU2[%d] := 0.0;\n',i-1);
end
fprintf('Ke[0] := %f;\n',Ke(1,1));
fprintf('Ke[1] := %f;\n',Ke(1,2));
fprintf('Ke[2] := %f;\n',Ke(2,1));
fprintf('Ke[3] := %f;\n',Ke(2,2));

subplot(2, 2, 1)
stairs(S11); grid on; title("y_1(u_1)"); ylabel("y_1"); xlabel("k");
subplot(2, 2, 2)
stairs(S21); grid on; title("y_2(u_1)"); ylabel("y_2"); xlabel("k");

subplot(2, 2, 3)
stairs(S12); grid on; title("y_1(u_2)"); ylabel("y_1"); xlabel("k");
subplot(2, 2, 4)
stairs(S22); grid on; title("y_2(u_2)"); ylabel("y_2"); xlabel("k");

