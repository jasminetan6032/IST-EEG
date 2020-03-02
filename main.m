%% Information Sampling Tascask for EEG %%%%%%%%%%%
% Author - Sriraj Aiyer
% Contact - sriraj.aiyer@psy.ox.ac.uk

% This experiment is for the Information Sampling Task for both fixed and
% decreasing win conditions and contains triggers for use in EEG via
% Biosemi.

% This is the main entry to the program, so run this script to run the
% whole experiment.

%% Setup

close all;
clc;

% Folder to save data at.
vars.rawdata_path = 'rawdata/';

% Initial questionnaire for subject information.
%[subject] = questionnaire(vars);                              

% Start timer
tic
% Initial experiment variables
[vars] = varSet(vars);

% You can resume an experiment at where it left off in case of a crash.
% if (subject.restart)
%     [filename, pathname] = uigetfile('*.mat', 'Pick last saved file ');
%     load([pathname filename]);
%     starttrial = t;
%     vars.restarted = 1;
% else
%     starttrial=1;
% end

% Below script sets the initial value for varibles we need for the
% experiment.
initialiseVars;
    
% Generate the struct of trials and cues to be given on each trial.
[trials] = getTrials(vars);

% startInstructs;

% We need to see which experiment we are doing: behavioural or eeg.
% Behavioural: allow participants to choose while tile to reveal and click
% on a box to answer.
% EEG: participants control experiment only using left and right mouse
% clicks without moving mouse in order to reduce eye movements. Also
% contains triggers for BIOSEMI.
if (strcmp(vars.experimentType,'behavioural'))
    behaviouralLoop;
elseif (strcmp(vars.experimentType,'eeg'))
    eegLoop;
end