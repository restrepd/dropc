function dropcTurnOdorValveOnNowWithFinalV(handles,odorNo)
%Notify draq, turn final valve and odor on, etc...



%Turn on final valve and noise valve
dataValue = handles.dropcDioOut.final_valve;
if handles.dropcProg.makeNoise==1
    dataValue = dataValue+handles.dropcDioOut.noise;
end
dataValue=bitcmp(dataValue);
putvalue(handles.dio.Line(17:24),dataValue);


%Turn on odor valve
dataValue=handles.dropcProg.odorValve;
dataValue=bitcmp(uint8(dataValue));
putvalue(handles.dio.Line(1:8),dataValue);

%Notify FV on
handles.dropcDigOut.draqPortStatus=uint8(4);
dropcUpdateDraqPort(handles);

%Wait for the final valve period
start_toc=toc;
while (toc-start_toc<handles.dropcProg.fvtime)
end

%Start of odor
handles.dropcDigOut.draqPortStatus=uint8(16);
dropcUpdateDraqPort(handles);

%Turn FinalValve towards the odor port: turn on odor...)
dataValue=bitcmp(uint8(0));
putvalue(handles.dio.Line(17:24),dataValue);



