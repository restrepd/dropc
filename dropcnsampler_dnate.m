%% Close all
clear all
close all

%% User should change these variables

%First file name for output
%IMPORTANT: This should be a .mat file
handles.dropcProg.output_file='C:\Users\Justin\Documents\Dnate\test3.mat';

%Change odors in each trials?
change_odor_in_each_trial=1;


%Number of odors
handles.dropcProg.noOdors=1;
handles.dropcProg.phantomOdor=1;

%Number of trials per odor
handles.dropcProg.trialsPerOdor=12;


%Time between trials
handles.dropcProg.dt_between_trials=60;

%Now enter the information for each odor in this order:
%
%Valve number (1,2,4,8,16,32,64,128)
%Odor name

%Enter S+ valve (1,2,4,8,16,32,64,128) and odor name

handles.dropcProg.odorValves(1)=uint8(128);
handles.dropcProg.odorName{1}='Urine';

handles.dropcProg.odorValves(2)=uint8(2);
handles.dropcProg.odorName{2}='1-octyne';

handles.dropcProg.odorValves(3)=uint8(4);
handles.dropcProg.odorName{3}='morpholine';

handles.dropcProg.odorValves(4)=uint8(8);
handles.dropcProg.odorName{4}='methyl salicylate';

handles.dropcProg.odorValves(5)=uint8(16);
handles.dropcProg.odorName{5}='Octyl isobutyrate';

handles.dropcProg.odorValves(6)=uint8(32);
handles.dropcProg.odorName{6}='2-octyne';

handles.dropcProg.odorValves(7)=uint8(64);
handles.dropcProg.odorName{7}='isoamylacetate';

handles.dropcProg.odorValves(8)=uint8(128);
handles.dropcProg.odorName{8}='2-heptanone';


%Enter final valve interval in sec
handles.dropcProg.fvtime=1;

%Enter odor on interval in sec
handles.dropcProg.odor_time=45;

%Enter comment
handles.comment='Test';

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


