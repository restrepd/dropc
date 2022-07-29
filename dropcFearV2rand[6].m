
  %dropcFearv2random (dropcfear) runs an odor-associated fear conditioning
  %paradigm with balanced, restricted randomization & experimenter blinding
%task

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

%First file name for output
%IMPORTANT: This should be a .mat file
handles.dropcProg.output_file='C:\Users\Huntsman Lab\Desktop\Data\OdorFC_mns\B6P21CFC\L1M3B6P2106112019parameters.mat'; %filename should use this formating (L_M_Genotype_Age_Date_parameters. i.e. L1M3B6P2106112019parameters.mat)
%handles.dropcProg.output_file='/Users/Huntsman Lab/Desktop/Data/SamR/dropc_spm_SOM/contDay1mns';


%Enter odor a  valve (1,2,4,8,16,32,64,128) and odor name
handles.dropcProg.OdorValve=uint8(8); %Make sure to use int8
handles.dropcProg.odorName='iso';

%Enter final valve interval in sec (1.5 sec is usual)
handles.dropcProg.fvtime=1.5;

%Number of odor stimulations
handles.dropcProg.numberOfStimulations=1;
% handles.dropcProg.numberOfStimulations=8;
% handles.dropcProg.numberOfStimulations=4;

%Time the odor is on
handles.dropcProg.odorTime=5;
% handles.dropcProg.odorTime=30;

handles.dropcProg.preOdorTime=1*30;
% handles.dropcProg.preOdorTime=10*60;
% handles.dropcProg.preOdorTime=4*60;

% %Time shock is delivered
handles.dropcProg.shockTime=1;
handles.dropcProg.noshockTime=0;

% %Wait time for unpaired shock
handles.dropcProg.shockwaitTime=60;

%Enter final purge time
handles.dropcProg.finalPurgeTime=5;

%Enter delay interval
handles.dropcProg.interTrialInterval=60;
% handles.dropcProg.interTrialInterval=240;
% handles.dropcProg.interTrialInterval=120;


%Enter comment
handles.comment='Test';



%% Initialize variables that the user will not change

% dropcData
handles.dropcData.trialIndex=1;     %These are all trials excluding shorts



%Initialize the variables that define how the olfactometer runs
% dropcProg

% %Set the numbers for digital output to DT3010
% handles.dropcDraqOut.final_valve=uint8(1);
% handles.dropcDraqOut.opto_on=uint8(64);
% handles.dropcDraqOut.odorA=uint8(2);
% handles.dropcDraqOut.odorB=uint8(4);
% handles.dropcDraqOut.short=uint8(8);
% handles.dropcDraqOut.draq_trigger=uint8(128);
% handles.dropcDraqOut.reinforcement=uint8(16);

%Set the numbers for digital output to olfactometer DIO96H/50
handles.dropcDioOut.final_valve=uint8(2);
handles.dropcDioOut.purge_valve=uint8(4);
handles.dropcDioOut.shock=uint8(255);
handles.dropcDioOut.noise=uint8(8);
handles.dropcDioOut.background_valve=uint8(3);
handles.dropcDioOut.water_valve=uint8(1);

%% Then do all that needs to be done before the experiment starts
file_exists=exist(handles.dropcProg.output_file,'file');
run_program = 1;
if file_exists==2
    % Tell user to change the name
    run_program=0;
    h = msgbox('dropcspm cannot run: File already exists; change name');
end

%% ask user for litter parameters
%
M = input('Enter litter number:');
N = input('Enter number of animals in this litter:');
%

%% random assignment with balance of trial type to each mouse
% typeTrial = randi([1 3],1,N); %randomizes without balance
%
for i = N
typeTriali = zeros(1, i);
typeTriali(1,1:i) = 1;
typeTriali(1,2:i) = 2;
typeTriali(1,3:i) = 3;
typeTriali(1,4:i) = 1;
typeTriali(1,5:i) = 2;
typeTriali(1,6:i) = 3;
typeTriali(1,7:i) = 1;
typeTriali(1,8:i) = 2;
typeTriali(1,9:i) = 3;
typeTriali(1,10:i) = randi([1 3]);
typeTriali(1,11:i) = randi([1 3]);
typeTriali(1,12:i) = randi([1 3]);
typeTrial = typeTriali(randperm(length(typeTriali)));
end

