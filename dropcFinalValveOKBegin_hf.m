function dropcFinalValveOKBegin_hf(handles)
%Opens final valve and odor on and finds out whtehr the mouse stays in the
%odor sampling area

start_toc=toc;

noSamples=0;
noSamplesMouseOn=0;



%During begin fvtime increases monotonically as a function of trialIndex
group=floor(handles.dropcData.trialIndex/20)+1;
if (group<=6)
    fvtime=(group-1)*handles.dropcProg.fvtime/5;
else
    fvtime=handles.dropcProg.fvtime;
end


%Notify draq, turn final valve and odor on, etc...


%Turn on (or not) opto stimulus
opto_on=0;
if handles.dropcProg.whenOptoOn==1
    if handles.dropcProg.randomOpto(handles.dropcData.fellowsNo)==1
        dataValue=uint8(0);
        putvalue(handles.dio.Line(9:12),dataValue);
        opto_on=1;
    end
end

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

%Notify FV
handles.dropcData.eventIndex=handles.dropcData.eventIndex+1;
handles.dropcData.eventTime(handles.dropcData.eventIndex)=toc;
handles.dropcData.event(handles.dropcData.eventIndex)=1;


%Divert final valve towards the exhaust and the purge valve towars the port
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




%if handles.dropcProg.skipIntervals==0
while (toc-start_toc<fvtime)
    noSamples=noSamples+1;
    if dropcNosePokeNow(handles)==1
        noSamplesMouseOn=noSamplesMouseOn+1;
    end
end
%end


%Turn on (or not) opto stimulus
opto_on=0;
if handles.dropcProg.whenOptoOn==2
    if handles.dropcProg.randomOpto(handles.dropcData.fellowsNo)==1
        dataValue=bitcmp(uint8(8));
        putvalue(handles.dio.Line(9:12),dataValue);
        opto_on=1;
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





dropcUpdateDraqPort(handles);


%Turn FinalValve towards the odor port: turn on odor...)
dataValue=bitcmp(uint8(0));
putvalue(handles.dio.Line(17:24),dataValue);

%Notify odor on
handles.dropcData.eventIndex=handles.dropcData.eventIndex+1;
handles.dropcData.eventTime(handles.dropcData.eventIndex)=toc;
handles.dropcData.event(handles.dropcData.eventIndex)=2;

%Turn opto TTL off
dataValue=uint8(15);
putvalue(handles.dio.Line(9:12),dataValue);


end
