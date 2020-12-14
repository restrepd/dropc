function finalValveOK = dropcFinalValveOKTiny(handles)
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


%Divert final valve towards the exhaust and odor valve on
putvalue(handles.dio.Line(1:4),uint8(handles.dropcProg.finalValve+handles.dropcProg.odorValve));



%Find out whether the mouse is poking
while (toc-start_toc<fvtime)
    noSamples=noSamples+1;
    if dropcNosePokeNowTiny(handles)==1
        noSamplesMouseOn=noSamplesMouseOn+1;
    end
end


%Turn FinalValve towards the odor port, leave odor on...)
putvalue(handles.dio.Line(1:4),uint8(handles.dropcProg.odorValve));

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
