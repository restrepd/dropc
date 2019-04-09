function handles=dropcInitializePortsNow_ac(handles)
%Initialize the board



switch handles.acces
    
    case 0
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
        
        %Turn off laser
        putvalue(handles.dio.Line(9:12),uint8(15));
        
        
        
        % Now get input from input ports
        % Note: It is important that this be done without the animal in the cage
        % because the program makes all decisions by comparing the values obtained
        % here to the values during the experiment
        
        %handles.dropcProg.photodiodeOn=getvalue(handles.dio.Line(33:40));
        
        %handles.dropcProg.noLick=getvalue(handles.dio.Line(25:32));
        
        %Turn off output to draq
        handles.dropcDigOut.draqPortStatus=uint8(0);
        dropcUpdateDraqPort(handles);
        
    case 1
        %	Initialize the ACCES USBP-DIO16RO8
        NET.addAssembly('C:\WINDOWS\Microsoft.Net\assembly\GAC_MSIL\AIOUSBNet\v4.0_1.0.0.1__d76f0a196c9d89ea\AIOUSBNet.dll');
        pause(2)
        import AIOUSBNet.AIOUSB.*
        
        %Confugure
        %UInt32 DIO_Configure(UInt32 DeviceIndex, Byte Tristate, Byte[] OutMask, Byte[] Data);
        %Here we configure PA to output and PB to input
        data_config = NET.createArray('System.Byte', 4);
        for ii=1:4
            data_config(ii)=0;
        end
        
        out_in_config = NET.createArray('System.Byte', 4);
        for ii=1:4
            out_in_config(ii)=0;
        end
        out_in_config(1)=1;
        
        DIO_Configure(-3, 0, out_in_config, data_config);
        
        %Relays RO8
        %We will use the first six relays for odor valves
        %Bits 0-5 is for valves
        %Bit 6 of the relay bank  is the final valve
        %Bit 7 of the relay bank  is the water valve 
        
        %OUTPUTS are in the first TTL byte (PA)
        %Bits 0-6 go to the INTAN digital input
        %Bit 7 goes to the laser
       
        %INPUTS are in second TTL byte PB
        %Bit 0 is licks
        %Bit 1 is the photodiode 

        %Turn off output to INTAN and laser
        %DIO_Write8(UInt32 DeviceIndex, UInt32 ByteIndex, out Byte pData)
        %Byte indices 0 (PA) and 1 (PB) are TTLs and 2 is relays, values between 0 and 256
        DIO_Write8(uint32(-3),0,0);
        DIO_Write8(uint32(-3),2,0);
        
end

