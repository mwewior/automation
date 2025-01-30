% funkcja do wyznaczania y dla algorytmu DMC

function y = obiekt12(u, z)
    
    %% synchronising with the control process
     % wait for new batch of measurements to be ready
   
   
    addpath('D:\SerialCommunication'); % add a path to the functions 
    initSerialControl COM5 % initialise com port
    waitForNewIteration();
    
    sendControls(1, ... send for these elements
                 50);  % new corresponding control values
             
    sendControlsToG1AndDisturbance(u, z);  % new corresponding control values

    
    measurement = readMeasurements(1:1);
    y = measurement
    
end