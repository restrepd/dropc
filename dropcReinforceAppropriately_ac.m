function dropcReinforceAppropriately_ac(handles)
%Turns all valves off

do_dt_punish=0;

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


if handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor
    %S+
    if handles.dropcData.trialScore(handles.dropcData.trialIndex)==1
        
        %Hit
        switch handles.acces
            
            case 0
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.hit;
                dropcUpdateDraqPort(handles);
            case 1
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.hit;
                if optoOn
                    handles.dropcDigOut.draqPortStatus=bitset(handles.dropcDigOut.draqPortStatus,8,1);
                end
                AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,handles.dropcDigOut.draqPortStatus);
        end
        
        start_toc=toc;
        while toc-start_toc<0.2
        end
        
        
        if rand(1)<=handles.dropcProg.fracReinforcement(1)
            
            %Turn on (or not) opto stimulus during reinforcement
            opto_on=0;
            handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=0;
            
            %Send out light pulse
            if (handles.dropcProg.whenOptoOn==3)
                switch handles.acces
                    
                    case 0
                        dataValue=uint8(0);
                        putvalue(handles.dio.Line(9:12),dataValue);
                        opto_on=1;
                        handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=1;
                    case 1
                        handles.dropcDigOut.draqPortStatus=bitset(handles.dropcDigOut.draqPortStatus,8,1);
                        handles.dropcDigOut.draqPortStatus=bitset(handles.dropcDigOut.draqPortStatus,7,1);
                        AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,handles.dropcDigOut.draqPortStatus);
                end
                
            end
            
            if handles.acces==0
                %Notify draq
                if opto_on==0
                    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve;
                else
                    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.opto_on;
                end
                dropcUpdateDraqPort(handles);
            end
            
            dropcReinforceNow_ac(handles);
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=1;
            
        else
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
        end
        
    else
        
        %Miss
        switch handles.acces
            
            case 0
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.miss;
                dropcUpdateDraqPort(handles);
            case 1
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.miss;
                if optoOn
                    handles.dropcDigOut.draqPortStatus=bitset(handles.dropcDigOut.draqPortStatus,8,1);
                end
                AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,handles.dropcDigOut.draqPortStatus);
        end
        
        
        start_toc=toc;
        while toc-start_toc<0.2
        end
        
        handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
        
    end
    
end

if handles.dropcProg.typeOfOdor==handles.dropcProg.sminusOdor
    %S-
    
    if (handles.dropcProg.go_nogo==1)
        
        %This is a go_nogo
        if handles.dropcData.trialScore(handles.dropcData.trialIndex)==0
            
            %Correct Rejection
            switch handles.acces
                
                case 0
                    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.correct_rejection;
                    dropcUpdateDraqPort(handles);
                case 1
                    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.correct_rejection;
                    if optoOn
                        handles.dropcDigOut.draqPortStatus=bitset(handles.dropcDigOut.draqPortStatus,8,1);
                    end
                    AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,handles.dropcDigOut.draqPortStatus);
            end
            
            
            
            start_toc=toc;
            while toc-start_toc<0.2
            end
            
            if rand(1)<=handles.dropcProg.fracReinforcement(2)
                
                
                reinforceNow_ac(handles);
                handles.dropcData.isReinforced(handles.dropcData.trialIndex)=1;
                
            else
                handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
            end
            
        else
            
            %False Alarm
            switch handles.acces
                
                case 0
                    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.false_alarm;
                    dropcUpdateDraqPort(handles);
                case 1
                    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.false_alarm;
                    if optoOn
                        handles.dropcDigOut.draqPortStatus=bitset(handles.dropcDigOut.draqPortStatus,8,1);
                    end
                    AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,handles.dropcDigOut.draqPortStatus);
            end
            
            
            start_toc=toc;
            while toc-start_toc<0.2
            end
            
            if handles.dropcProg.dt_punish>0
                do_dt_punish=1;
            end
            
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
            
        end
        
    else
        
        %This is a go_go
        if handles.dropcData.trialScore(handles.dropcData.trialIndex)==0
            
            %Correct Rejection
            switch handles.acces
                
                case 0
                    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.correct_rejection;
                    dropcUpdateDraqPort(handles);
                case 1
                    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.correct_rejection;
                    if optoOn
                        handles.dropcDigOut.draqPortStatus=bitset(handles.dropcDigOut.draqPortStatus,8,1);
                    end
                    AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,handles.dropcDigOut.draqPortStatus);
            end
            
            
            
            start_toc=toc;
            while toc-start_toc<0.2
            end
            
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
            
            
        else
            
            %False Alarm
            switch handles.acces
                
                case 0
                    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.false_alarm;
                    dropcUpdateDraqPort(handles);
                case 1
                    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.false_alarm;
                    if optoOn
                        handles.dropcDigOut.draqPortStatus=bitset(handles.dropcDigOut.draqPortStatus,8,1);
                    end
                    AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,handles.dropcDigOut.draqPortStatus);
            end
            
            
            start_toc=toc;
            while toc-start_toc<0.2
            end
            
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
            
            if rand(1)<=handles.dropcProg.fracReinforcement(2)
                
                
                dropcReinforceNow_ac(handles);
                handles.dropcData.isReinforced(handles.dropcData.trialIndex)=1;
                
            else
                handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
                
            end
        end
    end
end% end of S-

%This turns all off
if handles.acces==0
    handles.dropcDigOut.draqPortStatus=uint8(0);
    dropcUpdateDraqPort(handles);
else
    AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,0);
    AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),2,0);
end

%Wait until time per trial is over
start_toc=handles.dropcData.startTrialTime;
while toc-start_toc<handles.dropcProg.timePerTrial
end


if do_dt_punish==1
    pffft=1
    start_toc=toc;
    while toc-start_toc<handles.dropcProg.dt_punish
    end
    pffft=2
end



