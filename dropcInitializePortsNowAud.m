function handles=dropcInitializePortsNowAud(handles)
%	Initialize the DIO96H/50


if handles.is_test==0
    %Create the digital I/O object dio
    %The installed adaptors and hardware IDs are found with daqhwinfo
    handles.dio = digitalio('mcc',1);
    
    %Add FIRSTPORTA for odor valves:
    addline(handles.dio,0:7,'out');
    
    %Add FIRSTPORTB for control of background odor valve
    addline(handles.dio,8:15,'out');
    
    %Add FIRSTPORTCL FIRSTPORTCH
    %FIRSTPORTCL 2-final valve	8-noise valve 4+1 Water
    addline(handles.dio,16:23,'out');
    
    %Add SECONDPORTA for lick detector
    addline(handles.dio,24:31,'in');
    
    %Add SECONDPORTB for photodiode detector
    addline(handles.dio,32:39,'in');
    
    %Add SECONDPORTCL SECONDPORTCH
    addline(handles.dio,40:47,'in');
    
    %Add THIRDPORTA
    addline(handles.dio,48:55,'out');
    
    %Add THIDPORTB for output to recording computer DT3010
    addline(handles.dio,56:63,'out');
    
    %Now initialize the DIO96H/50
    dropcTurnValvesOffNow(handles);
    
    %Turn off output to draq
    putvalue(handles.dio.Line(57:64),uint8(255));
    
    
    
    % Now get input from input ports
    % Note: It is important that this be done without the animal in the cage
    % because the program makes all decisions by comparing the values obtained
    % here to the values during the experiment
    
    %handles.dropcProg.photodiodeOn=getvalue(handles.dio.Line(33:40));
    
    %handles.dropcProg.noLick=getvalue(handles.dio.Line(25:32));
    
    %Turn off output to draq
    handles.dropcDigOut.draqPortStatus=uint8(0);
    dropcUpdateDraqPort(handles);
end
%1. Create the analog output throught the windows audio card
%The installed adaptors and hardware IDs are found with daqhwinfo
handles.aud.AO = analogoutput('winsound');

%2. Add channels - Add one channel to AO.
handles.aud.chan = addchannel(handles.aud.AO,1);

%3. Configure property values - Define an output time of four seconds, assign values
%to the basic setup properties, generate data to be queued, and queue the data with
%one call to putdata.

set(handles.aud.AO,'SampleRate',8000)
set(handles.aud.AO,'TriggerType','Manual')
handles.aud.ActualRate = get(handles.aud.AO,'SampleRate');

%4. Set sine wave click
handles.aud.duration = 0.02;
handles.aud.wait=0.2;
handles.aud.len = handles.aud.ActualRate*handles.aud.duration;
handles.aud.data = 2*sin(linspace(0,2*pi*4000,handles.aud.len))';
handles.aud.click_click_interval=0.5;

putdata(handles.aud.AO,handles.aud.data)

%4. Output data - Start AO, issue a manual trigger, and wait for the device object 
%to stop running.
start(handles.aud.AO)
trigger(handles.aud.AO)
wait(handles.aud.AO,handles.aud.wait)

