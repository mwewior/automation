function resetPP(isTooHot)
    addpath('D:\SerialCommunication'); % add a path to the functions
    initSerialControl COM7 % initialise com port

    PP = [27, 34];
% 
%     if(isTooHot)
        while(1)
            %% sending new values of control signals
    
            if(isTooHot)

                % wentylator na 100%, grzalka na 0
                sendControls([ 1,5], ... send for these elements
                         [100,0]);  % new corresponding control values
                sendControlsToG1AndDisturbance(0, 0);
                measurement = readMeasurements(1:1)
    
                % predykcja o 2 stopnie ze względu na inercję
                if(measurement == PP(2) + 2)
                    sendControls([1, 5], [50, PP(1)]);
                    break;
                end
            else
                % wentylator na 0%, grzalka na 40% aby nie wybuchła
                sendControls([ 1,5], ...
                         [0,40]);
                sendControlsToG1AndDisturbance(40, 0);
                measurement = readMeasurements(1:1)
    
                % predykcja o 2 stopnie ze względu na inercję
                if(measurement == PP(2) - 2)
                    sendControls([1, 5], [50, PP(1)]);
                    break;
                end
            end
        end
            
    
            %% synchronising with the control process
            waitForNewIteration(); % wait for new batch of measurements to be ready
    
        Tkoniec = 10;
        % zakonczenie resetu, dramatyczny countdown 10s
        % na ustabilizowanie sie obiektu
        
        while(Tkoniec~= 0)
            Tkoniec = Tkoniec - 1

            sendControls([ 1,5], ...
                     [50,PP(1)]);

            measurement = readMeasurements(1:1)

            waitForNewIteration(); % wait for new batch of measurements to be ready
        end
end