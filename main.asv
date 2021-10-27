%% Information Sampling Task for EEG %%%%%%%%%%%
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
[subject] = questionnaire(vars);

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

% Below script sets the initial value for variables we need for the
% experiment.
initialiseVars;

if (strcmp(vars.expLengthMeasure,'trials'))
    % Generate the struct of trials and cues to be given on each trial.
    [trials] = getTrials(vars);
else
    
    trials = struct('trialNumber',cell(1,1),...
        'break',cell(1,1),'type',cell(1,1),'numOfColour1',cell(1,1),'numOfColour2',cell(1,1),...
        'finalAns',cell(1,1),'finalColour',cell(1,1),'finalPCorrect',cell(1,1),'finalCj',cell(1,1),'finalCjTime',cell(1,1),...
        'cjLoc',cell(1,1),'cjDidRespond',cell(1,1),'trueAns',cell(1,1),'trueColour',cell(1,1),'correct',cell(1,1),...
        'numOfTilesRevealed',cell(1,1),'majorityRevealed',cell(1,1),'majorityMargin',cell(1,1),...
        'trialStart',cell(1,1),'answerTime',cell(1,1),'finalAnswerTime',cell(1,1),'trialEnd',cell(1,1),'trialTime',cell(1,1),...
        'averageTimeBetweenFlips',cell(1,1),'reward',cell(1,1),'totalPoints',cell(1,1),'trueGrid',...
        cell(1,1),'trueColourGrid',cell(1,1),'finalGridState',cell(1,1),'trialBreakdown',struct('flipNumber',cell(1,1),'colourRevealed',...
        cell(1,1),'majorityColour',cell(1,1),'majorityAmount',cell(1,1),'majPCorrect',cell(1,1),...
        'timestamp',cell(1,1),'timeSinceLastFlip',cell(1,1),'currentGrid',...
        cell(1,1),'tileClicked',cell(1,1)));
end

if (vars.doInstr)
    startInstructs;
end

% We need to see which experiment we are doing: behavioural or eeg.
% Behavioural: allow participants to choose while tile to reveal and click
% on a box to answer.
% EEG: participants control experiment only using left and right mouse
% clicks without moving mouse in order to reduce eye movements. Also
% contains triggers for BIOSEMI.

% We also need to see whether we build all trials ahead of time (if
% experiment length is based on a number of trials) or is dynamic
% (experiment length is based on flipping a certain number of tiles or a
% certain length of time).


% Build all trials ahead of time.
if (strcmp(vars.expLengthMeasure,"trials"))
    if (strcmp(vars.experimentType,'behavioural'))
        for t = 1 : length(trials)
            behaviouralLoop;
        end
    elseif (strcmp(vars.experimentType,'eeg'))
        for t = 1 : length(trials)
            % trigger for start of stimuli
%             if (strcmp(trials.type, 'fixed'))
%                 sendTrig(100,useport)  
%             elseif (strcmp(trials.type, 'descending'))
%                 sendTrig(200,useport)
%             end
            
            eegLoop;
        end
    end
    % Build trials on the fly.
else
    endFlag = 0;
    if (strcmp(vars.experimentType,'behavioural'))
        while 1
            [trials, endFlag, subject] = dynamicTrials(vars,trials,subject);
            if (endFlag == 1)
                break;
            else
                t = subject.numOfTrials;
                behaviouralLoop;
            end
        end
    elseif (strcmp(vars.experimentType,'eeg'))
        while 1
            [trials, endFlag, subject] = dynamicTrials(vars,trials,subject);
            if (endFlag == 1)
                break;
            else
                t = subject.numOfTrials;
                % trigger for start of stimuli
%             if (strcmp(trials(t).type, 'fixed'))
%                 sendTrig(100,useport)  
%             elseif (strcmp(trials(t).type, 'decreasing'))
%                 sendTrig(200,useport)
%             end
                
                eegLoop;
            end
        end
    end
end

% End the experiment
subject = endExp(subject,trials,Sc);