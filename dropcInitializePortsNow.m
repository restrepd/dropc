function handles=dropcInitializePortsNow(handles)
%	Initialize the DIO96H/50


    
    %Create the digital I/O object dio
    %The installed adaptors and hardware IDs are found with daqhwinfo
    handles.dio = digitalio('mcc',0);
    
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
    
    %Turn laser trigger off
    putvalue(handles.dio.Line(9:12),uint8(15));
    
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
    pffft=1
    
