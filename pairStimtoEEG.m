function useport = pairStimtoEEG
%% This script sets up the serial port, to allow sending triggers from the 
% stimulus computer (Right-side, Anna Watts), to the Actiview software
% 
%%%%%% Warning %%%%
% This is hardcoded for the current set up. If you plug the USB connection into a
% separate terminal, the port used will change. At the moment, the port
% used is the 'COM4' terminal, the last available USB port on the back of
% the computer.
%

% MDavidson Sept.2019 Q: mjd070 at gmail dot com
%% To see a list of available ports:
ports = serialportlist('available');
%we are using 'COM4'. This is the last serial port on the back of the
%stimulus-PC in anna watts building. Find this port's index.
ind = (ports=='COM4');
Baudrate= 115200; % this is datarate to use with actiview specs. see 
% https://www.biosemi.com/faq/USB%20Trigger%20interface%20cable.htm for
% more information.

%create handle to serialport object
try useport = serialport(ports{ind},Baudrate);
catch
    useport = serialport('COM4',Baudrate);
end
    
