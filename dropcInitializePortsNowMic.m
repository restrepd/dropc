function handles=dropcInitializePortsNowMic(handles)
%	Initialize the DIO96H/50


    
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
    
    
    %Initialize microphone input
    
    %Create analog input object
    handles.ai=analoginput('winsound'); 


    %Add channels
    addchannel(handles.ai,1);
    
    %Set frequency
    set(handles.ai,'SampleRate',handles.dropcProg.freq)
    
    %Set samples per trigger
    dt=handles.dropcProg.shortTime+handles.dropcProg.noRAsegments*handles.dropcProg.dt_ra;
    set(handles.ai,'SamplesPerTrigger',freq*dt)
    