%% Now run the olfactometer
if run_program==1
    
    %Initialize the DIO96H/50 before the mouse comes in
    handles=dropcInitializePortsNow(handles);
    
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
    
    if change_odor_in_each_trial==0
        %All odors in order
        
        for odorNo=1:handles.dropcProg.noOdors
            
            
            handles.dropcProg.odorValve=handles.dropcProg.odorValves(odorNo);
            for trialNo=1:handles.dropcProg.trialsPerOdor
                
                OdorNumber=odorNo
                trialNumber=trialNo
                
                dropcTurnOdorValveOnNowWithFinalV(handles,odorNo);
                
                
                
                %if handles.dropcProg.skipIntervals==0
                start_toc=toc;
                while (toc-start_toc<handles.dropcProg.odor_time)
                end
                %end
                
                %                 %Turn off the laser light signal
                %                 handles.dropcDigOut.draqPortStatus=uint8(0);
                %                 dropcUpdateDraqPort(handles);
                
                
                
                dropcTurnValvesOffNow(handles);
                
                %Turn off the laser light signal
                handles.dropcDigOut.draqPortStatus=uint8(0);
                dropcUpdateDraqPort(handles);
                
                start_toc=toc;
                while (toc-start_toc<0.4)
                end
                
                %Notify draq of odor number
                handles.dropcDigOut.draqPortStatus=uint8(2^odorNo);
                dropcUpdateDraqPort(handles);
                
                start_toc=toc;
                while (toc-start_toc<0.3)
                end
                
                %This is there to turn on the draq acquisition
                dropcStartDraq(handles)
                
                
                dropcTurnValvesOffNow(handles);
                
                save(handles.dropcProg.output_file,'handles');
                
                %Wait between trials
                %if handles.dropcProg.skipIntervals==0
                if handles.dropcProg.phantomOdor==0
                    start_toc=toc;
                    while (toc-start_toc<handles.dropcProg.dt_between_trials)
                    end
                else
                    start_toc=toc;
                    while (toc-start_toc<handles.dropcProg.dt_between_trials/2)
                    end
                    
                    
                    %Phantom start of odor
                    handles.dropcDigOut.draqPortStatus=uint8(16);
                    dropcUpdateDraqPort(handles);
                    
                    
                    %if handles.dropcProg.skipIntervals==0
                    start_toc=toc;
                    while (toc-start_toc<handles.dropcProg.odor_time)
                    end
                    %end

                    
                    %Turn off the laser light signal
                    handles.dropcDigOut.draqPortStatus=uint8(0);
                    dropcUpdateDraqPort(handles);
                    
                    start_toc=toc;
                    while (toc-start_toc<0.4)
                    end
                    
                    %Notify draq of odor number
                    handles.dropcDigOut.draqPortStatus=uint8(64);
                    dropcUpdateDraqPort(handles);
                    
                    start_toc=toc;
                    while (toc-start_toc<0.3)
                    end
                    
                    %This is there to turn on the draq acquisition
                    dropcStartDraq(handles)
                    
                    start_toc=toc;
                    while (toc-start_toc<handles.dropcProg.dt_between_trials/2)
                    end
                    
                end
                %end
                
                
                
            end
            
        end
    else
        %Change odor in each trial
        for trialNo=1:handles.dropcProg.trialsPerOdor*handles.dropcProg.noOdors
            for odorNo=1:handles.dropcProg.noOdors
                
                
                
                handles.dropcProg.odorValve=handles.dropcProg.odorValves(odorNo);
                
                
                OdorNumber=odorNo
                trialNumber=trialNo
                
                dropcTurnOdorValveOnNowWithFinalV(handles,odorNo);
                
                
                
                %if handles.dropcProg.skipIntervals==0
                start_toc=toc;
                while (toc-start_toc<handles.dropcProg.odor_time)
                end
                %end
                
                dropcTurnValvesOffNow(handles);
                
                %Turn off the laser light signal
                handles.dropcDigOut.draqPortStatus=uint8(0);
                dropcUpdateDraqPort(handles);
                
                
                %
                
                
                start_toc=toc;
                while (toc-start_toc<0.4)
                end
                
                %Notify draq of odor number
                handles.dropcDigOut.draqPortStatus=uint8(2^odorNo);
                dropcUpdateDraqPort(handles);
                
                start_toc=toc;
                while (toc-start_toc<0.3)
                end
                
                %This is there to turn on the draq acquisition
                dropcStartDraq(handles)
                
                
%                 dropcTurnValvesOffNow(handles);
%                 
                save(handles.dropcProg.output_file,'handles');
                
                %Wait between trials
                %if handles.dropcProg.skipIntervals==0
                if handles.dropcProg.phantomOdor==0
                    start_toc=toc;
                    while (toc-start_toc<handles.dropcProg.dt_between_trials)
                    end
                else
                    start_toc=toc;
                    while (toc-start_toc<handles.dropcProg.dt_between_trials/2)
                    end
                    
                    
                    %Phantom start of odor
                    handles.dropcDigOut.draqPortStatus=uint8(16);
                    dropcUpdateDraqPort(handles);
                    
                    
                    %if handles.dropcProg.skipIntervals==0
                    start_toc=toc;
                    while (toc-start_toc<handles.dropcProg.odor_time)
                    end
                    %end

                    
                    %Turn off the laser light signal
                    handles.dropcDigOut.draqPortStatus=uint8(0);
                    dropcUpdateDraqPort(handles);
                    
                    start_toc=toc;
                    while (toc-start_toc<0.4)
                    end
                    
                    %Notify draq of odor number
                    handles.dropcDigOut.draqPortStatus=uint8(64);
                    dropcUpdateDraqPort(handles);
                    
                    start_toc=toc;
                    while (toc-start_toc<0.3)
                    end

                    %This is there to turn on the draq acquisition
                    dropcStartDraq(handles)
                    
                    start_toc=toc;
                    while (toc-start_toc<handles.dropcProg.dt_between_trials/2)
                    end
                    
                    save(handles.dropcProg.output_file,'handles');
                end
                
                
              elapsed_time=toc  
            end
            
        end
    end
end

finished_now='Done! :)'

delete(handles.dio)

clear handles

