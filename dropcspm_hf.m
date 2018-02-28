%% Close all
clear all
close all

%% Setup the figure
% figure(1)
% hold on
% subplot(2,1,1)
% title('Licks per trial. To stop execution Cntrl C')

%% User should change these variables

%To stop this program enter cntrl shift esc

%First file name prefix for output
handles.dropcProg.output_file_prefix='C:\Users\Justin\Documents\Diego\CerebellarmmTG05-5-3p.mat';
if strcmp(handles.dropcProg.output_file_prefix(end-3:end),'.mat')
    handles.dropcProg.output_file_prefix=handles.dropcProg.output_file_prefix(1:end-4);
end


%Reinforce on S+ only? (1=yes, go-no go, 0=no, reinforce both, go-go)
handles.dropcProg.go_nogo=1;

%Enter S+ valve (1,2,4,8,16,32,64,128) and odor name
handles.dropcProg.splusOdorValve=uint8(64); %Make sure to use int8
handles.dropcProg.splusName='ISA';


%Enter S- valve (1,2,4,8,16,32,64,128) and odor name
handles.dropcProg.sminusOdorValve=uint8(128); %Make sure to use int8
handles.dropcProg.sminusName='MO';

%Enter final valve interval in sec (1.5 sec is usual)
<<<<<<< HEAD
handles.dropcProg.fvtime=0.5;
=======
handles.dropcProg.fvtime=1;
>>>>>>> db888181d401cf2289c1ad70c7831093bc78040b

%Enter time interval for short trial test (0.5 sec is usual)
handles.dropcProg.shortTime=0;

%Enter number of response area segments (usually 4, must be less than 6)
<<<<<<< HEAD
handles.dropcProg.noRAsegments=1;  %Note: This must be at least two segments
=======
handles.dropcProg.noRAsegments=2;  %Note: This must be at least two segments
>>>>>>> db888181d401cf2289c1ad70c7831093bc78040b

%Enter response area DT for each response area segment (0.5 sec is usual)
handles.dropcProg.dt_ra=0.4;

%Enter time to stop odor delivery in sec. Make >shortTime and <=dt_ra*noRAsegments+shortTime, normally 2.5 s
handles.dropcProg.odor_stop=2.5;

%Enter time for water delivery (sec, try 0.5 s)
handles.dropcProg.rfTime=0.3;

%Enter time per trial (sec, not less than 8 s)
%Must be larger than TIME_POST+shortTime+dt_ra*dropcProg.noRAsegments+2
handles.dropcProg.timePerTrial=8;

%If you want this computer to save the odor shorts make this variable one
handles.dropcProg.sendShorts=0;

%When do I turn the opto on? 0=no opto, 1=FV, 2=odor, 3=reward
%Please note that the duration of the light is set by Master 8
handles.dropcProg.whenOptoOn=1;

%If you want the computer to punish the mouse for a false alarm by not
%starting the next trial for a ceratin interval enter the interval in
%seconds here.
handles.dropcProg.dt_punish=0;

%Enter comment
handles.comment='Test';

%Transition to partial reinforcement after reaching criterion? (1=yes, 0=no)
% transitionToPartial=0;

%If transition to partial will take place: Start partial reinforcement immediately (0) or after criterion is reached (1)?
% afterCriterion=1;

%Open valve for background odor (1=yes, 0=no)
% handles.dropcProg.backgroundOdor=0;

%% Set the variables for testing
%handles.dropcProg.testProg=0;
%handles.dropcProg.skipIntervals=0;

%% Initialize variables that the user will not change
handles.dropcProg.which_program=mfilename;

handles.dropcData.trialPerformance=[];
handles.dropcData.ii_lick=[];
percent_corr_str=[];
block=0;

% dropcData
%Fellows random numbers are started randomly
handles.dropcData.fellowsNo=20*ceil(10*rand(1))-19;
handles.dropcData.trialIndex=1;     %These are all trials excluding shorts
handles.dropcData.epochIndex=0;
handles.dropcData.shortIndex=1;



%Initialize the variables that define how the olfactometer runs
% dropcProg

%Set the variables that will not change
handles.dropcProg.numTrPerBlock=20;
handles.dropcProg.makeNoise = 0;
handles.dropcProg.consoleOut=1;
handles.dropcProg.splusOdor=1;
handles.dropcProg.sminusOdor=2;
handles.dropcProg.sumPdOn=7;
handles.dropcProg.sumNoLick=8;

%Set the numbers for digital output to DT3010
handles.dropcDraqOut.final_valve=uint8(6);
handles.dropcDraqOut.opto_on=uint8(64);
handles.dropcDraqOut.s_plus=uint8(1);
handles.dropcDraqOut.odor_onset=uint8(18);
handles.dropcDraqOut.short_before=uint8(2);
handles.dropcDraqOut.short_after=uint8(4);
handles.dropcDraqOut.hit=uint8(8);
handles.dropcDraqOut.miss=uint8(10);
handles.dropcDraqOut.correct_rejection=uint8(12);
handles.dropcDraqOut.false_alarm=uint8(14);
handles.dropcDraqOut.draq_trigger=uint8(128);
handles.dropcDraqOut.reinforcement=uint8(16);

