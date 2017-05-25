function dropcPurgeNow(handles)
%Opens final valve, purge valve for 3 sec




%Divert final valve towards the exhaust and noise
dataValue = handles.dropcDioOut.final_valve;
if handles.dropcProg.makeNoise==1
    dataValue = dataValue+handles.dropcDioOut.noise;
end
dataValue=bitcmp(dataValue);

putvalue(handles.dio.Line(17:24),dataValue);


%Divert purge valve towards the port and noise
dataValue = handles.dropcDioOut.purge_valve;
if handles.dropcProg.makeNoise==1
    dataValue = dataValue+handles.dropcDioOut.noise;
end
dataValue=bitcmp(dataValue);

putvalue(handles.dio.Line(17:24),dataValue);

start_toc=toc;
while toc-start_toc<3
end


%Turn FinalValve towards the odor port: turn on odor...)

dataValue=bitcmp(uint8(0));
putvalue(handles.dio.Line(17:24),dataValue);
