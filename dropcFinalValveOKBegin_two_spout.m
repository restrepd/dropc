function finalValveOK = dropcFinalValveOKBegin_two_spout(handles)
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




%Notify INTAN
handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve;
dropcUpdateDraqPort(handles);


%Divert final valve towards the exhaust and the purge valve towars the port
dataValue = handles.dropcDioOut.final_valveLeft+handles.dropcDioOut.final_valveRight;
if handles.dropcProg.makeNoise==1
    dataValue = dataValue+handles.dropcDioOut.noise;
end
dataValue=bitcmp(dataValue);

putvalue(handles.dio.Line(17:24),dataValue);


%Turn on odor valve
dataValue=handles.dropcProg.odorValveLeft+handles.dropcProg.odorValveRight;
dataValue=bitcmp(uint8(dataValue));

putvalue(handles.dio.Line(1:8),dataValue);


while (toc-start_toc<fvtime)
    noSamples=noSamples+1;
    if sum(getvalue(handles.dio.Line(27:28)))~=2
        noSamplesMouseOn=noSamplesMouseOn+1;
    end
end

%Notify INTAN of odor onset
handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset;
dropcUpdateDraqPort(handles);


%Turn FinalValve towards the odor port: turn on odor...)
dataValue=bitcmp(uint8(0));
putvalue(handles.dio.Line(17:24),dataValue);


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
