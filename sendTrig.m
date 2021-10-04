function sendTrig(triggercode,useport)
%Wrapper function for sending trigger codes from matlab on stimulus 
%computer (right hand side on Anna Watts desk) to stimulus recording
%software (Actiview) left computer, adjacent.
%useage: 
%triggercode: must be positive, 1xN array, class double, < 255.
%useport: is defined by running function pairStimtoEEG.


%MDavidson Sept 2019. Qs: mjd070 at gmail dot com

%make sure input is correct, or different value trigger will be sent:
% tic
if ~isa(triggercode, 'double')
    error(['error, trigger code must be class double. Otherwise, trigger ',... 
    'values change in ActiView'])
elseif triggercode > 255
    error(' max trigger code value = 255')
end

write(useport, triggercode, 'uint8')
% toc

%flush port bytes written, so we don't overfill port buffer:
flush(useport)

%%