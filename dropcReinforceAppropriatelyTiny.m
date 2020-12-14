function dropcReinforceAppropriatelyTiny(handles)
%Turns all valves off

do_dt_punish=0;

if handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor
    %S+
    if handles.dropcData.trialScore(handles.dropcData.trialIndex)==1

        %Hit
        start_toc=toc;
        while toc-start_toc<0.2
        end
        
        
        if rand(1)<=handles.dropcProg.fracReinforcement(1)
            
            dropcReinforceNowTiny(handles);
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=1;
            
        else
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
        end
        
    else

        %Miss

        start_toc=toc;
        while toc-start_toc<0.2
        end

        handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;

    end

end

if handles.dropcProg.typeOfOdor==handles.dropcProg.sminusOdor
    %S-

    if (handles.dropcProg.go_nogo==1)

        %This is a go_nogo
        if handles.dropcData.trialScore(handles.dropcData.trialIndex)==0

            %Correct Rejection

            start_toc=toc;
            while toc-start_toc<0.2
            end

            if rand(1)<=handles.dropcProg.fracReinforcement(2)

                dropcReinforceNowTiny(handles);
                handles.dropcData.isReinforced(handles.dropcData.trialIndex)=1;

            else
                handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
            end

        else

            %False Alarm


            start_toc=toc;
            while toc-start_toc<0.2
            end

            if handles.dropcProg.dt_punish>0
                do_dt_punish=1;
            end
                
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;

        end

    else

        %This is a go_go
        if handles.dropcData.trialScore(handles.dropcData.trialIndex)==0

            %Correct Rejection


            start_toc=toc;
            while toc-start_toc<0.2
            end

            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;


        else

            %False Alarm


            start_toc=toc;
            while toc-start_toc<0.2
            end

            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;

            if rand(1)<=handles.dropcProg.fracReinforcement(2)


                dropcReinforceNowTiny(handles);
                handles.dropcData.isReinforced(handles.dropcData.trialIndex)=1;

            else
                handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;

            end
        end
    end
end% end of S-

if do_dt_punish==1
    start_toc=toc;
    while toc-start_toc<handles.dropcProg.dt_punish
    end
end