%Set the numbers for digital output to olfactometer DIO96H/50
handles.dropcDioOut.final_valve=uint8(2);
handles.dropcDioOut.purge_valve=uint8(4);
handles.dropcDioOut.noise=uint8(8);
handles.dropcDioOut.background_valve=uint8(3);
handles.dropcDioOut.water_valve=uint8(1);

%% Then do all that needs to be done before the experiment starts

run_program = 1;


%Get the random Fellows numbers for choosing S+/S- for trials
[handles.dropcProg.randomFellows handles.dropcProg.randomOpto]=dropcGetSlotnickOdorList();


%Setup reinforcements depending on whether the user chose go-no go vs. go-go
if handles.dropcProg.go_nogo==1
    %go-no go
    handles.dropcProg.fracReinforcement(1)=1.0; %Reinforcement for S+
    handles.dropcProg.fracReinforcement(2)=0; %Reinforcement for S-
    handles.dropcProg.doBuzz=0;
    reinforceSminus=0; %If this is zero reinforce only for hit, CR
else
    %go-go
    reinforceSminus=1;   %If this is one then reinforce regradless of the odor
    dropcProg.doBuzz=1;
    dropcProg.fracReinforcement(1)=0.7;   %Reinforcement for S+
    dropcProg.fracReinforcement(2)=0.7;   %Reinforcement of S-
end


%% Now run the olfactometer


%Initialize the DIO96H/50 before the mouse comes in
handles=dropcInitializePortsNow(handles);

fprintf(1, '\nWaiting for trigger...\n ');
while getvalue(handles.dio.Line(34))==1
end
tic
fprintf(1, '\nStart of session...\n ');

%The filename will include the time in format 30:
%ISO 8601: 'yyymmddTHHMMSS'
formatOut=30;
handles.dropcProg.output_file=[handles.dropcProg.output_file_prefix datestr(datetime,formatOut) 'spm.mat'];

stopTrials=0;

while (stopTrials==0)&(handles.dropcData.trialIndex<200)
    %Do one trial
    
    fprintf('\n')
    %Decide whether this is S+ or S-
    if (handles.dropcProg.randomFellows(handles.dropcData.fellowsNo) == 1)
        %S+ odor
        handles.dropcProg.odorValve=handles.dropcProg.splusOdorValve;
        handles.dropcProg.typeOfOdor=handles.dropcProg.splusOdor;
<<<<<<< HEAD
        handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.splusOdor;
=======
>>>>>>> db888181d401cf2289c1ad70c7831093bc78040b
        disp(['Trial No: ' num2str(handles.dropcData.trialIndex) '; S+'])
    else
        %S- odor
        handles.dropcProg.odorValve=handles.dropcProg.sminusOdorValve;
        handles.dropcProg.typeOfOdor=handles.dropcProg.sminusOdor;
<<<<<<< HEAD
        handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.sminusOdor;
=======
>>>>>>> db888181d401cf2289c1ad70c7831093bc78040b
        disp(['Trial No: ' num2str(handles.dropcData.trialIndex) '; S-'])
    end
    
    handles.dropcData.fellowsNo=handles.dropcData.fellowsNo+1;
    if handles.dropcData.fellowsNo==201
        handles.dropcData.fellowsNo=1;
    end
    
    
    %Now run the trial

    %Wait till the mouse licks
    while (dropcNosePokeNow(handles)==0)
    end
    
    %FV on
    handles.dropcData.epochIndex=handles.dropcData.epochIndex+1;
    handles.dropcData.epochEvent(handles.dropcData.epochIndex)=1; %1 is FV on
    handles.dropcData.epochTime(handles.dropcData.epochIndex)=toc;
    handles.dropcData.epochTypeOfOdor(handles.dropcData.epochIndex)=handles.dropcProg.typeOfOdor;
    handles.dropcData.epochTrial(handles.dropcData.epochIndex)=handles.dropcData.trialIndex;
    
    dropcFinalValveOK_hf(handles);
    
    %Odor on
    handles.dropcData.epochIndex=handles.dropcData.epochIndex+1;
    handles.dropcData.epochEvent(handles.dropcData.epochIndex)=2; %2 is odor on
    handles.dropcData.epochTime(handles.dropcData.epochIndex)=toc;
    odorOnTime=handles.dropcData.epochTime(handles.dropcData.epochIndex);
    handles.dropcData.epochTypeOfOdor(handles.dropcData.epochIndex)=handles.dropcProg.typeOfOdor;
    handles.dropcData.epochTrial(handles.dropcData.epochIndex)=handles.dropcData.trialIndex;
    

    [handles,trialResult]=dropcDoesMouseRespondNow_hfspm(handles);
    
    
    %Turn opto TTL off
    if (handles.dropcProg.whenOptoOn==2)
        dataValue=uint8(15);
        putvalue(handles.dio.Line(9:12),dataValue);
    end
    
    dropcTurnValvesOffNow(handles);
    
    %Odor off
    handles.dropcData.epochIndex=handles.dropcData.epochIndex+1;
    handles.dropcData.epochEvent(handles.dropcData.epochIndex)=3;  %3 is odor off
    handles.dropcData.epochTime(handles.dropcData.epochIndex)=toc;
    handles.dropcData.epochTypeOfOdor(handles.dropcData.epochIndex)=handles.dropcProg.typeOfOdor;
    handles.dropcData.epochTrial(handles.dropcData.epochIndex)=handles.dropcData.trialIndex;
    
    %result_of_trial=trialResult
    disp(['Result of trial= ' num2str(trialResult)])
