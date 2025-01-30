%%Socket Communication demo script
delete(instrfindall)
pause(2);

close all;
clear all; 
  
t = tcpip('192.168.127.250',4000, 'NetworkRole', 'client');

t.OutputBufferSize = 3000;
t.InputBufferSize = 3000;
 
fopen(t);
u1 = [];
u2 = [];
y1 = [];
y2 = [];
yz1 = [];
yz2 = [];

figure(1);
while (1)
    if (t.BytesAvailable ~= 0)
        temp = fscanf(t);
        %disp(temp);
        eval(temp);
        u1 = [u1; U1];
        u2 = [u2; U2];
        y1 = [y1; Y1];
        y2 = [y2; Y2];
        yz1 = [yz1; YZ1];
        yz2 = [yz2; YZ2];
        
        subplot(2,1,1); plot(y1, '-'); hold on; 
        plot(yz1, '-'); hold on; 
        plot(y2, '--'); hold on; 
        plot(yz2, '-'); 
        hold off; title('Wyjœcie'); xlabel('iteracja');
        legend('y1', 'yz1', 'y2', 'yz2');
        %legend('y1', 'y2');
        subplot(2,1,2); stairs(u1); hold on; stairs(u2); hold off; title('Sterowanie'); xlabel('iteracja');
        legend('u1', 'u2');
        drawnow
    end 
    pause(0.05);
end

fclose(t);
delete(t);
clear t;

