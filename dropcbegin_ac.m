%% Close all
clear all
close all

%% User should change these variables

%First file name for output
%IMPORTANT: This should be a .mat file
handles.dropcProg.output_file='C:\Users\Olf2\Desktop\DEMJ3\tes.mat';

%Which begin stage do you want to start in (1 or 2)?
handles.begin.initStage=2;

%In stage 2, the program increments the time interval linearly from 0 in block 1 to 1.2s in block6
%Which block of stage 2 do you want the program to start in (1 to 7)?:
handles.begin.initBlock=1;


%BEGIN WILL USE S+: Enter S+ valve (1,2,4,8,16,32,64,128) and odor name
handles.dropcProg.splusOdorValve=int8(16); %Make sure to use int8
handles.dropcProg.splusName='Isoamyl acetate';


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
handles.dropcProg.rfTime=0.2;

%Enter time per trial (sec, typical 8 s)
%Must be larger than TIME_POST+shortTime+dt_ra*dropcProg.noRAsegments+2
handles.dropcProg.timePerTrial=8;

%This program does not send shorts to the recording computer
handles.dropcProg.sendShorts=0;

%If you are using ACCES boards enter 1, for measurement computing enter 0
handles.acces=1;

%These are outputs in relays
handles.acces_final_valve=64;
handles.acces_water_valve=32;

%These are outputs in PA
handles.acces_laser=64;

%Enter comment
handles.comment='Test';


%% Set the variables for testing
%handles.dropcProg.testProg=1;
%handles.dropcProg.skipIntervals=1;

%% Initialize variables that the user will not change


% dropcData
%Fellows random numbers are started randomly
handles.dropcData.fellowsNo=20*ceil(10*rand(1))-19;
handles.dropcData.trialIndex=1;
handles.dropcData.allTrialIndex=0;
handles.dropcData.oneTrialIndex=1;
handles.dropcData.oneTrialTime=[];

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

%% Then do all that needs to be done before the experiment starts
file_exists=exist(handles.dropcProg.output_file,'file');
run_program = 1;
if file_exists==2
    % Ask whether to overwrite
    choice = questdlg('File exists. Overwrite?', ...
        'Overwrite?', ...
        'Yes','No','No');
    % Handle response
    switch choice
        case 'Yes'
            
            run_program = 1;
        case 'No'
            
            run_program = 0;
            
    end
end



%Har coded to go-no go choices
handles.dropcProg.fracReinforcement(1)=1.0;
handles.dropcProg.fracReinforcement(2)=0;
handles.dropcProg.doBuzz=0;
reinforceSminus=0;


if handles.begin.initStage==1
    handles.begin.initBlock=1;
end


%% Now run the olfactometer
if run_program==1
    
    %Initialize the DIO96H/50 before the mouse comes in
    handles=dropcInitializePortsNow_ac(handles);
    
    % Ask user to get mouse in box
    mouse_in_cage = 0;
    while mouse_in_cage == 0
        choice = questdlg('Now place ths mouse in the box: Is the mouse in?', ...
            'Overwrite?', ...
            'Yes','No','No');
        % Handle response
        switch choice
            case 'Yes'
                
                mouse_in_cage = 1;
            case 'No'
                
                mouse_in_cage = 0;
                
        end
    end
    tic
    
    handles.dropcProg.odorValve=handles.dropcProg.splusOdorValve;
    handles.dropcProg.typeOfOdor=handles.dropcProg.splusOdor;
    
    
    handles.dropcData.ii_lick=[];
    
    if handles.begin.initStage==1
        handles.startStage1=toc;
        handles=dropcStageOne_ac(handles);
        handles.elapsedStage1=toc;
    end
    
    handles.startStage2=toc;
    handles=dropcStageTwo_ac(handles);
    handles.elapsedStage2=toc;
    
    save(handles.dropcProg.output_file,'handles');
    
end


    delete(handles.dio)

clear handles

