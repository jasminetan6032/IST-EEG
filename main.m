%% Information Sampling Task for EEG %%%%%%%%%%%
% Author - Sriraj Aiyer
% Contact - sriraj.aiyer@psy.ox.ac.uk

% This experiment is for the Information Sampling Task for both fixed and
% decreasing win conditions and contains triggers for use in EEG via
% Biosemi.

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

initialiseVars;

points = 0;

% Generate the struct of trials and cues to be given on each trial.
[trials] = getTrials(vars);

if (strcmp(vars.experimentType,'behavioural'))
    behaviouralLoop;
elseif (strcmp(vars.experimentType,'eeg'))
    eegLoop;
end