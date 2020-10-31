function finalValveOK = dropcFinalValveOK_WM1_ac(handles)
%Opens final valve, purge valve odor on and finds out whtehr the mouse stays in the
%odor sampling area

start_toc=toc;

noSamples=0;
noSamplesMouseOn=0;



%Otherwise, fvtime falls randomly between 1 and 1.5
fvtime = 0.666666*handles.dropcProg.fvtime +0.333333*handles.dropcProg.fvtime*rand(1);


%Notify draq, turn final valve and odor on, etc...


%Turn on (or not) opto stimulus during FV
opto_on=0;
handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=0;
if (handles.dropcProg.whenOptoOn==1)
    % if handles.dropcProg.odorValve==handles.dropcProg.splusOdorValve %for S+
    %if handles.dropcProg.odorValve==handles.dropcProg.sminusOdorValve %for S-
    %if you want to randomly send TTL opto uncomment this line
    %         if handles.dropcProg.randomOpto(handles.dropcData.fellowsNo)==1
    dataValue=uint8(0);
    putvalue(handles.dio.Line(9:12),dataValue);
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


%Divert final valve towards the exhaust and open purge valve
AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),2,bitcmp(uint8(handles.acces_final_valve+...
    handles.acces_purge_valve),'uint8'));


%Turn on (or not) opto stimulus during odor delivery
opto_on=0;

% %If this is not a short then give the light
% if (noSamplesMouseOn/noSamples) > 0.2
    
    if handles.dropcProg.whenOptoOn==2
        if handles.dropcProg.odorValve==handles.dropcProg.splusOdorValve %for S+
            %if handles.dropcProg.odorValve==handles.dropcProg.sminusOdorValve %for S-
            %if you want to randomly send TTL opto uncomment this line
            %         if handles.dropcProg.randomOpto(handles.dropcData.fellowsNo)==1
            dataValue=uint8(0);
            putvalue(handles.dio.Line(9:12),dataValue);
            opto_on=1;
            handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=1;
            %         end
        end
    end
    
% end

%Notify draq of odor 1
%Notify draq
if opto_on==0
    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor1;
else
    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor1+handles.dropcDraqOut.opto_on;
end

AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,uint8(handles.dropcDigOut.draqPortStatus));


%Turn FinalValve towards the odor port: turn on odor...)
AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),2,bitcmp(uint8(handles.dropcProg.odorValve),'uint8'));


finalValveOK=1;



