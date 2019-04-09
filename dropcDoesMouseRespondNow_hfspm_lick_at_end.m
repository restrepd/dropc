function [handles,didMouseRespond]=dropcDoesMouseRespondNow_hfspm_lick_at_end(handles)
%	Does the mouse respond?


%     didMouseRespond=1; Mouse responded 
%
%     didMouseRespond=0; Mouse did not respond
%


%First take animal through the short time
handles.dropcData.ii_lick(handles.dropcData.epochIndex)=0;
noSamples=0;
noSamplesMouseOn=0;
start_toc=toc;
didMousePoke=1;


%Now take the animal through the RA




reqSegments=handles.dropcProg.noRAsegments;


didLick=zeros(1,handles.dropcProg.noRAsegments);

for ii=1:handles.dropcProg.noRAsegments
    end_toc=toc+handles.dropcProg.dt_ra;
    this_toc=toc;
    while (this_toc<end_toc)
        %lickStatus=dropcGetLickStatus(handles);
        handles.dropcData.ii_lick(handles.dropcData.epochIndex)=handles.dropcData.ii_lick(handles.dropcData.epochIndex)+1;
        handles.dropcData.lick_toc(handles.dropcData.epochIndex,handles.dropcData.ii_lick(handles.dropcData.epochIndex))=this_toc;
        if (sum(getvalue(handles.dio.Line(25:32)))~=handles.dropcProg.sumNoLick)
            %sum(handles.dropcProg.noLick))
            %Mouse licked!
            didLick(ii)=1;
            handles.dropcData.lick(handles.dropcData.epochIndex,handles.dropcData.ii_lick(handles.dropcData.epochIndex))=1;
        else
            handles.dropcData.lick(handles.dropcData.epochIndex,handles.dropcData.ii_lick(handles.dropcData.epochIndex))=0;
        end
        this_toc=toc;
    end
    
end



%If mouse licked >= RA segments

if (didLick(end)==1)&(sum(didLick(1:end-1)==0))
    didMouseRespond=1;
else
    didMouseRespond=0;
end




