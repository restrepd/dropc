function didMouseRespond=dropcDoesMouseRespondNowAud(handles)
%	Does the mouse respond?



%First take animal through the short time
noSamples=0;
noSamplesMouseOn=0;
start_toc=toc;
didMousePoke=0;
while toc-start_toc<handles.dropcProg.shortTime
    %noSamples=noSamples+1;
    if dropcNosePokeNow(handles)==1
        %noSamplesMouseOn=noSamplesMouseOn+1;
        didMousePoke=1;
    end
end

%if (noSamplesMouseOn/noSamples) > 0.2
if didMousePoke==1
    %Now take the animal through the RA
    didLick=zeros(1,handles.dropcProg.noRAsegments);


    %         isLicking = 0;

    if handles.dropcProg.typeOfOdor==4
        %This is a begin session
        group=floor((handles.dropcData.trialIndex-1)/20)+1;
        if (group<=2)
            reqSegments=1;
        else
            if (group<=4)
                reqSegments=1+(handles.dropcProg.noRAsegments-1)/3;
            else
                if (group<=6)
                    reqSegments=1+2*(handles.dropcProg.noRAsegments-1)/3;
                else
                    reqSegments=handles.dropcProg.noRAsegments;
                end
            end
        end

    else
        %Otherwise the required number of segments is noRAsegments
        reqSegments=handles.dropcProg.noRAsegments;
    end

%     dropcClick(handles)
    for ii=1:handles.dropcProg.noRAsegments
        end_toc=toc+handles.dropcProg.dt_ra;
%         if ((ii==2)&(handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor))
%             dropcClick(handles)
%         end
        while (toc<end_toc)
            %lickStatus=dropcGetLickStatus(handles);
            if (sum(getvalue(handles.dio.Line(25:32)))~=handles.dropcProg.sumNoLick)
                %sum(handles.dropcProg.noLick))
                %Mouse licked!
                didLick(ii)=1;
            end
        end
    end


    %         RAtime=handles.dropcProg.noRAsegments*handles.dropcProg.dt_ra;
    %         start_toc=toc;
    %
    %         while (toc-start_toc<RAtime)
    %
    %             lickStatus=dropcGetLickStatus(handles);
    %
    %             if (sum(lickStatus)~=sum(handles.dropcProg.noLick))
    %                 %Mouse licked!
    %                 didLick(1+floor((toc-start_toc)/handles.dropcProg.dt_ra))=1;
    %                 %Make sure to do autoShape if this is begin!!!
    %                 %autoShape(response, progStat, olfStat);
    %             end
    %         end

    %If mouse licked >= RA segments
    if sum(didLick)>=reqSegments
        didMouseRespond=1;
    else
        didMouseRespond=0;
    end
else
    %This is a short
    didMouseRespond=2;
    pause(handles.dropcProg.timePerTrial)
end



