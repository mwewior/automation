 function MinimalWorkingExample()
    addpath('D:\SerialCommunication'); % add a path to the functions
    initSerialControl COM5 % initialise com port
    while(1)
       
        %% obtaining measurements
        measurements1 = readMeasurements(1); % read measurements from 1 to 7
        measurements3 = readMeasurements(3);
        %% processing of the measurem/nklents and new control values calculation

        %% sending new values of c        ontrol signals
        sendControls([ 1,5], ... send for these elements
                     [ 50,27]);  % new corresponding control values
        
         measurement = readMeasurements(1:1)
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
    end
end