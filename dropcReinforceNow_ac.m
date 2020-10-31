function dropcReinforceNow_ac(handles)
%Turns all valves off


if handles.acces==1
    %Find out if opto is on
    %ACCES
    %UInt32 DIO_ReadAll(UInt32 DeviceIndex, out UInt32 pData)
    data = NET.createArray('System.Byte', 4);
    AIOUSBNet.AIOUSB.DIO_ReadAll(-3, data);
    
    %If you enter 3, you are reading byte 2: relays
    %If you enter 1 you are reading PA
    %If you enter 2 you read PB
    
    optoOn=bitand(128,data(1));
    
end

switch handles.acces
    
    case 0
        %Notify Data Wave
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.reinforcement+handles.dropcDraqOut.draq_trigger;
        dropcUpdateDraqPort(handles);
        
        %Turn on water valve
        dataValue=handles.dropcDioOut.water_valve;
        dataValue=bitcmp(dataValue);
        putvalue(handles.dio.Line(17:24),dataValue);
    case 1
        %Notify INTAN
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.reinforcement;
        if optoOn
            handles.dropcDigOut.draqPortStatus=bitset(handles.dropcDigOut.draqPortStatus,8,1);
        end
        AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,uint8(handles.dropcDigOut.draqPortStatus));

        %Turn on water valve
        AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),2,bitcmp(uint8(handles.acces_water_valve),'uint8'));
        
end

%Wait for rfTime
start_time=toc;
while (toc-start_time<handles.dropcProg.rfTime)
end

if handles.acces==0
    handles.dropcDigOut.draqPortStatus=uint8(0);
    dropcUpdateDraqPort(handles);
    
    %Turn off water valve
    dataValue=uint8(0);
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(17:24),dataValue);
else
    AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,0);
    AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),2,255);
end

pffft=1;




