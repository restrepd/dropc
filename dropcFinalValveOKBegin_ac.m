function finalValveOK = dropcFinalValveOKBegin_ac(handles)
%Opens final valve and odor on and finds out whtehr the mouse stays in the
%odor sampling area

start_toc=toc;

noSamples=0;
noSamplesMouseOn=0;

finalValveOK=1;

%During begin fvtime increases monotonically as a function of trialIndex
group=floor(handles.dropcData.trialIndex/20)+1;
if (group<=6)
    fvtime=(group-1)*handles.dropcProg.fvtime/5;
else
    fvtime=handles.dropcProg.fvtime;
end



%Turn final valve and odor on, etc...

%Notify INTAN
switch handles.acces
    case 0
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.s_plus;
        dropcUpdateDraqPort(handles);
    case 1
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.s_plus;
        AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,uint8(handles.dropcDigOut.draqPortStatus));
end


%Divert final valve towards the exhaust and the purge valve towars the port
switch handles.acces
    
    case 0
        %Divert final valve
        dataValue = handles.dropcDioOut.final_valve+handles.dropcDioOut.purge_valve;
        if handles.dropcProg.makeNoise==1
            dataValue = dataValue+handles.dropcDioOut.noise;
        end
        dataValue=bitcmp(dataValue);
        
        putvalue(handles.dio.Line(17:24),dataValue);
        
        %Turn on odor valve
        dataValue=handles.dropcProg.odorValve;
        dataValue=bitcmp(uint8(dataValue));
        
        putvalue(handles.dio.Line(1:8),dataValue);
    case 1
        
        %DIO_Write8(UInt32 DeviceIndex, UInt32 ByteIndex, out Byte pData)
        %Byte indices 0 (PA) and 1 (PB) are TTLs and 2 is relays, values between 0 and 256
        AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),2,bitcmp(uint8(handles.acces_final_valve+handles.dropcProg.odorValve),'uint8'));
end




%Wait for fv time and find out whether the mouse is poking
while (toc-start_toc<fvtime)
    noSamples=noSamples+1;
    if dropcNosePokeNow_ac(handles)==1
        noSamplesMouseOn=noSamplesMouseOn+1;
    end
end


%Notify INTAN of odor onset
switch handles.acces
    
    case 0
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset+handles.dropcDraqOut.s_plus;
        dropcUpdateDraqPort(handles);
    case 1
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset+handles.dropcDraqOut.s_plus;
        AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,uint8(handles.dropcDigOut.draqPortStatus));
end


%Turn FinalValve towards the odor port: turn purge to exhaust, turn on odor...)
switch handles.acces
    
    case 0
        
        dataValue=bitcmp(uint8(0));
        putvalue(handles.dio.Line(17:24),dataValue);
        
        %Turn opto TTL off
        if (handles.dropcProg.whenOptoOn==1)
            dataValue=uint8(15);
            putvalue(handles.dio.Line(9:12),dataValue);
        end
    case 1
        %Divert final valve and turn odor valve on
        AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),2,bitcmp(uint8(handles.dropcProg.odorValve),'uint8'));
        
end


if (fvtime<0.3)
    finalValveOK=1;
else
    
    if (noSamplesMouseOn/noSamples) > 0.2
        finalValveOK=1;
    else
        finalValveOK=0;
    end
end

pffft=1;

