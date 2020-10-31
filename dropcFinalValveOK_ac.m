function finalValveOK = dropcFinalValveOK_ac(handles)
%Diverts final valve towards the exhaust, turns valve odor on, finds out whther the mouse stays in the
%odor sampling area and turns the final valve back towards the port

start_toc=toc;

noSamples=0;
noSamplesMouseOn=0;

if (handles.dropcProg.typeOfOdor==4)
    
    %During begin fvtime increases monotonically as a function of trialIndex
    group=floor(handles.dropcData.trialIndex/20)+1;
    if (group<=6)
        fvtime=(group-2)*handles.dropcProg.fvtime/5;
    else
        fvtime=handles.dropcProg.fvtime;
    end

else
    %Otherwise, fvtime falls randomly between 1 and 1.5
    fvtime = 0.666666*handles.dropcProg.fvtime +0.333333*handles.dropcProg.fvtime*rand(1);
end



%Notify INTAN, turn final valve and odor on, etc...


%Turn on (or not) opto stimulus during FV
opto_on=0;
handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=0;
if (handles.dropcProg.whenOptoOn==1)
    opto_on=1;
    handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=1;
end

%Notify INTAN

if opto_on==0
    if (handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor)
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.s_plus;
    else
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve;
    end
else
    if (handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor)
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.s_plus+handles.acces_laser;
    else
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.acces_laser;
    end
end
AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,uint8(handles.dropcDigOut.draqPortStatus));


%Divert final valve towards the exhaust
%Divert purge valve towards the port
AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),2,bitcmp(uint8(handles.acces_final_valve+handles.dropcProg.odorValve),'uint8'));



%Wait for fv time and find out whether the mouse is poking
while (toc-start_toc<fvtime)
    noSamples=noSamples+1;
    if dropcNosePokeNow_ac(handles)==1
        noSamplesMouseOn=noSamplesMouseOn+1;
    end
end


%Turn on (or not) opto stimulus during odor delivery
opto_on=0;

%If this is not a short then give the light
if (noSamplesMouseOn/noSamples) > 0.2
    
    if handles.dropcProg.whenOptoOn==2
        %Change this statement if you want opt on in all trials or random trials
        if handles.dropcProg.odorValve==handles.dropcProg.splusOdorValve %for S+
            opto_on=1;
            handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=1;
        end
    end
    
end

%Notify INTAN of odor onset
switch handles.acces
    
    case 0
        %Notify INTAN
        if opto_on==0
            if (handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor)
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset+handles.dropcDraqOut.s_plus;
            else
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset;
            end
        else
            if (handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor)
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset+handles.dropcDraqOut.opto_on+handles.dropcDraqOut.s_plus;
            else
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset+handles.dropcDraqOut.opto_on;
            end
        end
        
        
        dropcUpdateDraqPort(handles);
    case 1
          %Notify draq
        if opto_on==0
            if (handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor)
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset+handles.dropcDraqOut.s_plus;
            else
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset;
            end
        else
            if (handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor)
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset+handles.dropcDraqOut.s_plus+handles.acces_laser;
            else
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset+handles.acces_laser;
            end
        end
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

end
