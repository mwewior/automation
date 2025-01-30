function resetPP(isTooHot)
    addpath('D:\SerialCommunication'); % add a path to the functions
    initSerialControl COM5 % initialise com port

    PP = [27, 29.12];
% 
%     if(isTooHot)
        while(1)
            %% sending new values of control signals
    
            if(isTooHot)

                % wentylator na 100%, grzalka na 0
                sendControls([ 1,5], ... send for these elements
                         [100,0]);  % new corresponding control values
    
                measurement = readMeasurements(1:1)
    
                % predykcja o 2 stopnie ze względu na inercję
                if(measurement == PP(2) + 2)
                    break
                end
            else
                % wentylator na 0%, grzalka na 80% aby nie wybuchła
                sendControls([ 1,5], ...
                         [0,80]);
                measurement = readMeasurements(1:1)
    
                % predykcja o 2 stopnie ze względu na inercję
                if(measurement == PP(2) - 2)
                    break
                end
            end
            
    
            %% synchronising with the control process
            waitForNewIteration(); % wait for new batch of measurements to be ready
        end
    
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
% end