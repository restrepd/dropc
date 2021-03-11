function [handles,time_to_lick, did_lick]=dropcRewardOnBoth_hf(handles)
%	Give a reward when the mouse licks (worst comes to worst after
%	handles.dropcProg.dt_to_reinforcement seconds
%

did_lick=0;


start_toc=toc;
did_lick=0;
time_to_lick=0;

while ((time_to_lick<handles.dropcProg.dt_to_reinforcement)&(did_lick==0))
    if (sum(getvalue(handles.dio.Line(25:32)))~=handles.dropcProg.sumNoLick)
        did_lick=1;
    end
    time_to_lick=toc-start_toc;
end

dropcReinforceNow(handles);
handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.hit+handles.dropcDraqOut.draq_trigger;
dropcUpdateDraqPort(handles);







