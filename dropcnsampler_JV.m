%%Last modification Oct 13th
%%Time inter odors
%%Phantom in odd trials, always after a real odor stimulus
%%Jitter between trials only in phantom
%%Digital odors from 1 to 4, 5 to 8 goes in jv_2


%% Close all
clear all
close all

%% User should change these variables

%First file name for output
%IMPORTANT: This should be a .mat file
handles.dropcProg.output_file='C:\Users\restrepo\Desktop\Jorge\amwt6_oct142015_1';

%Change odors in each trial? yes=1, no=0 //Not in use
%change_odor_in_each_trial=1;


%Number of odors
handles.dropcProg.noOdors=8;


%Number of trials per odor
handles.dropcProg.trialsPerOdor=20;


%Time between trials
handles.dropcProg.dt_between_trials=12;

%Jitter between trials (set the value that will be multiplied by a random number between 0 and 1)
handles.dropcProg.dt_between_jitterrange=8;

%Time between odors (waiting time to clean tubings from previous odorants)
handles.dropcProg.dt_between_odors=90;


%Phantom odor? yes=1, no=0.
%This selection will eliminate odor stimulation at all
%odd trials
handles.dropcProg.phantomOdor=1;

%Phantom odor number
%phantomNumber=3;

%Now enter the information for each odor in this order:
%
%Valve number (1,2,4,8,16,32,64,128)
%Odor name

%Enter S+ valve (1,2,4,8,16,32,64,128) and odor name
%Note odor valves are 1-8 and unit8 are 1-128

handles.dropcProg.odorValves(1)=uint8(1);
handles.dropcProg.odorName{1}='MO';

handles.dropcProg.odorValves(2)=uint8(2);
handles.dropcProg.odorName{2}='Iso';

handles.dropcProg.odorValves(3)=uint8(4);
handles.dropcProg.odorName{3}='Octanal';

handles.dropcProg.odorValves(4)=uint8(8);
handles.dropcProg.odorName{4}='Isopentilamine';

handles.dropcProg.odorValves(5)=uint8(16);
handles.dropcProg.odorName{5}='Phenylethanol';

handles.dropcProg.odorValves(6)=uint8(32);
handles.dropcProg.odorName{6}='4-Methylthiazol';

handles.dropcProg.odorValves(7)=uint8(64);
handles.dropcProg.odorName{7}='Butanedione';

handles.dropcProg.odorValves(8)=uint8(128);
handles.dropcProg.odorName{8}='Urine';


%Enter final valve interval in sec
handles.dropcProg.fvtime=2;

%Enter odor on interval in sec
handles.dropcProg.odor_time=2;

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
    
        
        %%%%%%%%%ALL ODORS IN ORDER (all trials of a given odor at once)
        
    %%for odorNo=1:handles.dropcProg.noOdors
      for odorNo=1:4  
        handles.dropcProg.odorValve=handles.dropcProg.odorValves(odorNo);
            
        for trialNo=1:handles.dropcProg.trialsPerOdor
                
            OdorNumber=odorNo
            trialNumber=trialNo
                
            %%which means phantom odor at all odd trials
            if (mod((trialNo+1),2) && handles.dropcProg.phantomOdor==1)
                
                %Notify FV on (just notification)
                handles.dropcDigOut.draqPortStatus=uint8(4);
                dropcUpdateDraqPort(handles);
                    
                %Wait for the final valve period
                start_toc=toc;
                while (toc-start_toc<handles.dropcProg.fvtime)
                end
                    
                %Start phantom odor
                handles.dropcDigOut.draqPortStatus=uint8(16);
                dropcUpdateDraqPort(handles);
                    
                    
                %if handles.dropcProg.skipIntervals==0
                start_toc=toc;
                while (toc-start_toc<handles.dropcProg.odor_time)
                end
                %end
                    
                    
                %Turn off digital signal
                handles.dropcDigOut.draqPortStatus=uint8(0);
                dropcUpdateDraqPort(handles);
                    
                    
                start_toc=toc;
                while (toc-start_toc<0.4)
                end
                    
                %Notify draq of odor number, 9 is phantom
                handles.dropcDigOut.draqPortStatus=uint8(9);
                dropcUpdateDraqPort(handles);
                   
                'Phantom odor No'
                disp(9)
                    
                'digital odor'
                disp(handles.dropcDigOut.draqPortStatus)
                '--------------------------------'
                    
                start_toc=toc;
                while (toc-start_toc<0.3) 
                end
                    
                %Tturning on the draq acquisition board
                dropcStartDraq(handles)
                    
                %%waiting inter trial time 
                handles.dropcProg.dt_between_jitter=handles.dropcProg.dt_between_jitterrange*rand
                start_toc=toc;
                
                '--------------------------------'
                'Jitter'
                disp(handles.dropcProg.dt_between_jitter)
                '--------------------------------'
                
                while (toc-start_toc<handles.dropcProg.dt_between_trials+handles.dropcProg.dt_between_jitter)
                end
                        
            %%Actual odor stimulation        
            else
                    
                %%turning on the corresponding valves
                dropcTurnOdorValveOnNowWithFinalV(handles,odorNo);
                
                %during odor time
                start_toc=toc;
                while (toc-start_toc<handles.dropcProg.odor_time)
                end
                
                %%Turning valves off
                dropcTurnValvesOffNow(handles);
                
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
                
                
              
            end
            
            save(handles.dropcProg.output_file,'handles');
            
      
        %%while trials
        end
        
        
              
        %%waiting inter odors time 
            
        'changing odorant'
             disp(handles.dropcProg.dt_between_odors)
        '--------------------------------'
            
        start_toc=toc;
        while (toc-start_toc<handles.dropcProg.dt_between_odors)
        end
            
    %%while odors
    end

%%end ptogram    
end


finished_now='Done! :)'

delete(handles.dio)

clear handles