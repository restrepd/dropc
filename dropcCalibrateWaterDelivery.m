%dropcCalibrateWaterDelivery
%
% Delivers reinforcement water to calibrate water deivery
%
%
tic
handles.no_valve_openings=50;
handles.sec_between_valve_openings=1;

%Enter time for water delivery (sec, try 0.5 s)
handles.dropcProg.rfTime=0.15;

%To open pin 17 enter 1
%To open pin 19 (2nd water valve in two pipe) enter 8
handles.dropcDioOut.water_valve=uint8(8);

handles=dropcInitializePortsNow(handles);


for ii=1:handles.no_valve_openings
    
    disp(['Valve opening number= ' num2str(ii)])
    
    %Turn on water valve
    dataValue=handles.dropcDioOut.water_valve;
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(17:24),dataValue);
    
    %Wait for rfTime
    start_time=toc;
    while (toc-start_time<handles.dropcProg.rfTime)
    end
    
    %Turn off water valve
    dataValue=uint8(0);
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(17:24),dataValue);
    
    %Wait for sec_between_valve_openings
    start_time=toc;
    while (toc-start_time<handles.sec_between_valve_openings)
    end
    
end
