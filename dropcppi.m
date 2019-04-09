%% Close all
clear all
close all

%% User should change these variables

%First file name for output
%IMPORTANT: This should be a .mat file
handles.dropcProg.output_file='/Users/restrepd/Documents/projects/testdropc/m03nsampler.mat';

%Is this a test
handles.is_test=0;

%PPI delta times
handles.dropcProg.ppi_before_interval=2;
handles.dropcProg.ppi_between_interval=0.5;
%Number of odors
handles.dropcProg.noOdors=8;

handles.aud.loudness_increase=2;

%Number of trials per odor
handles.dropcProg.trialsPerOdor=20;

%Number of valves
handles.dropcProg.noValves=4;

%Time between trials
handles.dropcProg.min_dt_between_trials=60;
handles.dropcProg.delta_dt_between_trials=20;
handles.dropcProg.rand_dt=rand(1,1000);

%Now enter the information for each odor in this order:
%
%Valve number (1,2,4,8,16,32,64,128)
%Odor name

handles.dropcProg.odorValves(1)=1;
handles.dropcProg.odorName{1}='Hexyl isobutyrate';

handles.dropcProg.odorValves(2)=2;
handles.dropcProg.odorName{2}='1-octyne';

handles.dropcProg.odorValves(3)=8;
handles.dropcProg.odorName{3}='morpholine';

handles.dropcProg.odorValves(4)=128;
handles.dropcProg.odorName{4}='methyl salicylate';

handles.dropcProg.odorValves(5)=1;
handles.dropcProg.odorName{5}='Octyl isobutyrate';

handles.dropcProg.odorValves(6)=2;
handles.dropcProg.odorName{6}='2-octyne';

handles.dropcProg.odorValves(7)=8;
handles.dropcProg.odorName{7}='isoamylacetate';

handles.dropcProg.odorValves(8)=128;
handles.dropcProg.odorName{8}='2-heptanone';


%Enter final valve interval in sec
handles.dropcProg.fvtime=1;

%Enter laser on/ odo on interval in sec
handles.dropcProg.laser_time=1;

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
handles.dropcData.trialIndex=0;

%Initialize the variables that define how the olfactometer runs
% dropcProg

%Set the variables that will not change
handles.dropcProg.numTrPerBlock=20;
handles.dropcProg.makeNoise = 0;
handles.dropcProg.consoleOut=1;
handles.dropcProg.splusOdor=1;
handles.dropcProg.sminusOdor=2;

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


%% Now run the olfactometer
if run_program==1
    
    %Initialize the DIO96H/50 before the mouse comes in
    handles=dropcInitializePortsNowAud(handles);
    
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
    

    
    for trialNo=1:handles.dropcProg.trialsPerOdor
  
        trialNumber=trialNo

        start_toc=toc;
        while (toc-start_toc<handles.dropcProg.ppi_before_interval)
        end
        %end
        handles.aud.data = 2*sin(linspace(0,2*pi*4000,handles.aud.len))';
        dropcClick(handles)
        
        
        %if handles.dropcProg.skipIntervals==0
        start_toc=toc;
        while (toc-start_toc<handles.dropcProg.ppi_between_interval)
        end
        %end
        handles.aud.data = handles.aud.loudness_increase*2*sin(linspace(0,2*pi*4000,handles.aud.len))';
        dropcClick(handles)
        
        %Notify Data Wave
        dropcStartDraq(handles)
        
        
        start_toc=toc;
        while (toc-start_toc<handles.dropcProg.ppi_between_interval)
        end
        
        handles.dropcDigOut.draqPortStatus=0;
        dropcUpdateDraqPort(handles);

        
        %Wait between trials
        %if handles.dropcProg.skipIntervals==0
        start_toc=toc;
        while (toc-start_toc<(handles.dropcProg.min_dt_between_trials+handles.dropcProg.rand_dt(trialNo)*handles.dropcProg.delta_dt_between_trials))
        end
        %end
        

        save(handles.dropcProg.output_file,'handles');
        
    end
    
    
end


delete(handles.dio)

clear handles