%% Now run the olfactometer

%Initialize the DIO96H/50 before the mouse comes in
handles=dropcInitializePortsNow(handles);

% Ask user to get mouse in box
mouse_in_cage = 0;
while mouse_in_cage == 0
    choice = questdlg('Do you want to start?', ...
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

%% run randomized protocol for each mouse in litter
for i=1:N
    mNum = input('Enter mouse number: ');
    S = input('Enter mouse sex:','s');
    protocol_no = typeTrial(1, mNum);
    mouseinfo{i} = {'Litter #' 'N' 'Mouse #' 'Protocol_No' 'Sex' 'Protocol Perm' ; M N mNum protocol_no S typeTrial};
    
    switch protocol_no
        case 1 %odor only
            
            %Wait for the pre odor time
startTime=toc;
while toc-startTime<handles.dropcProg.preOdorTime
end

for trialIndex=1:handles.dropcProg.numberOfStimulations
    %Do one trial
    
    fprintf('\n')
    %Decide which are odor 1 and 2
    
    
    
    %Now run the trial
    

    
    %Divert final valve towards the exhaust
    %Divert purge valve towards the port
    dataValue = handles.dropcDioOut.final_valve+handles.dropcDioOut.purge_valve;
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(17:24),dataValue);
    
    
    %Turn on odor valve
    dataValue=handles.dropcProg.OdorValve;
    dataValue=bitcmp(uint8(dataValue));
    putvalue(handles.dio.Line(1:8),dataValue);
    
    
    %if handles.dropcProg.skipIntervals==0
    start_toc=toc;
    while (toc-start_toc<handles.dropcProg.fvtime)
    end
    %end
    
    
    %Turn FinalValve towards the odor port: turn on odor...)
    
    dataValue=bitcmp(uint8(0));
    putvalue(handles.dio.Line(17:24),dataValue);
    
    
    
    %Wait for the end of odor stimulation
    this_time=toc;
    while toc-this_time<handles.dropcProg.odorTime
    end
    
    %Now purge out odor
    
    %Divert final valve towards the exhaust
    %Divert purge valve towards the port
    dataValue = handles.dropcDioOut.final_valve+handles.dropcDioOut.purge_valve;
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(17:24),dataValue);
    
    
    %Turn off odor valve
    dataValue=0;
    dataValue=bitcmp(uint8(dataValue));
    putvalue(handles.dio.Line(1:8),dataValue);
    
    
    
    
    %Wait for the purge time
    this_time=toc;
    while toc-this_time<handles.dropcProg.finalPurgeTime
    end
    
    
    
    
    %Turn FinalValve towards the odor port: turn on odor...)
    dataValue=bitcmp(uint8(0));
    putvalue(handles.dio.Line(17:24),dataValue);
    
    
    
    %Wait for the end of inter trial interval
    this_time=toc;
    while toc-this_time<handles.dropcProg.interTrialInterval
    end
    
    save(handles.dropcProg.output_file,'handles');
    
end
    
        case 2 %paired 
            
            
            %Wait for the pre odor time
startTime=toc;
while toc-startTime<handles.dropcProg.preOdorTime
end

