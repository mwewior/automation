clear s;
close all;
s = serialport('COM11', 115200, 'Parity', 'None');

s.configureTerminator("LF");
y=[];
u=[];
yzad = [];
k=1;
i = 0;
while(1)
txt = s.readline()
eval(txt);
y(k) = Y;
u(k) = U;
yzad(k) = YZAD;
% i = ITER
k = k+1
subplot(2,1,1);
grid on;
stairs(y); hold on;
stairs(yzad, '--');
hold off;
subplot(2,1,2);
% hold on;
stairs(u);
% hold off;
drawnow;

end
% clear s
