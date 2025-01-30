% funkcja do wyznaczania y dla algorytmu DMC

 function [u, y] = pomiar()
    
    %% synchronising with the control process
     % wait for new batch of measurements to be ready
    

    addpath('D:\SerialCommunication'); % add a path to the functions
    initSerialControl COM5 % initialise com port

    waitForNewIteration();
    
%     sendControls([ 1,5], ... send for these elements
%                 [50,u]);  % new corresponding control values

%     measurement = readMeasurements(1:1);

    u = readMeasurements(2);
    y = readMeasurements(1);
%     u = readMeasurements(2);
    
end