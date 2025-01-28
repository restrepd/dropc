function finalValveOK = dropcFinalValveOK_engram_spm(handles)
%Opens final valve and odor on and finds out whtehr the mouse stays in the
%odor sampling area

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

% handles.dropcProg.whenOptoOn=2;
% handles.dropcProg.fracOptoOn=0.3;

%Notify draq, turn final valve and odor on, etc...


%Turn on (or not) opto stimulus during FV
opto_on=0;
handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=0;
% if handles.dropcProg.whenOptoOn==1
%      %if handles.dropcProg.odorValve==handles.dropcProg.splusOdorValve %for S+
%     %if handles.dropcProg.odorValve==handles.dropcProg.sminusOdorValve %for S-
%     %if you want to randomly send TTL opto uncomment this line
%     %         if handles.dropcProg.randomOpto(handles.dropcData.fellowsNo)==1
%     dataValue=bitand(bitcmp(uint8(8)),15); %Turns 12 on
%     putvalue(handles.dio.Line(9:12),dataValue);
%     opto_on=1;
%     handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=1;
%     %         end
%     %end
%    
% end

%Notify draq
if opto_on==0
    if (handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor)
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.s_plus;
    else
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve;
    end
else
    if (handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor)
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.opto_on+handles.dropcDraqOut.s_plus;
    else
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.opto_on;
    end
end
dropcUpdateDraqPort(handles);

%Turn on final valve towards the exhaust and noise valve
dataValue = handles.dropcDioOut.final_valve;
if handles.dropcProg.makeNoise==1
    dataValue = dataValue+handles.dropcDioOut.noise;
end
dataValue=bitcmp(dataValue);

putvalue(handles.dio.Line(17:24),dataValue);


%Turn on odor valve

%Turn on odor valve
dataValue=handles.dropcProg.odorValve;
dataValue=bitcmp(uint8(dataValue));
putvalue(handles.dio.Line(1:8),dataValue);




%Turn on background valve if needed
%     if handles.dropcProg.backgroundOdor==1
%         dataValue=handles.dropcDioOut.background_valve;
%         dataValue=bitcmp(dataValue);
%
%         putvalue(handles.dio.Line(9:16),dataValue);
%
%     end



%if handles.dropcProg.skipIntervals==0
while (toc-start_toc<fvtime)
    noSamples=noSamples+1;
    if dropcNosePokeNow(handles)==1
        noSamplesMouseOn=noSamplesMouseOn+1;
    end
end
%end


%Turn on (or not) opto stimulus during odor delivery
opto_on=0;

%If this is not a short then give the light
if (noSamplesMouseOn/noSamples) > 0.2

    if (handles.dropcProg.whenOptoOn==2)
        
        if handles.dropcProg.fracOptoOn(handles.dropcData.allTrialIndex+1)<=0.3
            %if handles.dropcProg.odorValve==handles.dropcProg.sminusOdorValve %for S-
            %if you want to randomly send TTL opto uncomment this line
            %         if handles.dropcProg.randomOpto(handles.dropcData.fellowsNo)==1
            dataValue=bitand(bitcmp(uint8(8)),15); %Turns laser on
            putvalue(handles.dio.Line(9:12),dataValue);
            opto_on=1;
            handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=1;
            %         end
        end
        start_toc=toc;
        while toc-start_toc<0.1
        end
    end
    
end

%Notify draq of odor onset

%Notify draq
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


% if (handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor)
%     handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset+handles.dropcDraqOut.tdt_inhibit+handles.dropcDraqOut.s_plus;
% else
%     handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset+handles.dropcDraqOut.tdt_inhibit;
% end


dropcUpdateDraqPort(handles);


%Turn FinalValve towards the odor port: turn on odor...)
dataValue=bitcmp(uint8(0));
putvalue(handles.dio.Line(17:24),dataValue);



%Turn opto TTL off

dataValue=uint8(15);
putvalue(handles.dio.Line(9:12),dataValue);


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
