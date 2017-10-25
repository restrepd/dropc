function handles = dropcPuff(handles,odorNo,trialNo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Turn on odor valve
dataValue=handles.dropcProg.odorValve;
dataValue=bitcmp(uint8(dataValue));
putvalue(handles.dio.Line(1:8),dataValue);
handles.dropcReport.FVOn(odorNo,trialNo)=toc;

%Notify odor valve on
handles.dropcDigOut.draqPortStatus=uint8(4);
dropcUpdateDraqPort(handles);

%Wait for the final valve period
start_toc=toc;
while (toc-start_toc<handles.dropcProg.fvtime)
end

%Turn final valve towards exhaust and noise valve
dataValue = handles.dropcDioOut.final_valve;
if handles.dropcProg.makeNoise==1
    dataValue = dataValue+handles.dropcDioOut.noise;
end
dataValue=bitcmp(dataValue);
putvalue(handles.dio.Line(17:24),dataValue);
handles.dropcReport.odorOn(odorNo,trialNo)=toc;

%if handles.dropcProg.skipIntervals==0
start_toc=toc;
while (toc-start_toc<handles.dropcProg.odor_time)
end

%Turn off the odor valves
putvalue(handles.dio.Line(1:8),uint8(255));
handles.dropcReport.odorOff(odorNo,trialNo)=toc;

%Purge the odor off from the line
start_toc=toc;
while (toc-start_toc<handles.dropcProg.purge_time)
end

%Turn the FV back to the default position
putvalue(handles.dio.Line(17:24),uint8(255));
handles.dropcReport.purgeOff(odorNo,trialNo)=toc;


%Notify draq of odor number
handles.dropcDigOut.draqPortStatus=uint8(2^odorNo);
dropcUpdateDraqPort(handles);

start_toc=toc;
while (toc-start_toc<0.3)
end

%This is there to turn on the draq acquisition
dropcStartDraq(handles)

end

