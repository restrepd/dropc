function isMouseIn = dropcNosePokeNow_ac(handles)
%Finds out whether user pressed 'S' for stop

switch handles.acces
    
    case 0
        
        photodiodeStatus=getvalue(handles.dio.Line(33:40));
        lickStatus=getvalue(handles.dio.Line(25:32));

        %Note: either the mouse blocks the photodiode or it is licking
        if ((sum(lickStatus)~=handles.dropcProg.sumNoLick)||(handles.dropcProg.sumPdOn~=sum(photodiodeStatus)))
            isMouseIn=1;
        else
            isMouseIn=0;
        end
        
    case 1
        
        %ACCES
        %UInt32 DIO_ReadAll(UInt32 DeviceIndex, out UInt32 pData)
        data = NET.createArray('System.Byte', 4);
        AIOUSBNet.AIOUSB.DIO_ReadAll(-3, data);
        %         data(2)
        %If you enter 3, you are reading byte 2: relays
        %If you enter 1 you are reading PA
        %If you enter 2 you read PB
        
        %         photodiodeBlocked=bitand(1,data(2));
        lickOn=bitand(1,data(2));
        %         %UInt32 DIO_ReadAll(UInt32 DeviceIndex, out UInt32 pData)
        %         data = NET.createArray('System.Byte', 4);
        %         AIOUSBNet.AIOUSB.DIO_ReadAll(-3, data);
        %         %         data(2)
        %         %If you enter 3, you are reading byte 2: relays
        %         %If you enter 1 you are reading PA
        %         %If you enter 2 you read PB
        %
        %         %         photodiodeBlocked=bitand(1,data(2));
        %         lickOn2=bitand(1,data(2));
        
        %Note: either the mouse blocks the photodiode or it is licking
        %         if (lickOn==1)&(lickOn2==1)
        if (lickOn==1)
            isMouseIn=1;
        else
            isMouseIn=0;
        end
end