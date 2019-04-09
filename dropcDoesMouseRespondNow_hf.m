function didMouseRespond=dropcDoesMouseRespondNow_hf(handles)
%	Does the mouse respond?


%     didMouseRespond=1; Mouse responded 
%
%     didMouseRespond=0; Mouse did not respond
%
%     didMouseRespond=2; This was a short

%First take animal through the short time
noSamples=0;
noSamplesMouseOn=0;
start_toc=toc;
didMousePoke=1;
% while toc-start_toc<handles.dropcProg.shortTime
%     %noSamples=noSamples+1;
%     if dropcNosePokeNow(handles)==1
%         %noSamplesMouseOn=noSamplesMouseOn+1;
%         didMousePoke=1;
%     end
% end

%if (noSamplesMouseOn/noSamples) > 0.2
if didMousePoke==1
    %Now take the animal through the RA
    
     
    
    %         isLicking = 0;
    dt_ra=0;
%     if handles.dropcProg.typeOfOdor==4
        %This is a begin session
        group=floor((handles.dropcData.trialIndex-1)/20)+1;
        if (group<=2)
            reqSegments=1;
            dt_ra=0.1*handles.dropcProg.dt_ra;
        else
            if (group<=4)
                reqSegments=1+(handles.dropcProg.noRAsegments-1)/3;
                dt_ra=0.25*handles.dropcProg.dt_ra;
            else
                if (group<=6)
                    reqSegments=1+2*(handles.dropcProg.noRAsegments-1)/3;
                    dt_ra=0.7*handles.dropcProg.dt_ra;
                else
                    reqSegments=handles.dropcProg.noRAsegments;
                    dt_ra=handles.dropcProg.dt_ra;
                end
            end
        end
%         
%     else
%         %Otherwise the required number of segments is noRAsegments
%         reqSegments=handles.dropcProg.noRAsegments;
%     end
    
    didLick=zeros(1,handles.dropcProg.noRAsegments);
    
    for ii=1:handles.dropcProg.noRAsegments
        end_toc=toc+dt_ra;
        this_toc=toc;
        while (this_toc<end_toc)
            %lickStatus=dropcGetLickStatus(handles);
            handles.dropcData.ii_lick(handles.dropcData.trialIndex)=handles.dropcData.ii_lick(handles.dropcData.trialIndex)+1;
            handles.dropcData.lick_toc(handles.dropcData.trialIndex,handles.dropcData.ii_lick(handles.dropcData.trialIndex))=toc;
            if (sum(getvalue(handles.dio.Line(25:32)))~=handles.dropcProg.sumNoLick)
                %sum(handles.dropcProg.noLick))
                %Mouse licked!
                didLick(ii)=1;
                handles.dropcData.lick(handles.dropcData.trialIndex,handles.dropcData.ii_lick(handles.dropcData.trialIndex))=1;
            else
                handles.dropcData.lick(handles.dropcData.trialIndex,handles.dropcData.ii_lick(handles.dropcData.trialIndex))=0;
            end
            this_toc=toc;
        end
        
    end
    
    if sum(didLick)>=reqSegments
        didMouseRespond=1;
        %Notify odor on
        handles.dropcData.eventIndex=handles.dropcData.eventIndex+1;
        handles.dropcData.eventTime(handles.dropcData.eventIndex)=toc;
        handles.dropcData.event(handles.dropcData.eventIndex)=3;
    else
        didMouseRespond=0;
        %Notify odor on
        handles.dropcData.eventIndex=handles.dropcData.eventIndex+1;
        handles.dropcData.eventTime(handles.dropcData.eventIndex)=toc;
        handles.dropcData.event(handles.dropcData.eventIndex)=4;
    end
else
    %This is a short
    didMouseRespond=2;
    %Notify odor on
    handles.dropcData.eventIndex=handles.dropcData.eventIndex+1;
    handles.dropcData.eventTime(handles.dropcData.eventIndex)=toc;
    handles.dropcData.event(handles.dropcData.eventIndex)=5;
    if handles.dropcProg.sendShorts==1
        %Send a short
        %                             handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.short_after+handles.dropcDraqOut.draq_trigger;
        %                             dropcUpdateDraqPort(handles);
        %
        %                             start_toc=toc;
        %                             while toc-start_toc<0.2
        %                             end
        %
        %Extremely important. If you do not do this you do not transfer all
        %trials to the draq computer
        
        
        
        handles.dropcData.shortTime(handles.dropcData.shortIndex)=toc;
        handles.dropcData.shortType(handles.dropcData.shortIndex)=2;
        handles.dropcData.shortIndex(handles.dropcData.shortIndex)=handles.dropcData.shortIndex(handles.dropcData.shortIndex)+1;
        
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.short_after;
        dropcUpdateDraqPort(handles);
        start_toc=toc;
        while (toc-start_toc<0.3)
        end
        
        dropcStartDraq(handles)
        
        
    end
    pause(handles.dropcProg.timePerTrial)
end



