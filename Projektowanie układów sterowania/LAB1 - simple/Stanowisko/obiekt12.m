% funkcja do wyznaczania y dla algorytmu DMC

 function y = obiekt12(u, k)
    
    %% synchronising with the control process
     % wait for new batch of measurements to be ready
    waitForNewIteration();

    addpath('D:\SerialCommunication'); % add a path to the functions
    initSerialControl COM5 % initialise com port

    sendControls([ 1,5], ... send for these elements
                [50,u]);  % new corresponding control values

    measurement = readMeasurements(1:1)
    k
    y = measurement;
    
end