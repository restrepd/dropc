%% dropcbegin_hf_sprew
% Begin for reward Splus

%Close all
clear all
close all

%% User should change these variables

%First file name prefix for output
%IMPORTANT: Do not enter .mat
handles.dropcProg.output_file_prefix='C:\Users\Diego\Documents\Fabio\data\test.mat';
if strcmp(handles.dropcProg.output_file_prefix(end-3:end),'.mat')
    handles.dropcProg.output_file_prefix=handles.dropcProg.output_file_prefix(1:end-4);
end

handles.dropcProg.maxITI=120; %seconds

handles.dropcProg.firstTrial=1;

%Water is delivered after this interval regardless of licks
handles.dropcProg.dt_to_reinforcement=1;

%Which begin stage do you want to start in (1 or 2)?
handles.begin.initStage=2;

%In stage 2, the program increments the time interval linearly from 0 in block 1 to 1.2s in block6
%Which block of stage 2 do you want the program to start in (1 to 7)?:
handles.begin.initBlock=1;

%Reinforce on S+ only? (1=yes, go-no go, 0=no, reinforce both, go-go)
%FOR BEGIN THIS DOES NOT MAKE A DIFFERENCE
handles.dropcProg.go_nogo=1;

%BEGIN WILL USE S+: Enter S+ valve (1,2,4,8,16,32,64,128) and odor name
handles.dropcProg.splusOdorValve=int8(64); %Make sure to use int8
handles.dropcProg.splusName='isoamyl acetate';

%Enter S- valve (1,2,4,8,16,32,64,128) and odor name
%FOR BEGIN THIS DOES NOT MAKE A DIFFERENCE
handles.dropcProg.sminusOdorValve=int8(128); %Make sure to use int8
handles.dropcProg.sminusName='Mineral oil';

%Enter final valve interval in sec (USE 1.2s FOR BEGIN)
handles.dropcProg.fvtime=1.2;

%Enter time interval for short trial test (0.5 sec is usual)
handles.dropcProg.shortTime=0.5;

%Enter number of response area segments (usually 4, must be less than 6)
handles.dropcProg.noRAsegments=4;

%Enter response area DT for each rasponse area segment (0.5 sec is usual)
handles.dropcProg.dt_ra=0.5;

%Enter time to stop odor delivery in sec. Make >shortTime and <=dt_ra*noRAsegments+shortTime, normally 2.5 s
handles.dropcProg.odor_stop=2.5;

%Enter time for water delivery (sec, try 0.4 s)
handles.dropcProg.rfTime=0.3;

%Enter time per trial (sec, typical 8 s)
%Must be larger than TIME_POST+shortTime+dt_ra*dropcProg.noRAsegments+2
handles.dropcProg.timePerTrial=8;

%This program does not send shorts to the recording computer
handles.dropcProg.sendShorts=0;

%Enter comment
handles.comment='Test';


%% Set the variables for testing
%handles.dropcProg.testProg=1;
%handles.dropcProg.skipIntervals=1;

%% Initialize variables that the user will not change
handles.dropcProg.which_program=mfilename;
 
% dropcData
%Fellows random numbers are started randomly
handles.dropcData.fellowsNo=20*ceil(10*rand(1))-19;
handles.dropcData.trialIndex=0;
handles.dropcData.epochIndex=0;
handles.dropcData.shortIndex=1;
handles.dropcData.allTrialIndex=0;
handles.dropcData.eventIndex=0;
handles.dropcData.eventTime=zeros(1,1000);
handles.dropcData.event=zeros(1,1000);
handles.dropcData.ii_lick=zeros(1,300);
handles.dropcData.lick_toc=zeros(300,300);
handles.dropcData.program='dropcbegin.hf';

%Initialize the variables that define how the olfactometer runs
% dropcProg

