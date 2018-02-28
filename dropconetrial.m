<<<<<<< HEAD
%%Triggers the odor valve and laser on once
%%Modified from dropcnsampler_JV


%% Close all
clear all
close all

%% User should change these variables


%Enter S+ valve (1,2,4,8,16,32,64,128) and odor name
%Note odor valves are 1-8 and unit8 are 1-128

handles.dropcProg.odorValves(1)=uint8(1);
handles.dropcProg.odorName{1}='Iso';
%
% handles.dropcProg.odorValves(2)=uint8(2);
% handles.dropcProg.odorName{2}='Iso';
%
% handles.dropcProg.odorValves(3)=uint8(4);
% handles.dropcProg.odorName{3}='Octanal';
%
% handles.dropcProg.odorValves(4)=uint8(8);
% handles.dropcProg.odorName{4}='Isopentilamine';
%
% handles.dropcProg.odorValves(5)=uint8(16);
% handles.dropcProg.odorName{5}='Phenylethanol';
%
% handles.dropcProg.odorValves(6)=uint8(32);
% handles.dropcProg.odorName{6}='4-Methylthiazol';
%
% handles.dropcProg.odorValves(7)=uint8(64);
% handles.dropcProg.odorName{7}='Butanedione';
%
% handles.dropcProg.odorValves(8)=uint8(128);
% handles.dropcProg.odorName{8}='Urine';


%Enter final valve interval in sec
handles.dropcProg.fvtime=2;

%Enter odor on interval in sec
handles.dropcProg.odor_time=2;


%Open valve for background odor (1=yes, 0=no)
% handles.dropcProg.backgroundOdor=0;

%% Set the variables for testing
%handles.dropcProg.testProg=1;
%handles.dropcProg.skipIntervals=1;

%% Initialize variables that the user will not change


% dropcData
%Fellows random numbers are started randomly
handles.dropcData.fellowsNo=20*ceil(10*rand(1))-19;
handles.dropcData.trialIndex=1;     %These are all trials excluding shorts
handles.dropcData.allTrialIndex=1;  %These are all trials including short and long trials

%Note: handles.dropcData.allTrialResult 0=not licked, 1=licked, 2=short
%odor, 3=short FV

%Number of valves (do not change)
handles.dropcProg.noValves=8;
handles.dropcProg.timePerTrial=8;

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
handles.dropcDioOut.noise=uint8(8);
handles.dropcDioOut.background_valve=uint8(3);
handles.dropcDioOut.water_valve=uint8(1);







%% Now run the olfactometer


%Initialize the DIO96H/50 before the mouse comes in
handles=dropcInitializePortsNow(handles);




%Use odor 1
handles.dropcProg.odorValve=handles.dropcProg.odorValves(1);

%%turning on the corresponding valves
dropcTurnOdorValveOnNowWithFinalV(handles,odorNo);

%Turn laser on
dataValue=uint8(0);
putvalue(handles.dio.Line(9:12),dataValue);

%wait for odor time
start_toc=toc;
while (toc-start_toc<handles.dropcProg.odor_time)
end

%%Turning valves off
dropcTurnValvesOffNow(handles);

%Turn laser off
dataValue=uint8(15);
putvalue(handles.dio.Line(9:12),dataValue);

%Turn off digital signal
handles.dropcDigOut.draqPortStatus=uint8(0);
dropcUpdateDraqPort(handles);

start_toc=toc;
while (toc-start_toc<0.4)
end

%Notify draq of odor number
handles.dropcDigOut.draqPortStatus=uint8(odorNo);

dropcUpdateDraqPort(handles);

'digital odor'
disp(handles.dropcDigOut.draqPortStatus)
'--------------------------------'


start_toc=toc;
while (toc-start_toc<0.3)
end

handles.dropcDigOut.draqPortStatus=uint8(0);
dropcUpdateDraqPort(handles);

%Turning on the draq acquisition board
dropcStartDraq(handles);

%%waiting inter trial time

while (toc-start_toc<handles.dropcProg.dt_between_trials)
end



















finished_now='Done! :)'

delete(handles.dio)

clear handles