for trialIndex=1:handles.dropcProg.numberOfStimulations
    %Do one trial
    
    fprintf('\n')
    %Decide which are odor 1 and 2
    
    
    
    %Now run the trial
    

    
    %Divert final valve towards the exhaust
    %Divert purge valve towards the port
    dataValue = handles.dropcDioOut.final_valve+handles.dropcDioOut.purge_valve;
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(17:24),dataValue);
    
    
    %Turn on odor valve
    dataValue=handles.dropcProg.OdorValve;
    dataValue=bitcmp(uint8(dataValue));
    putvalue(handles.dio.Line(1:8),dataValue);
    
    
    %if handles.dropcProg.skipIntervals==0
    start_toc=toc;
    while (toc-start_toc<handles.dropcProg.fvtime)
    end
    %end
    
    
    %Turn FinalValve towards the odor port: turn on odor...)
    
    dataValue=bitcmp(uint8(0));
    putvalue(handles.dio.Line(17:24),dataValue);
    
    
    
    %Wait for the end of odor stimulation
    this_time=toc;
    while toc-this_time<handles.dropcProg.odorTime
    end
    
    %Give shock
    dataValue = handles.dropcDioOut.shock;
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(9:16),dataValue);
    
    %Wait for the end of shock
    this_time=toc;
    while toc-this_time<handles.dropcProg.shockTime
    end
    
    %Give shock
    dataValue = uint8(0);
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(9:16),dataValue);
    
    %Now purge out odor
    
    %Divert final valve towards the exhaust
    %Divert purge valve towards the port
    dataValue = handles.dropcDioOut.final_valve+handles.dropcDioOut.purge_valve;
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(17:24),dataValue);
    
    
    %Turn off odor valve
    dataValue=0;
    dataValue=bitcmp(uint8(dataValue));
    putvalue(handles.dio.Line(1:8),dataValue);
    
    
    
    
    %Wait for the purge time
    this_time=toc;
    while toc-this_time<handles.dropcProg.finalPurgeTime
    end
    
    
    
    
    %Turn FinalValve towards the odor port: turn on odor...)
    dataValue=bitcmp(uint8(0));
    putvalue(handles.dio.Line(17:24),dataValue);
    
    
    
    %Wait for the end of inter trial interval
    this_time=toc;
    while toc-this_time<handles.dropcProg.interTrialInterval
    end
    
    save(handles.dropcProg.output_file,'handles');
    
end
    
        case 3 %unpaired
            
      
            %Wait for the pre odor time
startTime=toc;
while toc-startTime<handles.dropcProg.preOdorTime
end

for trialIndex=1:handles.dropcProg.numberOfStimulations
    %Do one trial
    
    fprintf('\n')
    %Decide which are odor 1 and 2
    
    
    
    %Now run the trial
    

    
    %Divert final valve towards the exhaust
    %Divert purge valve towards the port
    dataValue = handles.dropcDioOut.final_valve+handles.dropcDioOut.purge_valve;
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(17:24),dataValue);
    
    
    %Turn on odor valve
    dataValue=handles.dropcProg.OdorValve;
    dataValue=bitcmp(uint8(dataValue));
    putvalue(handles.dio.Line(1:8),dataValue);
    
    
    %if handles.dropcProg.skipIntervals==0
    start_toc=toc;
    while (toc-start_toc<handles.dropcProg.fvtime)
    end
    %end
    
    
    %Turn FinalValve towards the odor port: turn on odor...)
    
    dataValue=bitcmp(uint8(0));
    putvalue(handles.dio.Line(17:24),dataValue);
    
    
    %Wait for the end of odor stimulation
    this_time=toc;
    while toc-this_time<handles.dropcProg.odorTime
    end
    
    
    %Now purge out odor
    
    %Divert final valve towards the exhaust
    %Divert purge valve towards the port
    dataValue = handles.dropcDioOut.final_valve+handles.dropcDioOut.purge_valve;
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(17:24),dataValue);
    
    
    %Turn off odor valve
    dataValue=0;
    dataValue=bitcmp(uint8(dataValue));
    putvalue(handles.dio.Line(1:8),dataValue);
  
    
    %Wait for the purge time
    this_time=toc;
    while toc-this_time<handles.dropcProg.finalPurgeTime
    end
    
    %Turn FinalValve towards the odor port: turn on odor...)
    dataValue=bitcmp(uint8(0));
    putvalue(handles.dio.Line(17:24),dataValue);
    
     %Wait to apply unpaired shock
    this_time=toc;
    while toc-this_time<handles.dropcProg.shockwaitTime
    end
    
    %Give shock
    dataValue = handles.dropcDioOut.shock;
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(9:16),dataValue);
    
    %Wait for the end of shock
    this_time=toc;
    while toc-this_time<handles.dropcProg.shockTime
    end
    
    %Give shock
    dataValue = uint8(0);
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(9:16),dataValue);
    
    
    %Wait for the end of inter trial interval
    this_time=toc;
    while toc-this_time<handles.dropcProg.interTrialInterval
    end
    
    save(handles.dropcProg.output_file,'handles');
    
end
        otherwise
            disp('doh!')
    end
end
%

%% save output variables
save('L1M3B6P2106112019_mouseinfo', 'mouseinfo') %filename should use this formating (L_M__Genotype_Age_Date_mouseinfo. i.e. L1M3B6P2106112019_mouseinfo.mat)

%% 
msgbox('Conditioning Complete!')

delete(handles.dio)

clear handles

