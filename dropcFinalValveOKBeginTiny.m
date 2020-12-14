function finalValveOK = dropcFinalValveOKBeginTiny(handles)
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




%Divert final valve towards the exhaust and odor valve on
putvalue(handles.dio.Line(1:4),uint8(handles.dropcProg.finalValve+handles.dropcProg.odorValve));


%if handles.dropcProg.skipIntervals==0
    while (toc-start_toc<fvtime)
        noSamples=noSamples+1;
        if dropcNosePokeNowTiny(handles)==1
            noSamplesMouseOn=noSamplesMouseOn+1;
        end
    end
%end



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