<<<<<<< HEAD
    handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
=======
>>>>>>> db888181d401cf2289c1ad70c7831093bc78040b
    handles=dropcReinforceAppropriately_hf(handles);
    
    %Turn opto TTL off
    if (handles.dropcProg.whenOptoOn==3)
        dataValue=uint8(15);
        putvalue(handles.dio.Line(9:12),dataValue);
    end
    
    handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;
    dropcTurnValvesOffNow(handles);
    %Mouse must leave
    
    while dropcNosePokeNow(handles)==1
    end
    
    
    %Output record of trial performance
    if handles.dropcData.odorType(handles.dropcData.trialIndex-1)==handles.dropcProg.splusOdor
        if handles.dropcData.trialScore(handles.dropcData.trialIndex-1)==1
            handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'Hit '];
            
            handles.dropcData.epochIndex=handles.dropcData.epochIndex+1;
            handles.dropcData.epochEvent(handles.dropcData.epochIndex)=6;
            handles.dropcData.epochTime(handles.dropcData.epochIndex)=odorOnTime;
            handles.dropcData.epochTypeOfOdor(handles.dropcData.epochIndex)=handles.dropcProg.typeOfOdor;
            handles.dropcData.epochTrial(handles.dropcData.epochIndex)=handles.dropcData.trialIndex;
            
        else
            handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'Miss '];
            
            handles.dropcData.epochIndex=handles.dropcData.epochIndex+1;
            handles.dropcData.epochEvent(handles.dropcData.epochIndex)=7;
            handles.dropcData.epochTime(handles.dropcData.epochIndex)=odorOnTime;
            handles.dropcData.epochTypeOfOdor(handles.dropcData.epochIndex)=handles.dropcProg.typeOfOdor;
            handles.dropcData.epochTrial(handles.dropcData.epochIndex)=handles.dropcData.trialIndex;
        end
    else
        if handles.dropcData.trialScore(handles.dropcData.trialIndex-1)==1
            handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'FA '];
            
            handles.dropcData.epochIndex=handles.dropcData.epochIndex+1;
            handles.dropcData.epochEvent(handles.dropcData.epochIndex)=8;
            handles.dropcData.epochTime(handles.dropcData.epochIndex)=odorOnTime;
            handles.dropcData.epochTypeOfOdor(handles.dropcData.epochIndex)=handles.dropcProg.typeOfOdor;
            handles.dropcData.epochTrial(handles.dropcData.epochIndex)=handles.dropcData.trialIndex;
        else
            handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'CR '];
            
            handles.dropcData.epochIndex=handles.dropcData.epochIndex+1;
            handles.dropcData.epochEvent(handles.dropcData.epochIndex)=9;
            handles.dropcData.epochTime(handles.dropcData.epochIndex)=odorOnTime;
            handles.dropcData.epochTypeOfOdor(handles.dropcData.epochIndex)=handles.dropcProg.typeOfOdor;
            handles.dropcData.epochTrial(handles.dropcData.epochIndex)=handles.dropcData.trialIndex;
        end
    end
    
    if rem(handles.dropcData.trialIndex,20)==1
        handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance ' '];
    end
    
    dropcDisplayOutString(handles.dropcData.trialPerformance)
    
    if handles.dropcData.trialIndex-1>=20
        for trialNo=1:handles.dropcData.trialIndex-1
            if handles.dropcData.odorType(trialNo)==handles.dropcProg.splusOdor
                if handles.dropcData.trialScore(trialNo)==1
                    correctTrial(trialNo)=1;
                else
                    correctTrial(trialNo)=0;
                end
            else
                if handles.dropcData.trialScore(trialNo)==1
                    correctTrial(trialNo)=0;
                else
                    correctTrial(trialNo)=1;
                end
            end
        end
        
        max_block=floor((handles.dropcData.trialIndex-1)/20);
        if handles.dropcData.trialIndex>1
            if rem((handles.dropcData.trialIndex-1),20)==1
                block=block+1;
                percent_correct(block)= 100*sum(correctTrial((block-1)*20+1:block*20))/20;
                percent_corr_str=[percent_corr_str num2str(percent_correct(block)) ' '];
            end
        end
        
        
        disp(percent_corr_str)
    end
    
    
    save(handles.dropcProg.output_file,'handles');
    
    
    
    
    
end



delete(handles.dio)

clear handles