%Set the variables that will not change
handles.dropcProg.numTrPerBlock=20;
handles.dropcProg.makeNoise = 0;
handles.dropcProg.consoleOut=1;
handles.dropcProg.splusOdor=1;
handles.dropcProg.sminusOdor=2;
handles.dropcProg.sumNoLick=8;
handles.dropcProg.sumPdOn=7;

%This is BEGIN!
handles.dropcProg.typeOfOdor=4;
%handles.dropcProg.typeOfOdor=handles.dropcProg.splusOdor;
handles.dropcProg.odorValve=handles.dropcProg.splusOdorValve;

%Set the numbers for digital output to DT3010
handles.dropcDraqOut.final_valve=uint8(6);
handles.dropcDraqOut.tdt_inhibit=uint8(64);
handles.dropcDraqOut.s_plus=uint8(1);
handles.dropcDraqOut.odor_onset=uint8(18);
handles.dropcDraqOut.short_before=uint8(32);
handles.dropcDraqOut.short_after=uint8(32);
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

%When do I turn the opto on? 0=no opto, 1=FV, 2=odor
handles.dropcProg.whenOptoOn=0;


%Get the random Fellows numbers for choosing S+/S- for trials
handles.dropcProg.randomFellows=dropcGetSlotnickOdorList();

%Setup reinforcements depending on whether the user chose go-no go vs. go-go
if handles.dropcProg.go_nogo==1
    %go-no go
    handles.dropcProg.fracReinforcement(1)=1.0;
    handles.dropcProg.fracReinforcement(2)=0;
    handles.dropcProg.doBuzz=0;
    reinforceSminus=0;
else
    %go-go
    reinforceSminus=1;
    dropcProg.doBuzz=1;
    dropcProg.fracReinforcement(1)=0.7;
    dropcProg.fracReinforcement(2)=0.7;
end

% dropcProg.fracReinforcement(3)=0.5;
% dropcProg.fracReinforcement(4)=1.0;

if handles.begin.initStage==1
    handles.begin.initBlock=1;
end




%% Now run the olfactometer


%Initialize the DIO96H/50 before the mouse comes in
handles=dropcInitializePortsNow(handles);

%wait for the trigger
fprintf(1, '\nWaiting for the trigger\n ');

while getvalue(handles.dio.Line(34))==1
end
tic
fprintf(1, '\nStart of session...\n ');

%The filename will include the time in format 30:
%ISO 8601: 'yyymmddTHHMMSS'
formatOut=30;
handles.dropcProg.output_file=[handles.dropcProg.output_file_prefix datestr(datetime,formatOut) 'begin.mat'];


handles.dropcProg.odorValve=handles.dropcProg.splusOdorValve;
handles.dropcProg.typeOfOdor=handles.dropcProg.splusOdor;


handles.dropcData.did_lick=[];



for noReinf=handles.dropcProg.firstTrial:200
    
    iti=rand()*(10+(noReinf/200)*(handles.dropcProg.maxITI-10));
    startTime=toc;
    while (toc-startTime)<iti
    end
  
    dropcFinalValveOKBegin_hf(handles)
    
    start_toc=toc;
    did_lick=0;
    time_to_lick=0;
    
    while ((time_to_lick<handles.dropcProg.dt_to_reinforcement)&(did_lick==0))
        if (sum(getvalue(handles.dio.Line(25:32)))~=handles.dropcProg.sumNoLick)
            did_lick=1;
        end
        time_to_lick=toc-start_toc;
    end
    
    handles.dropcData.did_lick(noReinf)=did_lick;
    
    dropcReinforceNow(handles);

    dropcTurnValvesOffNow(handles);
    
    if did_lick==1
        fprintf(1, '\nStage 1 Trial No: %d, time: %d, mouse licked', noReinf, toc);
    else
        fprintf(1, '\nStage 1 Trial No: %d, time: %d, mouse did not lick', noReinf, toc);
    end

    save(handles.dropcProg.output_file,'handles');

end

save(handles.dropcProg.output_file,'handles');



delete(handles.dio)

clear handles

