function handles=dropcInitializePortsNowTiny(handles)
%	Initialize the DIO96H/50


    
    %Create the digital I/O object dio
    %The installed adaptors and hardware IDs are found with daqhwinfo
    handles.dio = digitalio('mcc',0);
    
    %Add CL for odor valves:
    addline(handles.dio,0:3,'out');
    
    %Add CH for control of background odor valve
    addline(handles.dio,4:7,'in');
    
    
    %Now initialize the USB-RI08
    
    %Turns off odor valves
    putvalue(handles.dio.Line(1:4),uint8(0));
    

    
    
