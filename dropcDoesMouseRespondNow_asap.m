function didMouseRespond=dropcDoesMouseRespondNow_asap(handles)
%	Does the mouse respond?


%     didMouseRespond=1; Mouse responded
%
%     didMouseRespond=0; Mouse did not respond



didMouseRespond=0;

start_toc=toc;
while (toc<start_toc+handles.dropcProg.odor_stop)&(didMouseRespond==0)
    %lickStatus=dropcGetLickStatus(handles);
    if (sum(getvalue(handles.dio.Line(25:32)))~=handles.dropcProg.sumNoLick)
        %sum(handles.dropcProg.noLick))
        %Mouse licked!
        didMouseRespond=1;
    end
end