=======
%%Triggers the odor valve and laser on once
%%Modified from dropcnsampler_JV


%% Close all
clear all
close all

%% User should change these variables


%Enter S+ valve (1,2,4,8,16,32,64,128) and odor name
%Note odor valves are 1-8 and unit8 are 1-128

handles.dropcProg.odorValves(1)=uint8(1);
handles.dropcProg.odorName{1}='Iso';
%
% handles.dropcProg.odorValves(2)=uint8(2);
% handles.dropcProg.odorName{2}='Iso';
%
% handles.dropcProg.odorValves(3)=uint8(4);
% handles.dropcProg.odorName{3}='Octanal';
%
% handles.dropcProg.odorValves(4)=uint8(8);
% handles.dropcProg.odorName{4}='Isopentilamine';
%
% handles.dropcProg.odorValves(5)=uint8(16);
% handles.dropcProg.odorName{5}='Phenylethanol';
%
% handles.dropcProg.odorValves(6)=uint8(32);
% handles.dropcProg.odorName{6}='4-Methylthiazol';
%
% handles.dropcProg.odorValves(7)=uint8(64);
% handles.dropcProg.odorName{7}='Butanedione';
%
% handles.dropcProg.odorValves(8)=uint8(128);
% handles.dropcProg.odorName{8}='Urine';


%Enter final valve interval in sec
handles.dropcProg.fvtime=2;

%Enter odor on interval in sec
handles.dropcProg.odor_time=2;


%Open valve for background odor (1=yes, 0=no)
% handles.dropcProg.backgroundOdor=0;

%% Set the variables for testing
%handles.dropcProg.testProg=1;
%handles.dropcProg.skipIntervals=1;

%% Initialize variables that the user will not change


% dropcData
%Fellows random numbers are started randomly
handles.dropcData.fellowsNo=20*ceil(10*rand(1))-19;
handles.dropcData.trialIndex=1;     %These are all trials excluding shorts
handles.dropcData.allTrialIndex=1;  %These are all trials including short and long trials

%Note: handles.dropcData.allTrialResult 0=not licked, 1=licked, 2=short
%odor, 3=short FV

%Number of valves (do not change)
handles.dropcProg.noValves=8;
handles.dropcProg.timePerTrial=8;

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
handles.dropcDioOut.noise=uint8(8);
handles.dropcDioOut.background_valve=uint8(3);
handles.dropcDioOut.water_valve=uint8(1);







%% Now run the olfactometer


%Initialize the DIO96H/50 before the mouse comes in
handles=dropcInitializePortsNow(handles);




%Use odor 1
handles.dropcProg.odorValve=handles.dropcProg.odorValves(1);

%%turning on the corresponding valves
dropcTurnOdorValveOnNowWithFinalV(handles,odorNo);

%Turn laser on
dataValue=uint8(0);
putvalue(handles.dio.Line(9:12),dataValue);

%wait for odor time
start_toc=toc;
while (toc-start_toc<handles.dropcProg.odor_time)
end

%%Turning valves off
dropcTurnValvesOffNow(handles);

%Turn laser off
dataValue=uint8(15);
putvalue(handles.dio.Line(9:12),dataValue);

%Turn off digital signal
handles.dropcDigOut.draqPortStatus=uint8(0);
dropcUpdateDraqPort(handles);

start_toc=toc;
while (toc-start_toc<0.4)
end

%Notify draq of odor number
handles.dropcDigOut.draqPortStatus=uint8(odorNo);

dropcUpdateDraqPort(handles);

'digital odor'
disp(handles.dropcDigOut.draqPortStatus)
'--------------------------------'


start_toc=toc;
while (toc-start_toc<0.3)
end

handles.dropcDigOut.draqPortStatus=uint8(0);
dropcUpdateDraqPort(handles);

%Turning on the draq acquisition board
dropcStartDraq(handles);

%%waiting inter trial time

while (toc-start_toc<handles.dropcProg.dt_between_trials)
end



















finished_now='Done! :)'

delete(handles.dio)

clear handles

>>>>>>> db888181d401cf2289c1ad70c7831093bc78040b
